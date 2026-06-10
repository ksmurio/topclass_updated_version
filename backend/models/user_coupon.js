import { DataTypes } from 'sequelize';
import sequelize from '../config/db.js';

const UserCoupon = sequelize.define('UserCoupon', {
  id: {
    type: DataTypes.CHAR(36),
    primaryKey: true,
    defaultValue: DataTypes.UUIDV4
  },
  user_id: {
    type: DataTypes.CHAR(36),
    allowNull: false
  },
  coupon_id: {
    type: DataTypes.CHAR(36),
    allowNull: false
  },
  code: {
    type: DataTypes.STRING(50),
    allowNull: false,
    unique: true
  }
}, {
  tableName: 'user_coupons',
  timestamps: true,
  createdAt: 'purchased_at',
  updatedAt: false
});

export default UserCoupon;