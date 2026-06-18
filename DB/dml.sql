-- =============================================
-- DML: 初始資料範例
-- =============================================

USE vote_system;

-- 預設管理者帳號 (admin / admin123)
-- BCrypt hash for 'admin123' with 10 rounds
INSERT INTO users (username, password_hash) VALUES
  ('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy')
ON DUPLICATE KEY UPDATE username = username;

INSERT INTO vote_items (name) VALUES
  ('電腦'),
  ('滑鼠'),
  ('鍵盤'),
  ('螢幕');

INSERT INTO vote_records (voter, item_id) VALUES
  ('Leo',   1),
  ('Sandy', 1),
  ('Sandy', 2),
  ('Randy', 2),
  ('RSY',   2);
