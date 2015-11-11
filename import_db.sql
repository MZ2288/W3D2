DROP TABLE IF EXISTS users;
CREATE TABLE users(
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;
CREATE TABLE questions(
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body VARCHAR(255) NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_follows;
CREATE TABLE question_follows(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

DROP TABLE IF EXISTS replies;
CREATE TABLE replies(
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply INTEGER,
  user_id INTEGER NOT NULL,
  body VARCHAR(255),

  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(parent_reply) REFERENCES replies(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes(
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Jimmy', 'Carter'),
  ('Fred', 'Atkins'),
  ('Nathaniel', 'Hawthorne');

INSERT INTO
  questions (title, body, user_id)
VALUES
  ('Where is my watch', 'Same', 1),
  ('Where is his watch', 'ladybuy', 2),
  ('Help me, I am lost', 'yodel', 3);

INSERT INTO
  replies (question_id, parent_reply, user_id, body)
VALUES
  (1, NULL, 2, 'I will help you find it!'),
  (1, NULL, 3, 'Oh no!!!');

INSERT INTO
  question_follows(user_id, question_id)
VALUES
  (1, 2),
  (2, 3),
  (1, 1),
  (2, 1),
  (2, 2),
  (3, 1);

  INSERT INTO
    question_likes(user_id, question_id)
  VALUES
    (1, 2),
    (1, 1),
    (1, 3),
    (2, 1),
    (2, 3),
    (3, 1);
