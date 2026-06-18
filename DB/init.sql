-- =============================================
-- DDL: 建立資料庫與資料表
-- =============================================

CREATE DATABASE IF NOT EXISTS vote_system
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE vote_system;

-- 投票項目表
CREATE TABLE IF NOT EXISTS vote_items (
  id         INT           NOT NULL AUTO_INCREMENT,
  name       VARCHAR(100)  NOT NULL,
  created_at DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 投票記錄表
CREATE TABLE IF NOT EXISTS vote_records (
  id         INT           NOT NULL AUTO_INCREMENT,
  voter      VARCHAR(100)  NOT NULL,
  item_id    INT           NOT NULL,
  created_at DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  INDEX idx_voter (voter),
  INDEX idx_item_id (item_id),
  CONSTRAINT fk_vote_records_item
    FOREIGN KEY (item_id) REFERENCES vote_items(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
