-- Iulian-Constantin Fodor
-- Six purposeful query examples are completed across this file and 04_procedure_and_trigger.sql.

USE crownfield_eye_hospital;

-- Feature 1: aggregate with GROUP BY and HAVING
-- Question: Which clinics have at least two appointments in the sample data?
SELECT
    cl.clinic_name,
    cl.location,
    COUNT(a.appointment_id) AS appointment_count
FROM clinic AS cl
JOIN appointment AS a ON a.clinic_id = cl.clinic_id
GROUP BY cl.clinic_id, cl.clinic_name, cl.location
HAVING COUNT(a.appointment_id) >= 2
ORDER BY appointment_count DESC, cl.clinic_name;

-- Feature 2: INNER JOIN across five tables
-- Question: Which medicines were prescribed to each patient?
SELECT
    pr.prescription_id,
    p.patient_ref,
    p.full_name AS patient,
    m.medicine_name,
    pi.dose,
    pi.route,
    pi.frequency,
    pi.duration
FROM prescription_item AS pi
JOIN prescription AS pr ON pr.prescription_id = pi.prescription_id
JOIN appointment AS a ON a.appointment_id = pr.appointment_id
JOIN patient AS p ON p.patient_id = a.patient_id
JOIN medicine AS m ON m.medicine_id = pi.medicine_id
ORDER BY pr.prescription_id, m.medicine_name;

-- Feature 3: LEFT JOIN for missing optional records
-- Question: Which registered patients do not yet have an appointment?
SELECT
    p.patient_ref,
    p.full_name AS patient,
    p.postcode
FROM patient AS p
LEFT JOIN appointment AS a ON a.patient_id = p.patient_id
WHERE a.appointment_id IS NULL
ORDER BY p.patient_ref;

-- Feature 4: common table expression
-- Question: Which pending follow-ups have High or Urgent priority?
WITH priority_followups AS (
    SELECT
        p.patient_ref,
        p.full_name AS patient,
        f.due_date,
        f.priority,
        c.full_name AS clinician
    FROM followup_plan AS f
    JOIN appointment AS a ON a.appointment_id = f.appointment_id
    JOIN patient AS p ON p.patient_id = a.patient_id
    JOIN clinician AS c ON c.clinician_id = a.clinician_id
    WHERE f.status = 'Pending'
)
SELECT patient_ref, patient, due_date, priority, clinician
FROM priority_followups
WHERE priority IN ('High', 'Urgent')
ORDER BY due_date, patient_ref;

-- Extra UNION example used to check people stored in different tables.
SELECT full_name AS person_name, 'Patient' AS person_type
FROM patient
UNION
SELECT full_name, 'Clinician'
FROM clinician
ORDER BY person_type, person_name;

