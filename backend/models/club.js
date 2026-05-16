import { DataTypes } from "sequelize";
import sequelize from "../config/db.js";

const Club = sequelize.define(
  "Club",
  {
    id: {
      type: DataTypes.CHAR(36),
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    name: {
      type: DataTypes.STRING(255),
      allowNull: false,
    },
    description: {
      type: DataTypes.TEXT,
      allowNull: true,
    },
    club_image: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    club_type: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
    creator_id: {
      type: DataTypes.CHAR(36),
      allowNull: false,
    },
    club_uuid: {
      type: DataTypes.CHAR(36),
      unique: true,
      defaultValue: DataTypes.UUIDV4,
    },
    password: {
      type: DataTypes.STRING(255),
      allowNull: true,
    },
    is_private: {
      type: DataTypes.BOOLEAN,
      defaultValue: false,
    },
    created_at: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
  },
  {
    tableName: "clubs",
    timestamps: false,
    underscored: true,
  },
);

export default Club;