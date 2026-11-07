# Crow# Crownfield Eye Hospital Database - Iulian Fodor


This folder contains my individual CPU4:103 Database Development submission. The schema and sample data are shared project work, while the query set, procedure, trigger, security demonstration and explanation are my own evidence.


Run the files in this order:


1. `01_schema.sql`

2. `02_sample_data.sql`

3. `03_individual_queries.sql`

4. `04_procedure_and_trigger.sql`

5. `05_security_and_transactions.sql`

6. `06_evidence_checks.sql`


In the installed MySQL Workbench version, use **Run Script** (`Ctrl+Enter`) for each whole file. The complete individual sequence was re-run on 3 November 2026: the query result tabs opened correctly, the table-count check passed, and the individual procedure, trigger and view all returned a verification value of `1`.


My six demonstrated features are a clinic aggregate, a prescription INNER JOIN, a LEFT JOIN that finds patients without appointments, a CTE for priority follow-up work, a stored procedure with a clinician parameter, and a trigger that prevents unrealistic appointment times.


Useful tests:


```sql

CALL fodor_clinician_schedule('Dr Maya Shah');


START TRANSACTION;

INSERT INTO appointment

(patient_id, clinician_id, clinic_id, appointment_date, appointment_time, appointment_status)

VALUES (12, 10, 10, '2026-11-10', '10:00', 'Scheduled');

SELECT * FROM appointment WHERE patient_id = 12;

ROLLBACK;

```


`ERD.png` shows the final model. `PRESENTATION_SCRIPT.md` is a speaking guide for the recorded presentation. The video and the final GitHub/Moodle upload must be completed by the student.



nfield Eye Hospital Database - Iulian Fodor


This folder contains my individual CPU4:103 Database Development submission. The schema and sample data are shared project work, while the query set, procedure, trigger, security demonstration and explanation are my own evidence.


Run the files in this order:


1. `01_schema.sql`

2. `02_sample_data.sql`

3. `03_individual_queries.sql`

4. `04_procedure_and_trigger.sql`

5. `05_security_and_transactions.sql`

6. `06_evidence_checks.sql`


In the installed MySQL Workbench version, use **Run Script** (`Ctrl+Enter`) for each whole file. The complete individual sequence was re-run on 3 November 2026: the query result tabs opened correctly, the table-count check passed, and the individual procedure, trigger and view all returned a verification value of `1`.


My six demonstrated features are a clinic aggregate, a prescription INNER JOIN, a LEFT JOIN that finds patients without appointments, a CTE for priority follow-up work, a stored procedure with a clinician parameter, and a trigger that prevents unrealistic appointment times.


Useful tests:


```sql

CALL fodor_clinician_schedule('Dr Maya Shah');


START TRANSACTION;

INSERT INTO appointment

(patient_id, clinician_id, clinic_id, appointment_date, appointment_time, appointment_status)

VALUES (12, 10, 10, '2026-11-10', '10:00', 'Scheduled');

SELECT * FROM appointment WHERE patient_id = 12;

ROLLBACK;

```


`ERD.png` shows the final model. `PRESENTATION_SCRIPT.md` is a speaking guide for the recorded presentation. The video and the final GitHub/Moodle upload must be completed by the student.
