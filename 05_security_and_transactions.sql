-- Iulian-Constantin Fodor
-- Roles, privilege matrix, hashing/encryption, prepared statement and transaction tests.

USE crownfield_eye_hospital;

DROP VIEW IF EXISTS v_fodor_patient_medicines;
CREATE VIEW v_fodor_patient_medicines AS
SELECT
    p.patient_ref,
    p.full_name AS patient,
    m.medicine_name,
    pi.dose,
    pi.frequency,
    pi.duration
FROM patient AS p
JOIN appointment AS a ON a.patient_id = p.patient_id
JOIN prescription AS pr ON pr.appointment_id = a.appointment_id
JOIN prescription_item AS pi ON pi.prescription_id = pr.prescription_id
JOIN medicine AS m ON m.medicine_id = pi.medicine_id;

CREATE ROLE IF NOT EXISTS
    'fodor_administrator_role',
    'fodor_doctor_role',
    'fodor_receptionist_role',
    'fodor_patient_role';

GRANT ALL PRIVILEGES ON crownfield_eye_hospital.* TO 'fodor_administrator_role';

GRANT SELECT ON crownfield_eye_hospital.* TO 'fodor_doctor_role';
GRANT INSERT, UPDATE ON crownfield_eye_hospital.diagnosis TO 'fodor_doctor_role';
GRANT INSERT, UPDATE ON crownfield_eye_hospital.followup_plan TO 'fodor_doctor_role';
GRANT INSERT, UPDATE ON crownfield_eye_hospital.prescription TO 'fodor_doctor_role';
GRANT INSERT, UPDATE ON crownfield_eye_hospital.prescription_item TO 'fodor_doctor_role';

GRANT SELECT, INSERT, UPDATE ON crownfield_eye_hospital.patient TO 'fodor_receptionist_role';
GRANT SELECT, INSERT, UPDATE ON crownfield_eye_hospital.appointment TO 'fodor_receptionist_role';
GRANT SELECT ON crownfield_eye_hospital.clinic TO 'fodor_receptionist_role';
GRANT SELECT ON crownfield_eye_hospital.clinician TO 'fodor_receptionist_role';

GRANT SELECT ON crownfield_eye_hospital.v_fodor_patient_medicines TO 'fodor_patient_role';

SELECT username, password_hash, account_type
FROM user_account
ORDER BY account_type, username;

SET @fodor_demo_key = 'Crownfield-Fodor-2026';
UPDATE patient
SET postcode_encrypted = AES_ENCRYPT(postcode, @fodor_demo_key);

SELECT
    patient_ref,
    HEX(postcode_encrypted) AS encrypted_postcode,
    CAST(AES_DECRYPT(postcode_encrypted, @fodor_demo_key) AS CHAR) AS decrypted_postcode
FROM patient
WHERE patient_ref IN ('OP003', 'OP004');

SET @medicine_search = 'Latanoprost';
PREPARE fodor_medicine_lookup FROM
    'SELECT medicine_id, medicine_name FROM medicine WHERE medicine_name = ?';
EXECUTE fodor_medicine_lookup USING @medicine_search;
DEALLOCATE PREPARE fodor_medicine_lookup;

START TRANSACTION;
UPDATE appointment SET appointment_status = 'Cancelled' WHERE appointment_id = 12;
SELECT appointment_id, appointment_status FROM appointment WHERE appointment_id = 12;
ROLLBACK;
SELECT appointment_id, appointment_status FROM appointment WHERE appointment_id = 12;

START TRANSACTION;
DELETE FROM prescription_item WHERE prescription_item_id = 20;
SELECT COUNT(*) AS items_after_delete FROM prescription_item;
ROLLBACK;
SELECT COUNT(*) AS items_after_rollback FROM prescription_item;

SHOW GRANTS FOR 'fodor_doctor_role';

