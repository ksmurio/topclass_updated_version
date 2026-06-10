import { v4 as uuidv4 } from 'uuid';
import Coupon from '../models/coupon.js';
import UserCoupon from '../models/user_coupon.js';
import User from '../models/user.js';
import sequelize from '../config/db.js';

const generateCode = (prefix) => {
  const rand = Math.random().toString(36).substring(2, 7).toUpperCase();
  const ts = Date.now().toString(36).toUpperCase();
  return `${prefix}-${ts}-${rand}`;
};

const getCoupons = async (req, res) => {
  try {
    const coupons = await Coupon.findAll({
      where: { active: 1 },
      order: [['points_cost', 'ASC']]
    });
    return res.json({ success: true, coupons });
  } catch (e) {
    return res.status(500).json({ success: false, message: e.message });
  }
};

const buyCoupon = async (req, res) => {
  const t = await sequelize.transaction();
  try {
    const user_id = req.user.id;
    const { couponId } = req.params;

    const [coupon, user] = await Promise.all([
      Coupon.findByPk(couponId),
      User.findByPk(user_id)
    ]);

    if (!coupon || !coupon.active)
      return res.status(404).json({ success: false, message: 'Coupon não encontrado.' });

    if (user.points < coupon.points_cost)
      return res.status(400).json({ success: false, message: 'Pontos insuficientes.' });

    if (coupon.stock !== -1 && coupon.stock <= 0)
      return res.status(400).json({ success: false, message: 'Coupon esgotado.' });

    let code;
    let attempts = 0;
    do {
      code = generateCode(coupon.code_prefix);
      const existing = await UserCoupon.findOne({ where: { code }, transaction: t });
      if (!existing) break;
      attempts++;
    } while (attempts < 5);

    await Promise.all([
      User.decrement('points', { by: coupon.points_cost, where: { id: user_id }, transaction: t }),
      UserCoupon.create({ id: uuidv4(), user_id, coupon_id: couponId, code }, { transaction: t }),
      coupon.stock !== -1
        ? Coupon.decrement('stock', { by: 1, where: { id: couponId }, transaction: t })
        : Promise.resolve()
    ]);

    await t.commit();
    return res.json({
      success: true,
      code,
      points_spent: coupon.points_cost,
      message: `Coupon comprado! O teu código: ${code}`
    });
  } catch (e) {
    await t.rollback();
    return res.status(500).json({ success: false, message: e.message });
  }
};

const getMyCoupons = async (req, res) => {
  try {
    const user_id = req.user.id;
    const myCoupons = await UserCoupon.findAll({
      where: { user_id },
      include: [{ model: Coupon, as: 'coupon' }],
      order: [['purchased_at', 'DESC']]
    });
    return res.json({ success: true, coupons: myCoupons });
  } catch (e) {
    return res.status(500).json({ success: false, message: e.message });
  }
};

export { getCoupons, buyCoupon, getMyCoupons };