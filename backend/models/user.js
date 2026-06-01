import { DataTypes } from 'sequelize';
import sequelize from '../config/db.js';
import bcrypt from 'bcryptjs';

const User = sequelize.define('User', {
  id: {
    type: DataTypes.CHAR(36),
    primaryKey: true,
    defaultValue: DataTypes.UUIDV4
  },
  name: {
    type: DataTypes.STRING(255),
    allowNull: false
  },
  username: {
    type: DataTypes.STRING(255),
    allowNull: false,
    unique: true
  },
  email: {
    type: DataTypes.STRING(255),
    allowNull: false,
    unique: true,
    validate: { isEmail: true }
  },
  password: {
    type: DataTypes.STRING(255),
    allowNull: false
  },
  global_average: {
    type: DataTypes.DECIMAL(4, 2),
    defaultValue: 0
  },
  profile_picture: {
    type: DataTypes.STRING(255),
    allowNull: true
  },
  can_create_battle: {
    type: DataTypes.TINYINT(1),
    defaultValue: 0
  },
  school_year: {
    type: DataTypes.TINYINT.UNSIGNED,
    allowNull: true,
    validate: { min: 1, max: 12 }
  },
  points: {
  type: DataTypes.INTEGER,
  defaultValue: 0
  },
  is_verified: {
    type: DataTypes.TINYINT(1),
    defaultValue: 0
  },
  verification_code: {
    type: DataTypes.STRING(6),
    allowNull: true
  }
}, {
  tableName: 'users',
  timestamps: false,
  hooks: {
    beforeCreate: async (user) => {
      user.password = await bcrypt.hash(user.password, 10);
    }
  }
});

export default User;