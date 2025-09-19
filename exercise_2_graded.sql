/* Create a table medication_stock in your Smart Old Age Home database. The table must have the following attributes:
 1. medication_id (integer, primary key)
 2. medication_name (varchar, not null)
 3. quantity (integer, not null)
 Insert some values into the medication_stock table. 
 Practice SQL with the following:
 */

-- Q1: List all patients' names and ages
SELECT name AS patient_name, age AS patient_age
FROM patients;

-- Q2: List all doctors specializing in 'Cardiology'
SELECT *
FROM doctors
WHERE specialization = 'Cardiology';

-- Q3: Find all patients older than 80
SELECT *
FROM patients
WHERE age > 80;

-- Q4: List all patients ordered by age (youngest first)
SELECT *
FROM patients
ORDER BY age ASC;

-- Q5: Count the number of doctors in each specialization
SELECT specialization, COUNT(doctor_id) AS doctor_count
FROM doctors
GROUP BY specialization;

-- Q6: List patients and their doctors' names
SELECT p.name AS patient_name, d.name AS doctor_name
FROM patients p
JOIN doctors d ON p.doctor_id = d.doctor_id;

-- Q7: Show treatments along with patient names and doctor names
SELECT 
    t.treatment_id,
    t.treatment_type,
    t.treatment_time,
    p.name AS patient_name,
    d.name AS doctor_name
FROM treatments t
JOIN patients p ON t.patient_id = p.patient_id
JOIN doctors d ON p.doctor_id = d.doctor_id;

-- Q8: Count how many patients each doctor supervises
SELECT d.name AS doctor_name, COUNT(p.patient_id) AS patient_count
FROM doctors d
LEFT JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name;

-- Q9: Calculate the average age of patients, displayed as average_age
SELECT AVG(age) AS average_age
FROM patients;

-- Q10: Find the most common treatment type, display only that
SELECT treatment_type AS most_common_treatment
FROM treatments
GROUP BY treatment_type
ORDER BY COUNT(treatment_id) DESC
LIMIT 1;

-- Q11: List patients older than the average age of all patients
SELECT *
FROM patients
WHERE age > (SELECT AVG(age) FROM patients);

-- Q12: List doctors who have more than 5 patients
SELECT d.name AS doctor_name, COUNT(p.patient_id) AS patient_count
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name
HAVING COUNT(p.patient_id) > 5;

-- Q13: List all treatments provided by nurses on morning shift, including patient names
SELECT 
    t.treatment_type,
    t.treatment_time,
    p.name AS patient_name,
    n.name AS nurse_name
FROM treatments t
JOIN nurses n ON t.nurse_id = n.nurse_id
JOIN patients p ON t.patient_id = p.patient_id
WHERE n.shift = 'Morning';

-- Q14: Find the latest treatment for each patient
SELECT p.name AS patient_name, t.treatment_type, t.treatment_time
FROM treatments t
JOIN (
    SELECT patient_id, MAX(treatment_time) AS latest_time
    FROM treatments
    GROUP BY patient_id
) sub ON t.patient_id = sub.patient_id AND t.treatment_time = sub.latest_time
JOIN patients p ON t.patient_id = p.patient_id;

-- Q15: List all doctors and the average age of their patients
SELECT 
    d.name AS doctor_name,
    ROUND(AVG(p.age), 1) AS avg_patient_age
FROM doctors d
LEFT JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name;

-- Q16: List names of doctors who supervise more than 3 patients
SELECT d.name AS doctor_name
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
GROUP BY d.name
HAVING COUNT(p.patient_id) > 3;

-- Q17: List all patients who have not received any treatments (using NOT IN)
SELECT name AS patient_name
FROM patients
WHERE patient_id NOT IN (SELECT DISTINCT patient_id FROM treatments);

-- Q18: List all medicines whose stock (quantity) is less than the average stock
SELECT medication_name, quantity
FROM medication_stock
WHERE quantity < (SELECT AVG(quantity) FROM medication_stock);

-- Q19: For each doctor, rank their patients by age
SELECT 
    d.name AS doctor_name,
    p.name AS patient_name,
    p.age,
    RANK() OVER (PARTITION BY d.doctor_id ORDER BY p.age DESC) AS age_rank
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
ORDER BY d.name, age_rank;

-- Q20: For each specialization, find the doctor with the oldest patient
SELECT 
    d.specialization,
    d.name AS doctor_name,
    p.name AS oldest_patient_name,
    p.age AS oldest_patient_age
FROM doctors d
JOIN patients p ON d.doctor_id = p.doctor_id
JOIN (
    SELECT 
        d.specialization,
        MAX(p.age) AS max_age
    FROM doctors d
    JOIN patients p ON d.doctor_id = p.doctor_id
    GROUP BY d.specialization
) sub ON d.specialization = sub.specialization AND p.age = sub.max_age
ORDER BY d.specialization;

