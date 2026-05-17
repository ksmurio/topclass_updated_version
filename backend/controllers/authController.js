import User from "../models/user.js";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import sendVerificationEmail from "../services/emailService.js";

const register = async (req, res) => {
  const { name, username, school_year, email, password } = req.body;
  const profile_picture = req.file ? req.file.filename : null;

  if (!name || !username || !school_year || !email || !password) {
    return res
      .status(400)
      .json({ success: false, message: "Please fill all fields" });
  }

  try {
    const existingUser = await User.findOne({ where: { email } });
    if (existingUser) {
      return res
        .status(400)
        .json({ success: false, message: "Email already registered" });
    }

    const verification_code = Math.floor(
      100000 + Math.random() * 900000,
    ).toString();

    const newUser = await User.create({
      name,
      username,
      school_year,
      email,
      password,
      profile_picture,
      verification_code,
    });

    await sendVerificationEmail(email, verification_code);

    res.status(201).json({
      success: true,
      message: "User created. Check your email for the confirmation code.",
      userId: newUser.id,
    });
  } catch (error) {
    console.error(error);
    res
      .status(500)
      .json({ success: false, message: "Please check the inputs" });
  }
};

const verifyEmail = async (req, res) => {
  const { userId, code } = req.body;

  if (!userId || !code) {
    return res
      .status(400)
      .json({ success: false, message: "Missing userId or code" });
  }

  try {
    const user = await User.findOne({ where: { id: userId } });

    if (!user) {
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    }
    if (user.is_verified) {
      return res
        .status(400)
        .json({ success: false, message: "Account already verified" });
    }

    if (user.verification_code !== code) {
      return res.status(400).json({ success: false, message: "Invalid code" });
    }

    await user.update({ is_verified: 1, verification_code: null });

    res
      .status(200)
      .json({ success: true, message: "Email verified successfully!" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: "Error verifying email" });
  }
};

const login = async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res
      .status(400)
      .json({ success: false, message: "Please fill all fields" });
  }

  try {
    const user = await User.findOne({ where: { email } });
    if (!user) {
      return res
        .status(401)
        .json({ success: false, message: "User not found" });
    }

    if (!user.is_verified) {
      if (!user.verification_code) {
        const verification_code = Math.floor(
          100000 + Math.random() * 900000,
        ).toString();
        await user.update({ verification_code });
        await verifyEmail(user.email, verification_code);
      } else {
        await verifyEmail(user.email, user.verification_code);
      }
      return res.status(403).json({
        success: false,
        message: "Please verify your email before logging in.",
        userId: user.id,
      });
    }

    const senhacorreta = await bcrypt.compare(password, user.password);
    if (!senhacorreta) {
      return res
        .status(401)
        .json({ success: false, message: "Password incorrect" });
    }

    const token = jwt.sign(
      { id: user.id, email: user.email },
      process.env.JWT_SECRET,
      { expiresIn: "24h" },
    );

    return res.status(200).json({
      success: true,
      message: "Login successful",
      token,
      user: {
        id: user.id,
        full_name: user.name,
        username: user.username,
        school_year: user.school_year,
        email: user.email,
      },
    });
  } catch (error) {
    console.error("Erro ao fazer login", error);
    return res
      .status(500)
      .json({ success: false, message: "Error during login" });
  }
};

const getUser = async (req, res) => {
  try {
    const user = await User.findOne({ where: { id: req.user.id } });
    if (!user)
      return res
        .status(404)
        .json({ success: false, message: "User not found" });
    return res.status(200).json({ success: true, user });
  } catch (error) {
    console.error(error);
    return res
      .status(500)
      .json({ success: false, message: "Internal server error" });
  }
};

export { register, login, getUser, verifyEmail };
