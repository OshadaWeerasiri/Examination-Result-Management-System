-- Table 1: Programs
CREATE TABLE programs (
  program_id    VARCHAR2(4)    PRIMARY KEY,
  program_name  VARCHAR2(100)  NOT NULL
);
INSERT INTO programs (program_id, program_name) VALUES ('CS', 'Bachelor of Science Honours in Computer Science');
INSERT INTO programs (program_id, program_name) VALUES ('BICT', 'Bachelor of Information and Communication Technology');
INSERT INTO programs (program_id, program_name) VALUES ('BET', 'Bachelor of Engineering Technology');
INSERT INTO programs (program_id, program_name) VALUES ('BBST', 'Bachelor of Bio Systems Technology');
INSERT INTO programs (program_id, program_name) VALUES ('ASE', 'Bachelor of Science in Applied Software Engineering');


-- Table 2: Batches
CREATE TABLE batches (
  program_id    VARCHAR2(4)    NOT NULL,
  batch_id      NUMBER         NOT NULL,
  PRIMARY KEY (program_id, batch_id),
  FOREIGN KEY (program_id) REFERENCES programs(program_id)
);
INSERT INTO batches VALUES ('CS', 2020);
INSERT INTO batches VALUES ('BICT', 2020);
INSERT INTO batches VALUES ('BET', 2020);
INSERT INTO batches VALUES ('CS', 2021);
INSERT INTO batches VALUES ('BICT', 2021);
INSERT INTO batches VALUES ('BET', 2021);


-- Table 3: Academic Years
CREATE TABLE ac_years (
  year_id     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  year_start  NUMBER(4) NOT NULL,
  year_end    NUMBER(4) NOT NULL,
  CONSTRAINT uni_acy UNIQUE (year_start, year_end)
);
INSERT INTO ac_years (year_start, year_end) VALUES (2019, 2020);
INSERT INTO ac_years (year_start, year_end) VALUES (2020, 2021);
INSERT INTO ac_years (year_start, year_end) VALUES (2021, 2022);


-- Table 4: Batch Academic Years (CS 2020 -> 2020-2021, 2021-2022)
CREATE TABLE batch_years (
  program_id    VARCHAR2(4) NOT NULL,
  batch_id      NUMBER      NOT NULL,
  year_id       NUMBER      NOT NULL,
  PRIMARY KEY (program_id, batch_id, year_id),
  FOREIGN KEY (program_id, batch_id) REFERENCES batches(program_id, batch_id),
  FOREIGN KEY (year_id) REFERENCES ac_years(year_id)
);
INSERT INTO batch_years VALUES ('CS', 2020, 2);
INSERT INTO batch_years VALUES ('BICT', 2020, 2);
INSERT INTO batch_years VALUES ('BET', 2020, 2);
INSERT INTO batch_years VALUES ('CS', 2020, 3);
INSERT INTO batch_years VALUES ('BICT', 2020, 3);
INSERT INTO batch_years VALUES ('BET', 2020, 3);
INSERT INTO batch_years VALUES ('CS', 2021, 3);
INSERT INTO batch_years VALUES ('BICT', 2021, 3);
INSERT INTO batch_years VALUES ('BET', 2021, 3);


-- Table 5: Students
CREATE TABLE students (
  student_pk    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_id    VARCHAR2(11) UNIQUE NOT NULL,
  student_name  VARCHAR2(100) NOT NULL,
  program_id    VARCHAR2(4) NOT NULL,
  batch_id      NUMBER NOT NULL,
  FOREIGN KEY (program_id, batch_id) REFERENCES batches(program_id, batch_id)
);
INSERT INTO students (student_id, student_name, program_id, batch_id) VALUES ('CS/2020/001', 'S_name_1', 'CS', 2020);
INSERT INTO students (student_id, student_name, program_id, batch_id) VALUES ('CS/2020/002', 'S_name_2', 'CS', 2020);
INSERT INTO students (student_id, student_name, program_id, batch_id) VALUES ('CS/2021/001', 'S_name_4', 'CS', 2021);
INSERT INTO students (student_id, student_name, program_id, batch_id) VALUES ('CS/2021/002', 'S_name_5', 'CS', 2021);
INSERT INTO students (student_id, student_name, program_id, batch_id) VALUES ('CS/2021/003', 'S_name_6', 'CS', 2021);


