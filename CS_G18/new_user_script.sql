--Show PDBS
--ALTER SESSION SET CONTAINER = XEPDB1;

--Drop table programs cascade constraints purge;
--Drop table batches cascade constraints purge;
--Drop table ac_years cascade constraints purge;
--Drop table batch_years cascade constraints purge;
--Drop table students cascade constraints purge;
--Drop table teachers cascade constraints purge;
--Drop table subjects cascade constraints purge;
--Drop table subject_teachers cascade constraints purge;
--Drop table results cascade constraints purge;
--Drop table reattempt_log cascade constraints purge;


CREATE USER fctadmin IDENTIFIED BY 123;

GRANT CONNECT, RESOURCE TO fctadmin;
ALTER USER fctadmin QUOTA UNLIMITED ON USERS;
GRANT EXECUTE ON DBMS_OUTPUT TO fctadmin;

PROMPT User 'fctadmin' created. Connect with:
PROMPT sqlplus fctadmin/123@XE
