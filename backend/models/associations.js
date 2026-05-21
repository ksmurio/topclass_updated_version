import User from "./user.js";
import Club from "./club.js";
import Battle from "./battle.js";
import SubjectGrade from "./subject_grades.js";
import Subject from "./subject.js";
import ClubPost from "./clubPost.js";
import ClubComment from "./clubComment.js";
import BattleGrade from "./battleGrade.js";

const initAssociations = () => {
  User.belongsToMany(Club, {
    through: "user_clubs",
    foreignKey: "user_id",
    otherKey: "club_id",
    as: "joinedClubs",
    timestamps: false,
  });
  Club.belongsToMany(User, {
    through: "user_clubs",
    foreignKey: "club_id",
    otherKey: "user_id",
    as: "members",
    timestamps: false,
  });
  Club.belongsTo(User, {
    foreignKey: "creator_id",
    as: "creator",
  });
  User.hasMany(Club, {
    foreignKey: "creator_id",
    as: "createdClubs",
  });

  Battle.belongsTo(Club, {
    foreignKey: "club_id",
    as: "club",
  });

  Club.hasMany(Battle, {
    foreignKey: "club_id",
    as: "battles",
  });

  Club.belongsTo(Subject, {
    foreignKey: "club_type",
    as: "subject",
  });

  Battle.belongsTo(User, {
    foreignKey: "creator_id",
    as: "creator",
  });

  User.hasMany(Battle, {
    foreignKey: "creator_id",
    as: "createdBattles",
  });

  SubjectGrade.belongsTo(Subject, {
    foreignKey: "subject_id",
    as: "subject",
  });

  Subject.hasMany(SubjectGrade, {
    foreignKey: "subject_id",
    as: "grades",
  });

  ClubPost.belongsTo(User, {
    foreignKey: "user_id",
    as: "user",
  });

  ClubPost.hasMany(ClubComment, {
    foreignKey: "post_id",
    as: "comments",
  });

  ClubComment.belongsTo(User, {
    foreignKey: "user_id",
    as: "user",
  });

  ClubComment.belongsTo(ClubPost, {
    foreignKey: "post_id",
    as: "post",
  });

  Battle.hasMany(BattleGrade, {
    foreignKey: "battle_id",
    as: "battleGrades",
  });

  BattleGrade.belongsTo(Battle, {
    foreignKey: "battle_id",
    as: "battle",
  });

  BattleGrade.belongsTo(User, {
    foreignKey: "user_id",
    as: "user",
  });

  User.hasMany(BattleGrade, {
    foreignKey: "user_id",
    as: "battleGrades",
  });
};

export { initAssociations };  