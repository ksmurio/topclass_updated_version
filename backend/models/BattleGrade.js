import { DataTypes } from "sequelize";
import sequelize from "../config/db.js";

const BattleGrade = sequelize.define(
  "BattleGrade",
  {
    id: {
      type: DataTypes.CHAR(36),
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
      allowNull: false,
    },
    battle_id: {
      type: DataTypes.CHAR(36),
      allowNull: false,
    },
    user_id: {
      type: DataTypes.CHAR(36),
      allowNull: false,
    },
    created_at: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: DataTypes.NOW,
    },
  },
  {
    tableName: "battle_grades",
    timestamps: false,
  }
);

export default BattleGrade;