import { DataTypes } from 'sequelize';
import sequelize from '../config/db.js';

const UserMission = sequelize.define("UserMission", {
  id: {
    type: DataTypes.CHAR(36),
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  user_id: {
    type: DataTypes.CHAR(36),
    allowNull: true
  },
  mission_id: {
    type: DataTypes.CHAR(36),
    allowNull: true
  },
  points: {
    type: DataTypes.INTEGER,
    allowNull: true
  },
  completed_at: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  }
}, {
  tableName: 'user_missions',
  timestamps: false,
  underscored: true
});

export default UserMission;