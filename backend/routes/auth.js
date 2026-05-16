import express from 'express';
import multer from 'multer';
import path from 'path'; 
import { register, login, getUser, verifyEmail } from '../controllers/authController.js'; 
import { show_clubs, create_club, load_club, joinClub, deleteMember, deleteClub, get_subjects, leaveClub } from '../controllers/clubController.js';
import { getSubjects } from '../controllers/subjectController.js';
import { addGrade, getUserGradesChart, getGradesHistory } from '../controllers/subject_gradesController.js';
import { verifyToken } from '../middleware/authmiddleware.js';
import { createBattle, getUserBattles } from '../controllers/battleController.js';
import { saveNotes, getNotes } from '../controllers/notesController.js';

const storage = multer.diskStorage({ // diskStorage significa que os ficheiros vão para o disco (pasta do servidor)
    destination: (req, file, cb) => {
        cb(null, 'uploads/');  // vai para a pasta uploads
    },
    filename: (req, file, cb) => {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
        cb(null, uniqueSuffix + path.extname(file.originalname)); 
    }
});

const upload = multer({ storage });
const router = express.Router();


router.post('/register', upload.single('profile_picture'), register);
router.post('/login', login);
router.post('/verify-email', verifyEmail);
router.get('/user', verifyToken, getUser);


router.post('/create_club', verifyToken, upload.single('image'), create_club);
router.get('/clubs', verifyToken, show_clubs);
router.get('/club/:id', verifyToken, load_club);
router.post('/club/:id', verifyToken, joinClub);
router.delete('/club/:id', verifyToken, deleteClub);
router.delete('/club/:id/member/:memberId', verifyToken, deleteMember);
router.delete('/club/:id/leave', leaveClub);


router.post('/club/:id/battle', verifyToken, createBattle);
router.get('/battles', verifyToken, getUserBattles);


router.get('/getSubjects', verifyToken, getSubjects);
router.get('/subjects', get_subjects);
router.post('/addGrade', verifyToken, addGrade);
router.get('/grades/chart', verifyToken, getUserGradesChart);
router.get('/grades/history', verifyToken, getGradesHistory);

router.post('/saveNotes', verifyToken, saveNotes);
router.get('/getNotes', verifyToken, getNotes);


export default router;