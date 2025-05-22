CREATE OR REPLACE TRIGGER trg_log_reattempts
BEFORE INSERT ON results
FOR EACH ROW
DECLARE
  v_prev_year_id NUMBER;
BEGIN
  SELECT year_id INTO v_prev_year_id
  FROM results
  WHERE student_pk = :NEW.student_pk
    AND subject_code = :NEW.subject_code
    AND year_id <> :NEW.year_id
  FETCH FIRST 1 ROWS ONLY;

  -- If a previous attempt exists
  INSERT INTO reattempt_log (student_pk, subject_code, first_year_id, re_year_id)
  VALUES (:NEW.student_pk, :NEW.subject_code, v_prev_year_id, :NEW.year_id);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    NULL; -- No prior attempt
END;
