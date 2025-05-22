--pckg_1_proc_1
BEGIN
  data_add_pkg.add_student(
    p_student_id   => 'CS/2020/003',
    p_student_name => 'S_name_3',
    p_program_id   => 'CS',
    p_batch_id     => 2020
  );
  DBMS_OUTPUT.PUT_LINE('add_student executed successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

--pckg_1_proc_2
BEGIN
  data_add_pkg.add_batch(
    p_batch_id    => 2023,
    p_program_id  => 'CS'
  );
  DBMS_OUTPUT.PUT_LINE('add_batch executed successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

--pckg_1_proc_3
BEGIN
  data_add_pkg.add_academic_year(
    p_year_start => 2023,
    p_year_end   => 2024
  );
  DBMS_OUTPUT.PUT_LINE('add_academic_year executed successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

--pckg_1_proc_4
BEGIN
  data_add_pkg.add_subject(
    p_subject_code => 'CSCI21013',
    p_subject_name => 'Statistics',
    p_program_id   => 'CS'
  );
  DBMS_OUTPUT.PUT_LINE('add_subject executed successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/


--pckg_1_proc_5
DECLARE
  v_year_id ac_years.year_id%TYPE;

BEGIN
  SELECT MAX(year_id) INTO v_year_id FROM ac_years;
data_add_pkg.add_batch_year(
  p_program_id => 'CS',
  p_batch_id   => 2023,
  p_year_id    => v_year_id
);

  DBMS_OUTPUT.PUT_LINE('add_batch_year executed successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/


--pckg_2_proc_1
DECLARE
  v_student_pk students.student_pk%TYPE;
  v_year_id ac_years.year_id%TYPE;
BEGIN
  SELECT student_pk 
  INTO v_student_pk 
  FROM students 
  WHERE student_id = 'CS/2020/001';

  SELECT year_id 
  INTO v_year_id 
  FROM ac_years 
  WHERE year_start = 2020 AND year_end = 2021;

  result_mgmt_pkg.add_result(
    p_student_pk => v_student_pk,
    p_subject_code => 'CSCI12014',  -- match your table definition
    p_year_id    => v_year_id,
    p_marks      => 72.5
  );

  DBMS_OUTPUT.PUT_LINE('add_result executed successfully');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/

--pckg_2_proc_2
DECLARE
  v_student_pk students.student_pk%TYPE;
  v_subject_code subjects.subject_code%TYPE;
  v_year_id ac_years.year_id%TYPE;
BEGIN
  SELECT student_pk INTO v_student_pk FROM students WHERE student_id = 'CS/2020/003';
  v_subject_code := 'CSCI12014';
  SELECT year_id INTO v_year_id FROM ac_years WHERE year_start = 2020 AND year_end = 2021;

  INSERT INTO results (student_pk, subject_code, year_id, marks, grade)
  VALUES (v_student_pk, v_subject_code, v_year_id, 45.0, 'D');
END;
/

--testing the reatempt trigger
DECLARE
  v_student_pk students.student_pk%TYPE;
  v_subject_code subjects.subject_code%TYPE;
  v_year_id ac_years.year_id%TYPE;
BEGIN
  SELECT student_pk INTO v_student_pk FROM students WHERE student_id = 'CS/2020/003';
  v_subject_code := 'CSCI12014';
  SELECT year_id INTO v_year_id FROM ac_years WHERE year_start = 2021 AND year_end = 2022;

  -- This should trigger the reattempt log
  INSERT INTO results (student_pk, subject_code, year_id, marks, grade)
  VALUES (v_student_pk, v_subject_code, v_year_id, 88.0, 'B+');
END;
/
