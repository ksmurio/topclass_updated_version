-- Criar tabela de usuários
CREATE TABLE IF NOT EXISTS users (
  id CHAR(36) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  username VARCHAR(255) NOT NULL UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  global_average DECIMAL(4, 2) DEFAULT 0,
  profile_picture VARCHAR(255),
  can_create_battle TINYINT(1) DEFAULT 0,
  school_year TINYINT UNSIGNED,
  is_verified TINYINT(1) DEFAULT 0,
  verification_code VARCHAR(6)
);

-- Criar tabela de clubes
CREATE TABLE IF NOT EXISTS clubs (
  id CHAR(36) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  club_image VARCHAR(255),
  club_type INT NOT NULL,
  creator_id CHAR(36) NOT NULL,
  club_uuid CHAR(36) UNIQUE,
  password VARCHAR(255),
  is_private BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (creator_id) REFERENCES users(id)
);

-- Criar tabela de posts de clubes
CREATE TABLE IF NOT EXISTS club_posts (
  id CHAR(36) PRIMARY KEY,
  club_id CHAR(36) NOT NULL,
  user_id CHAR(36) NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (club_id) REFERENCES clubs(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Criar tabela de comentários de posts
CREATE TABLE IF NOT EXISTS club_comments (
  id CHAR(36) PRIMARY KEY,
  post_id CHAR(36) NOT NULL,
  user_id CHAR(36) NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (post_id) REFERENCES club_posts(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Criar tabela de batalhas
CREATE TABLE IF NOT EXISTS battles (
  id CHAR(36) PRIMARY KEY,
  club_id CHAR(36) NOT NULL,
  creator_id CHAR(36) NOT NULL,
  date DATETIME NOT NULL,
  status ENUM('scheduled', 'ongoing', 'finished') DEFAULT 'scheduled',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  time TIME,
  FOREIGN KEY (club_id) REFERENCES clubs(id),
  FOREIGN KEY (creator_id) REFERENCES users(id)
);

-- Criar tabela de notas de batalhas
CREATE TABLE IF NOT EXISTS battle_grades (
  id CHAR(36) PRIMARY KEY,
  battle_id CHAR(36) NOT NULL,
  user_id CHAR(36) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (battle_id) REFERENCES battles(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Criar tabela de missões
CREATE TABLE IF NOT EXISTS missions (
  id CHAR(36) PRIMARY KEY,
  creator_id CHAR(36),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  due_date DATE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (creator_id) REFERENCES users(id)
);

-- Criar tabela de missões de usuários
CREATE TABLE IF NOT EXISTS user_missions (
  id CHAR(36) PRIMARY KEY,
  user_id CHAR(36),
  mission_id CHAR(36),
  points INT,
  completed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (mission_id) REFERENCES missions(id)
);

-- Criar tabela de disciplinas
CREATE TABLE IF NOT EXISTS subjects (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255) NOT NULL,
  description TEXT,
  year TINYINT UNSIGNED NOT NULL
);

-- Criar tabela de notas de disciplinas
CREATE TABLE IF NOT EXISTS subject_grades (
  id CHAR(36) PRIMARY KEY,
  user_id CHAR(36) NOT NULL,
  club_id CHAR(36),
  subject_id CHAR(36),
  grade DECIMAL(4, 2),
  graded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (club_id) REFERENCES clubs(id)
);

-- Criar tabela de notas
CREATE TABLE IF NOT EXISTS notes (
  id CHAR(36) PRIMARY KEY,
  user_id CHAR(36),
  club_id CHAR(36),
  title VARCHAR(255) NOT NULL,
  content TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (club_id) REFERENCES clubs(id)
);

-- Criar índices para melhor performance
CREATE INDEX idx_clubs_creator_id ON clubs(creator_id);
CREATE INDEX idx_club_posts_club_id ON club_posts(club_id);
CREATE INDEX idx_club_posts_user_id ON club_posts(user_id);
CREATE INDEX idx_club_comments_post_id ON club_comments(post_id);
CREATE INDEX idx_club_comments_user_id ON club_comments(user_id);
CREATE INDEX idx_battles_club_id ON battles(club_id);
CREATE INDEX idx_battles_creator_id ON battles(creator_id);
CREATE INDEX idx_battle_grades_battle_id ON battle_grades(battle_id);
CREATE INDEX idx_battle_grades_user_id ON battle_grades(user_id);
CREATE INDEX idx_missions_creator_id ON missions(creator_id);
CREATE INDEX idx_user_missions_user_id ON user_missions(user_id);
CREATE INDEX idx_user_missions_mission_id ON user_missions(mission_id);
CREATE INDEX idx_subject_grades_user_id ON subject_grades(user_id);
CREATE INDEX idx_subject_grades_club_id ON subject_grades(club_id);
CREATE INDEX idx_notes_user_id ON notes(user_id);
CREATE INDEX idx_notes_club_id ON notes(club_id);
