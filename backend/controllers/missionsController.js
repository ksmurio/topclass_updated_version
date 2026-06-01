import { Op } from 'sequelize';
import Mission from '../models/missions.js';
import UserMission from '../models/userMissions.js';
import User from '../models/user.js';

const getMissions = async (req, res) => {
  try {
    const user_id = req.user.id;
    const now = new Date();

    const weekStart = new Date(now);
    weekStart.setDate(now.getDate() - now.getDay());
    weekStart.setHours(0, 0, 0, 0);

    const weekEnd = new Date(weekStart);
    weekEnd.setDate(weekStart.getDate() + 6);
    weekEnd.setHours(23, 59, 59, 999);

    const [missions, completed] = await Promise.all([
      Mission.findAll({
        where: { due_date: { [Op.between]: [weekStart, weekEnd] } },
        order: [['due_date', 'ASC']],
      }),
      UserMission.findAll({ where: { user_id } }),
    ]);

    const completedIds = new Set(completed.map(u => u.mission_id));

    return res.json({
      success: true,
      missions: missions.map(m => ({
        id: m.id,
        name: m.name,
        description: m.description,
        due_date: m.due_date,
        completed: completedIds.has(m.id),
      })),
    });
  } catch (e) {
    return res.status(500).json({ success: false, message: e.message });
  }
};

const completeMission = async (req, res) => {
  try {
    const user_id = req.user.id;
    const mission_id = req.params.mission_id;

    const already = await UserMission.findOne({ where: { user_id, mission_id } });
    if (already) return res.json({ success: false, message: 'Missão já completada.' });

    const mission = await Mission.findByPk(mission_id);
    if (!mission) return res.status(404).json({ success: false, message: 'Missão não encontrada.' });

    const points = 10; 

  
    await Promise.all([
      UserMission.create({ user_id, mission_id, points }),
      User.increment('points', { by: points, where: { id: user_id } }),
    ]);

    return res.json({ success: true, points_earned: points });
  } catch (e) {
    return res.status(500).json({ success: false, message: e.message });
  }
};

export { getMissions, completeMission };