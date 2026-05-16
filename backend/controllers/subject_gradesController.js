import SubjectGrade from '../models/subject_grades.js';
import Subject from '../models/subject.js';
import User from "../models/user.js";

const updateGlobalAverage = async (user_id) => {
  let counter = 0;
  let sumGrades = 0;
  try {
    const grades = await SubjectGrade.findAll({ where: { user_id } });
    grades.forEach((element) => {
      const gradeValue = parseFloat(element.grade);
      if (!isNaN(gradeValue)) {
        counter += 1;
        sumGrades += gradeValue;
      }
    });
    const average = counter > 0 ? (sumGrades / counter).toFixed(2) : 0;
    await User.update({ global_average: average }, { where: { id: user_id } });
    console.log('Global average updated:', average);
  } catch (error) {
    console.error('Error updating global average:', error);
  }
};

const addGrade = async (req, res) => {
  const { subject_id, grade } = req.body;
  try {
    const user = await User.findOne({ where: { id: req.user.id } });
    await SubjectGrade.create({
      user_id: user.id,
      subject_id,
      grade,
    });
    await updateGlobalAverage(user.id);
    return res.status(201).json({ success: true, message: "Grade added successfully" });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ success: false, message: "Error adding grade" });
  }
};

const getUserGradesChart = async (req, res) => {
  try {
    const userId = req.user.id;
    const grades = await SubjectGrade.findAll({
      where: { user_id: userId },
      include: [{ model: Subject, as: 'subject', attributes: ['name'] }],
    });
    if (!grades || grades.length === 0) {
      return res.status(200).json({ success: false, message: "Nenhuma nota encontrada!" });
    }
    const map = {};
    grades.forEach(g => {
      const name = g.subject?.name;
      if (!name) return;
      if (!map[name]) map[name] = { total: 0, count: 0 };
      map[name].total += parseFloat(g.grade);
      map[name].count++;
    });
    const result = Object.entries(map).map(([name, v]) => ({
      subject: name,
      average: (v.total / v.count).toFixed(2)
    }));
    return res.status(200).json({ success: true, grades: result });
  } catch (error) {
    console.error('Error fetching grades chart:', error);
    return res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

const getGradesHistory = async (req, res) => {
  try {
    const userId = req.user.id;
    const grades = await SubjectGrade.findAll({
      where: { user_id: userId },
      include: [{ model: Subject, as: 'subject', attributes: ['name'] }],
      order: [['graded_at', 'ASC']],
    });
    if (!grades || grades.length === 0) {
      return res.status(200).json({ success: false, message: 'Nenhuma nota encontrada!' });
    }
    const map = {};
    grades.forEach(g => {
      const name = g.subject?.name;
      if (!name) return;
      if (!map[name]) map[name] = [];
      map[name].push({
        grade: parseFloat(g.grade),
        date: g.graded_at,
      });
    });
    const result = Object.entries(map).map(([subject, entries]) => ({
      subject,
      entries,
    }));
    return res.status(200).json({ success: true, grades: result });
  } catch (error) {
    console.error('Error fetching grades history:', error);
    return res.status(500).json({ success: false, message: 'Internal server error' });
  }
};

export { addGrade, getUserGradesChart, getGradesHistory };