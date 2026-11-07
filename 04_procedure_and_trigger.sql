-- Iulian-Constantin Fodor
-- Feature 5: stored procedure with an input parameter
-- Feature 6: trigger that applies a meaningful scheduling rule

USE crownfield_eye_hospital;

DROP PROCEDURE IF EXISTS fodor_clinician_schedule;
DELIMITER $$
CREATE PROCEDURE fodor_clinician_schedule(IN p_clinician_name VARCHAR(100))
BEGIN
    SELECT
        c.full_name AS clinician,
        a.appointment_id,
        a.appointment_date,
        a.appointment_time,
        p.patient_ref,
        p.full_name AS patient,
        cl.clinic_name,
        a.appointment_status
    FROM clinician AS c
    JOIN appointment AS a ON a.clinician_id = c.clinician_id
    JOIN patient AS p ON p.patient_id = a.patient_id
    JOIN clinic AS cl ON cl.clinic_id = a.clinic_id
    WHERE c.full_name = p_clinician_name
    ORDER BY a.appointment_date, a.appointment_time;
END$$
DELIMITER ;

CALL fodor_clinician_schedule('Dr Maya Shah');

DROP TRIGGER IF EXISTS trg_fodor_appointment_time;
DELIMITER $$
CREATE TRIGGER trg_fodor_appointment_time
BEFORE INSERT ON appointment
FOR EACH ROW
BEGIN
    IF NEW.appointment_time < '08:00:00'
       OR NEW.appointment_time > '18:00:00' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Appointment time must be between 08:00 and 18:00';
    END IF;
END$$
DELIMITER ;

START TRANSACTION;
INSERT INTO appointment
    (patient_id, clinician_id, clinic_id, appointment_date, appointment_time, appointment_status)
VALUES
    (12, 10, 10, '2026-11-10', '10:00:00', 'Scheduled');
SELECT appointment_id, patient_id, appointment_date, appointment_time, appointment_status
FROM appointment
WHERE patient_id = 12;
ROLLBACK;

-- Invalid test to run separately when recording evidence:
-- INSERT INTO appointment
--     (patient_id, clinician_id, clinic_id, appointment_date, appointment_time, appointment_status)
-- VALUES
--     (12, 10, 10, '2026-11-10', '07:30:00', 'Scheduled');

