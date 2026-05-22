import { DataTypes } from 'sequelize';
import sequelize from '../config/db.js';

const Mission = sequelize.define("Mission", {
  id: {
    type: DataTypes.CHAR(36),
    defaultValue: DataTypes.UUIDV4,
    primaryKey: true
  },
  creator_id: {
    type: DataTypes.CHAR(36),
    allowNull: true
  },
  name: {
    type: DataTypes.STRING(255),
    allowNull: false
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  due_date: {
    type: DataTypes.DATEONLY,
    allowNull: true
  },
  created_at: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  }
}, {
  tableName: 'missions',
  timestamps: false,
  underscored: true
});

export default Mission;