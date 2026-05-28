import { DataTypes } from 'sequelize';
import sequelize from '../config/db.js';

const ClubPost = sequelize.define('ClubPost', {
  id: {
    type: DataTypes.CHAR(36),
    primaryKey: true,
    defaultValue: DataTypes.UUIDV4
  },
  club_id: {
    type: DataTypes.CHAR(36),
    allowNull: false
  },
  user_id: {
    type: DataTypes.CHAR(36),
    allowNull: false
  },
  content: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  image: {
    type: DataTypes.STRING,
    allowNull: true,
    defaultValue: null
  },
  created_at: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  }
}, {
  tableName: 'club_posts',
  timestamps: false
});

export default ClubPost;