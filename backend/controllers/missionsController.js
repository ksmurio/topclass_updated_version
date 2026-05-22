import { Op } from 'sequelize';
import Mission from '../models/missions.js';
import UserMission from '../models/userMissions.js';

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

    console.log('weekStart:', weekStart);
    console.log('weekEnd:', weekEnd);

    const missions = await Mission.findAll({
      where: { due_date: { [Op.between]: [weekStart, weekEnd] } },
      order: [['due_date', 'ASC']],
    });

    console.log('missões encontradas:', missions.length);

    const completed = await UserMission.findAll({ where: { user_id } });
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
    console.error('ERRO:', e.message);
    return res.status(500).json({ success: false, message: e.message });
  }
};

export { getMissions };