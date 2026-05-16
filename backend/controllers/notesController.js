import jwt from 'jsonwebtoken';
import User from '../models/user.js';
import Notes from '../models/notes.js';

const saveNotes = async (req, res) => {
    const token = req.headers.authorization?.split(" ")[1];

    if (!token) {
        return res.status(401).json({ success: false, message: "No token provided" });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const user_id = decoded.id;

        const user = await User.findByPk(user_id);
        if (!user) {
            return res.status(404).json({ success: false, message: "User not found" });
        }

        const { title, content } = req.body;

        if (!title || !content) {
            return res.status(400).json({
                success: false,
                message: "Title and content are required"
            });
        }

        const note = await Notes.create({
            title,
            content,
            user_id
        });

        return res.status(201).json({
            success: true,
            note
        });

    } catch (error) {
        console.error("ERRO saveNotes:", error);
        return res.status(500).json({
            success: false,
            message: 'Error creating note',
            error: error.message
        });
    }
};

const getNotes = async (req, res) => {
    const token = req.headers.authorization?.split(" ")[1];

    if (!token) {
        return res.status(401).json({ success: false, message: "No token provided" });
    }

    try {
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const user_id = decoded.id;

        const notes = await Notes.findAll({
            where: { user_id },
            order: [['created_at', 'DESC']],
        });

        return res.status(200).json({
            success: true,
            notes
        });

    } catch (error) {
        console.error("ERRO getNotes:", error);
        return res.status(500).json({
            success: false,
            message: 'Error fetching notes',
            error: error.message
        });
    }
};

const deleteNote = async (req, res) => {
  try {
    const noteId = req.params.id;
    const userId = req.user.id;
    const note = await Notes.findOne({ where: { id: noteId, user_id: userId } }); 
    if (!note) return res.status(404).json({ success: false, message: 'Note not found' });
    await note.destroy();
    return res.status(200).json({ success: true, message: 'Note deleted' });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

export { saveNotes, getNotes, deleteNote };