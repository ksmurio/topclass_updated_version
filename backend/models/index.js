import sequelize from '../config/db.js';
import User from './user.js';
import Club from './club.js';
import { initAssociations } from './associations.js';
import Battle from './battle.js';
import SubjectGrade from './subject_grades.js';
import Subject from './subject.js';
import ClubPost from './clubPost.js';
import ClubComment from './clubComment.js';

initAssociations();

const db = {
  User,
  Club,
  Battle,
  SubjectGrade,
  Subject,
  sequelize,
  ClubPost,
  ClubComment,
};

console.log('Modelos e associações carregados!');
export default db;
export { User, Club, Battle, SubjectGrade, Subject, ClubPost, ClubComment, sequelize };