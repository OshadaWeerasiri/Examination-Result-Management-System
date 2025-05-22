--header
CREATE OR REPLACE PACKAGE result_mgmt_pkg IS
  PROCEDURE add_result(
    p_student_pk NUMBER,
    p_subject_code VARCHAR2,
    p_year_id    NUMBER,
    p_marks      NUMBER
  );

  PROCEDURE update_result(
    p_student_pk NUMBER,
    p_subject_code VARCHAR2,
    p_year_id    NUMBER,
    p_marks      NUMBER
  );

END result_mgmt_pkg;
/

-- body
CREATE OR REPLACE PACKAGE BODY result_mgmt_pkg IS

  --private function
  FUNCTION calc_grade(p_marks NUMBER) RETURN VARCHAR2 IS
  BEGIN
    IF p_marks >= 85 THEN
      RETURN 'A+';
    ELSIF p_marks >= 70 THEN
      RETURN 'A';
    ELSIF p_marks >= 65 THEN
      RETURN 'A-';
    ELSIF p_marks >= 60 THEN
      RETURN 'B+';
    ELSIF p_marks >= 55 THEN
      RETURN 'B';
    ELSIF p_marks >= 50 THEN
      RETURN 'B-';
    ELSIF p_marks >= 45 THEN
      RETURN 'C+';
    ELSIF p_marks >= 40 THEN
      RETURN 'C';
    ELSIF p_marks >= 35 THEN
      RETURN 'C-';
    ELSIF p_marks >= 30 THEN
      RETURN 'D+';
    ELSIF p_marks >= 20 THEN
      RETURN 'D';
    ELSIF p_marks >= 0 THEN
      RETURN 'F';
    ELSE
      RETURN 'AB'; -- Absent 
    END IF;
  END calc_grade;

  -- public procedures_1
  PROCEDURE add_result(
    p_student_pk NUMBER,
    p_subject_code VARCHAR2,
    p_year_id    NUMBER,
    p_marks      NUMBER
  ) IS
    v_grade VARCHAR2(3);
  BEGIN
    v_grade := calc_grade(p_marks);

    INSERT INTO results (student_pk, subject_code, year_id, marks, grade)
    VALUES (p_student_pk, p_subject_code, p_year_id, p_marks, v_grade);
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(-20001, 'Result already exists. Use update_result instead.');
  END add_result;

  -- public procedures_2
  PROCEDURE update_result(
    p_student_pk NUMBER,
    p_subject_code VARCHAR2,
    p_year_id    NUMBER,
    p_marks      NUMBER
  ) IS
    v_grade VARCHAR2(3);
  BEGIN
    v_grade := calc_grade(p_marks);

    UPDATE results
    SET marks = p_marks, grade = v_grade
    WHERE student_pk = p_student_pk
      AND subject_code = p_subject_code
      AND year_id = p_year_id;

    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'No existing result found to update.');
    END IF;
  END update_result;

END result_mgmt_pkg;
/