import Battle from '../models/battle.js';
import Club from '../models/club.js';
import User from '../models/user.js';
import BattleGrade from '../models/BattleGrade.js';

const createBattle = async (req, res) => {
    try {
        const { date, time } = req.body;
        const club_id = req.params.id;
        const creator_id = req.user.id;
        if (!date) return res.status(400).json({ success: false, message: 'Date is required' });
        const battle = await Battle.create({ club_id, creator_id, date, time });
        return res.status(201).json({ success: true, battle });
    } catch (error) {
        console.error('Error creating battle:', error);
        return res.status(500).json({ success: false, message: 'Internal server error' });
    }
};

const getUserBattles = async (req, res) => {
    try {
        const userId = req.user.id;
        const battles = await Battle.findAll({
            include: [
                {
                    model: Club,
                    as: 'club',
                    required: true,
                    include: [{
                        model: User,
                        as: 'members',
                        where: { id: userId },
                        required: true,
                        attributes: []
                    }],
                    attributes: ['id', 'name']
                },
                {
                    model: BattleGrade,
                    as: 'battleGrades',
                    where: { user_id: userId },
                    required: false,
                    attributes: ['id']
                }
            ],
            order: [['date', 'ASC']]
        });

        const now = new Date();
        const battlesWithStatus = battles.map(battle => {
            const b = battle.toJSON();
            const battleDate = new Date(b.date);
            const diffHours = (battleDate - now) / (1000 * 60 * 60);
            if (diffHours > 1) {
                b.status = 'scheduled';
            } else if (diffHours >= -2 && diffHours <= 1) {
                b.status = 'ongoing';
            } else {
                b.status = 'finished';
            }
            b.grade_added = b.battleGrades && b.battleGrades.length > 0;
            console.log(b.id, b.status, b.grade_added);
            return b;
        });

        return res.status(200).json({ success: true, battles: battlesWithStatus });
    } catch (error) {
        console.error('Error fetching battles:', error);
        return res.status(500).json({ success: false, message: 'Internal server error' });
    }
};

const markGradeAdded = async (req, res) => {
    try {
        const { battleId } = req.params;
        const userId = req.user.id;
        await BattleGrade.findOrCreate({
            where: { battle_id: battleId, user_id: userId }
        });
        return res.status(200).json({ success: true });
    } catch (error) {
        console.error('Error marking grade added:', error);
        return res.status(500).json({ success: false, message: 'Internal server error' });
    }
};

export { createBattle, getUserBattles, markGradeAdded   };