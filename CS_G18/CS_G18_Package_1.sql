-- header
CREATE OR REPLACE PACKAGE data_add_pkg IS
  PROCEDURE add_student(
    p_student_id    VARCHAR2,
    p_student_name  VARCHAR2,
    p_program_id    VARCHAR2,
    p_batch_id      NUMBER
  );

  PROCEDURE add_batch(
    p_batch_id      NUMBER,
    p_program_id    VARCHAR2
  );

  PROCEDURE add_academic_year(
    p_year_start    NUMBER,
    p_year_end      NUMBER
  );

  PROCEDURE add_subject(
    p_subject_code  VARCHAR2,
    p_subject_name  VARCHAR2,
    p_program_id    VARCHAR2
  );

PROCEDURE add_batch_year(
  p_program_id     VARCHAR2,
  p_batch_id       NUMBER,
  p_year_id        NUMBER
);
END data_add_pkg;
/

--body
CREATE OR REPLACE PACKAGE BODY data_add_pkg IS

  -- public procedures_1
  PROCEDURE add_student(
    p_student_id    VARCHAR2,
    p_student_name  VARCHAR2,
    p_program_id    VARCHAR2,
    p_batch_id      NUMBER
  ) IS
  BEGIN
    INSERT INTO students (student_id, student_name, program_id, batch_id)
    VALUES (p_student_id, p_student_name, p_program_id, p_batch_id);
  END add_student;

  -- public procedures_2
  PROCEDURE add_batch(
    p_batch_id      NUMBER,
    p_program_id    VARCHAR2
  ) IS
  BEGIN
    INSERT INTO batches (batch_id, program_id)
    VALUES (p_batch_id, p_program_id);
  END add_batch;

  -- public procedures_3
  PROCEDURE add_academic_year(
    p_year_start    NUMBER,
    p_year_end      NUMBER
  ) IS
  BEGIN
    INSERT INTO ac_years (year_start, year_end)
    VALUES (p_year_start, p_year_end);
  END add_academic_year;

  -- public procedures_4
  PROCEDURE add_subject(
    p_subject_code  VARCHAR2,
    p_subject_name  VARCHAR2,
    p_program_id    VARCHAR2
  ) IS
  BEGIN
    INSERT INTO subjects (subject_code, subject_name, program_id)
    VALUES (p_subject_code, p_subject_name, p_program_id);
  END add_subject;

  -- public procedures_5
  PROCEDURE add_batch_year(
    p_program_id VARCHAR2,
    p_batch_id NUMBER,
    p_year_id  NUMBER
  ) IS
    v_batch_exists NUMBER;
    v_year_exists  NUMBER;
  BEGIN
    -- Check batch exists
    SELECT COUNT(*) INTO v_batch_exists FROM batches WHERE batch_id = p_batch_id;
    IF v_batch_exists = 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Batch ID does not exist.');
    END IF;

    -- Check academic year exists
    SELECT COUNT(*) INTO v_year_exists FROM ac_years WHERE year_id = p_year_id;
    IF v_year_exists = 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Academic Year ID does not exist.');
    END IF;

    -- Insert the batch-year 
  INSERT INTO batch_years (program_id, batch_id, year_id)
  VALUES (p_program_id, p_batch_id, p_year_id);
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20003, 'This batch-year association already exists.');
  END add_batch_year;

END data_add_pkg;
/