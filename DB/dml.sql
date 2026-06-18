USE vote_system;

INSERT INTO users (username, password_hash, role) VALUES
  ('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'ADMIN')
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
