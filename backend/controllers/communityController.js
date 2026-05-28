import jwt from 'jsonwebtoken';
import ClubPost from '../models/clubPost.js';
import ClubComment from '../models/clubComment.js';
import User from '../models/user.js';

const getPosts = async (req, res) => {
    try {
        const clubId = req.params.id;
        const posts = await ClubPost.findAll({
            where: { club_id: clubId },
            order: [['created_at', 'DESC']],
            include: [
                {
                    model: User,
                    as: 'user',
                    attributes: ['id', 'username', 'profile_picture']
                },
                {
                    model: ClubComment,
                    as: 'comments',
                    include: [{
                        model: User,
                        as: 'user',
                        attributes: ['id', 'username', 'profile_picture']
                    }]
                }
            ]
        });
        return res.status(200).json({ success: true, posts });
    } catch (error) {
        console.error('Erro getPosts:', error);
        return res.status(500).json({ success: false, message: error.message });
    }
};

const createPost = async (req, res) => {
    try {
        const clubId = req.params.id;
        const token = req.headers.authorization?.split(' ')[1];
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const { content } = req.body;

        if (!content) return res.status(400).json({ success: false, message: 'Conteúdo obrigatório' });

        // Se foi enviada uma imagem via multer, req.file estará disponível
        const imagePath = req.file ? req.file.filename : null;

        const post = await ClubPost.create({
            club_id: clubId,
            user_id: decoded.id,
            content,
            image: imagePath
        });

        return res.status(201).json({ success: true, post });
    } catch (error) {
        console.error('Erro createPost:', error);
        return res.status(500).json({ success: false, message: error.message });
    }
};

const createComment = async (req, res) => {
    try {
        const postId = req.params.postId;
        const token = req.headers.authorization?.split(' ')[1];
        const decoded = jwt.verify(token, process.env.JWT_SECRET);
        const { content } = req.body;

        if (!content) return res.status(400).json({ success: false, message: 'Conteúdo obrigatório' });

        const comment = await ClubComment.create({
            post_id: postId,
            user_id: decoded.id,
            content
        });

        return res.status(201).json({ success: true, comment });
    } catch (error) {
        console.error('Erro createComment:', error);
        return res.status(500).json({ success: false, message: error.message });
    }
};

export { getPosts, createPost, createComment };