-- Table 6: Teachers
CREATE TABLE teachers (
  teacher_pk    NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  teacher_code  VARCHAR2(8) UNIQUE NOT NULL,
  teacher_name  VARCHAR2(100) NOT NULL
);
INSERT INTO teachers (teacher_code, teacher_name) VALUES ('SEN/001', 'T_name_1');
INSERT INTO teachers (teacher_code, teacher_name) VALUES ('SEN/002', 'T_name_2');
INSERT INTO teachers (teacher_code, teacher_name) VALUES ('ASE/001', 'T_name_3');
INSERT INTO teachers (teacher_code, teacher_name) VALUES ('ASE/002', 'T_name_4');
INSERT INTO teachers (teacher_code, teacher_name) VALUES ('ACO/001', 'T_name_5');


-- Table 7: Subjects
CREATE TABLE subjects (
  subject_code  VARCHAR2(10) PRIMARY KEY,
  subject_name  VARCHAR2(100) NOT NULL,
  program_id    VARCHAR2(4) NOT NULL,
  FOREIGN KEY (program_id) REFERENCES programs(program_id)
);
INSERT INTO subjects (subject_code, subject_name, program_id) VALUES ('CSCI12014', 'Mathematics 1', 'CS');
INSERT INTO subjects (subject_code, subject_name, program_id) VALUES ('CSCI11023', 'Intro to Programming', 'CS');
INSERT INTO subjects (subject_code, subject_name, program_id) VALUES ('CSCI22021', 'Networking Basics', 'CS');
INSERT INTO subjects (subject_code, subject_name, program_id) VALUES ('SWST32033', 'Advance DataBase Systems', 'BICT');
INSERT INTO subjects (subject_code, subject_name, program_id) VALUES ('DSCI32012', 'Advance DataBase Systems', 'CS');


-- Table 8: Subject-Teachers per Academic Year
CREATE TABLE subject_teachers (
  subject_code  VARCHAR2(10) NOT NULL,
  teacher_pk    NUMBER NOT NULL,
  year_id       NUMBER NOT NULL,
  PRIMARY KEY (subject_code, teacher_pk, year_id),
  FOREIGN KEY (subject_code) REFERENCES subjects(subject_code),
  FOREIGN KEY (teacher_pk) REFERENCES teachers(teacher_pk),
  FOREIGN KEY (year_id) REFERENCES ac_years(year_id)
);
INSERT INTO subject_teachers (subject_code, teacher_pk, year_id) VALUES ('CSCI12014', 1, 1);
INSERT INTO subject_teachers (subject_code, teacher_pk, year_id) VALUES ('CSCI11023', 2, 2);
INSERT INTO subject_teachers (subject_code, teacher_pk, year_id) VALUES ('CSCI22021', 3, 2);
INSERT INTO subject_teachers (subject_code, teacher_pk, year_id) VALUES ('DSCI32012', 4, 2);
INSERT INTO subject_teachers (subject_code, teacher_pk, year_id) VALUES ('DSCI32012', 4, 3);


-- Table 9: Results
CREATE TABLE results (
  student_pk    NUMBER NOT NULL,
  subject_code  VARCHAR2(10) NOT NULL,
  year_id       NUMBER NOT NULL,
  marks         NUMBER(5,2) NOT NULL,
  grade         VARCHAR2(3),
  PRIMARY KEY (student_pk, subject_code, year_id),
  FOREIGN KEY (student_pk) REFERENCES students(student_pk),
  FOREIGN KEY (subject_code) REFERENCES subjects(subject_code),
  FOREIGN KEY (year_id) REFERENCES ac_years(year_id),
  CHECK (marks BETWEEN 0 AND 100),
  CHECK (grade IN (
    'A+','A','A-','B+','B','B-',
    'C+','C','C-','D+','D','F','AB','Inc'
  ))
);

CREATE TABLE reattempt_log (
  log_id         NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  student_pk     NUMBER NOT NULL,
  subject_code   VARCHAR2(10) NOT NULL,
  first_year_id  NUMBER NOT NULL,
  re_year_id     NUMBER NOT NULL,
  log_timestamp  TIMESTAMP DEFAULT SYSTIMESTAMP,
  FOREIGN KEY (student_pk) REFERENCES students(student_pk),
  FOREIGN KEY (subject_code) REFERENCES subjects(subject_code),
  FOREIGN KEY (first_year_id) REFERENCES ac_years(year_id),
  FOREIGN KEY (re_year_id) REFERENCES ac_years(year_id)
);


COMMIT;
