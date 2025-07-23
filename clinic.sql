-- Create a new schema
CREATE SCHEMA CLINIC AUTHORIZATION admin;

-- Drop the default schema
DROP SCHEMA PUBLIC;

-- Create custom domain types with format validation
CREATE DOMAIN CLINIC.PATIENT_ID AS CHAR(6) NOT NULL
	CHECK (VALUE ~ '^[P]{1}[-]{1}\d{4}$'); 

CREATE DOMAIN CLINIC.SPECIALIST_ID AS CHAR(7) NOT NULL
	CHECK (VALUE ~ '^[ME]{2}[-]{1}\d{4}$');
	
CREATE DOMAIN CLINIC.APPOINTMENT_ID AS CHAR(7) NOT NULL
	CHECK (VALUE ~ '^[CM]{2}[-]{1}\d{4}$'); 
	

-- Table: PATIENT
CREATE TABLE CLINIC.PATIENT (
	pk_patient_id CLINIC.PATIENT_ID,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	gender CHAR(1) NOT NULL,
	date_of_birth DATE NOT NULL,
	city VARCHAR(20) NOT NULL,
	state VARCHAR(20) NOT NULL,
	phone CHAR(10) UNIQUE,
	PRIMARY KEY (pk_patient_id)
);

-- Table: SPECIALIST
CREATE TABLE CLINIC.SPECIALIST (
	pk_specialist_id CLINIC.SPECIALIST_ID,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20) NOT NULL,
	gender CHAR(1) NOT NULL,
	date_of_birth DATE NOT NULL,
	specialty VARCHAR(30) NOT NULL,
	PRIMARY KEY (pk_specialist_id)
);

-- Table: MEDICAL_RECORD
CREATE TABLE CLINIC.MEDICAL_RECORD (
	pk_patient_id CLINIC.PATIENT_ID,
	blood_type VARCHAR(10) NOT NULL,
	allergy_type VARCHAR(50) NOT NULL,
	chronic_condition VARCHAR(50) NOT NULL,
	created_at TIMESTAMP NOT NULL,
	PRIMARY KEY (pk_patient_id),
	FOREIGN KEY (pk_patient_id) REFERENCES CLINIC.PATIENT(pk_patient_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

-- Table: MEDICAL_DIAGNOSIS
CREATE TABLE CLINIC.MEDICAL_DIAGNOSIS (
	folio SERIAL NOT NULL,
	fk_specialist_id CLINIC.SPECIALIST_ID,
	fk_patient_id CLINIC.PATIENT_ID,
	age CHAR(3) NOT NULL,
	weight CHAR(3) NOT NULL,
	height CHAR(4) NOT NULL,
	bmi CHAR(5) NOT NULL,
	weight_level CHAR(10) NOT NULL,
	blood_pressure CHAR(8) NOT NULL,
	diagnosis VARCHAR(150) NOT NULL,
	prescription VARCHAR(150) NOT NULL,
	created_at TIMESTAMP NOT NULL,
	PRIMARY KEY (folio),
	FOREIGN KEY (fk_specialist_id) REFERENCES CLINIC.SPECIALIST(pk_specialist_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (fk_patient_id) REFERENCES CLINIC.MEDICAL_RECORD(pk_patient_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

-- Table: APPOINTMENT
CREATE TABLE CLINIC.APPOINTMENT (
	pk_appointment_id CLINIC.APPOINTMENT_ID,
	fk_patient_id CLINIC.PATIENT_ID,
	date DATE NOT NULL,
	time TIME NOT NULL,
	PRIMARY KEY (pk_appointment_id),
	FOREIGN KEY (fk_patient_id) REFERENCES CLINIC.PATIENT(pk_patient_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);

-- Table: SCHEDULE_APPOINTMENT
CREATE TABLE CLINIC.SCHEDULE_APPOINTMENT (
	fk_appointment_id CLINIC.APPOINTMENT_ID,
	fk_specialist_id CLINIC.SPECIALIST_ID,
	room VARCHAR(20) NOT NULL,
	appointment_date DATE NOT NULL,
	appointment_time TIME NOT NULL,
	shift VARCHAR(10) NOT NULL,
	status VARCHAR(10) NOT NULL,
	notes VARCHAR(100) NOT NULL,
	PRIMARY KEY (fk_appointment_id, fk_specialist_id),
	FOREIGN KEY (fk_appointment_id) REFERENCES CLINIC.APPOINTMENT(pk_appointment_id)
		ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (fk_specialist_id) REFERENCES CLINIC.SPECIALIST(pk_specialist_id)
		ON UPDATE CASCADE ON DELETE CASCADE
);


-- INSERT PATIENTS
INSERT INTO CLINIC.PATIENT (
  pk_patient_id, first_name, last_name, gender, date_of_birth, city, state, phone
) VALUES
('P-0001', 'Haruki', 'Takahashi', 'M', '1985-06-21', 'Tokyo', 'Tokyo', '0355511122'),
('P-0002', 'Yuki', 'Sato', 'F', '1990-11-30', 'Osaka', 'Osaka', '0665512244'),
('P-0003', 'Ren', 'Kobayashi', 'O', '2002-03-14', 'Sapporo', 'Hokkaido', '0115553399'),
('P-0004', 'Aoi', 'Tanaka', 'F', '1995-07-09', 'Nagoya', 'Aichi', '0525557788'),
('P-0005', 'Kaito', 'Yamamoto', 'M', '1988-01-17', 'Fukuoka', 'Fukuoka', '0925556677'),
('P-0006', 'Sora', 'Inoue', 'F', '1993-04-26', 'Kobe', 'Hyogo', '0785554411'),
('P-0007', 'Hikaru', 'Fujimoto', 'M', '1979-10-03', 'Hiroshima', 'Hiroshima', '0825559988'),
('P-0008', 'Miyu', 'Shimizu', 'F', '2000-12-12', 'Sendai', 'Miyagi', '0225558899'),
('P-0009', 'Takumi', 'Okamoto', 'M', '1997-05-08', 'Yokohama', 'Kanagawa', '0455553344'),
('P-0010', 'Riko', 'Nakamura', 'F', '1991-09-25', 'Kyoto', 'Kyoto', '0755557766');

-- INSERT SPECIALISTS
INSERT INTO CLINIC.SPECIALIST (
  pk_specialist_id, first_name, last_name, gender, date_of_birth, specialty
) VALUES
('ME-0001', 'Kenji', 'Yamada', 'M', '1975-04-10', 'Cardiology'),
('ME-0002', 'Ayaka', 'Matsumoto', 'F', '1982-09-22', 'Neurology'),
('ME-0003', 'Daichi', 'Ito', 'M', '1980-02-13', 'Dermatology'),
('ME-0004', 'Hana', 'Kawasaki', 'F', '1990-07-29', 'Pediatrics'),
('ME-0005', 'Shota', 'Abe', 'M', '1978-11-16', 'Orthopedics'),
('ME-0006', 'Yui', 'Nakagawa', 'F', '1987-03-03', 'Psychiatry'),
('ME-0007', 'Takeshi', 'Sakamoto', 'M', '1985-06-07', 'Oncology'),
('ME-0008', 'Misaki', 'Fukuda', 'F', '1991-12-19', 'Gastroenterology'),
('ME-0009', 'Riku', 'Ando', 'M', '1983-08-25', 'Endocrinology'),
('ME-0010', 'Emi', 'Kojima', 'F', '1989-10-11', 'General Medicine');

-- INSERT MEDICAL RECORDS
INSERT INTO CLINIC.MEDICAL_RECORD (
	  pk_patient_id, blood_type, allergy_type, chronic_condition, created_at
) VALUES
('P-0001', 'A+', 'None', 'None', '2023-10-01 10:23:00'),
('P-0002', 'B-', 'Peanuts', 'Asthma', '2023-10-02 11:011:00'),
('P-0003', 'O+', 'Crustacean', 'Diabetes', '2023-10-03 12:43:00'),
('P-0004', 'AB+', 'Penicillin', 'Hypertension', '2023-10-04 12:51:00'),
('P-0005', 'A-', 'Latex', 'None', '2023-11-05 14:50:00'),
('P-0006', 'B+', 'None', 'Anxiety', '2023-11-06 15:13:00'),
('P-0007', 'O-', 'Shellfish', 'None', '2023-11-27 16:15:00'),
('P-0008', 'AB-', 'None', 'None', '2023-12-18 17:03:00'),
('P-0009', 'A+', 'None', 'Obesity', '2023-12-09 17:32:00'),
('P-0010', 'B-', 'Dust Mites', 'None', '2023-12-09 20:28:00');

ALTER TABLE CLINIC.PATIENT
ADD COLUMN age INT,
ADD COLUMN height NUMERIC(5,2), -- in cm or meters, adjust as needed
ADD COLUMN weight NUMERIC(5,2), -- in kg
ADD COLUMN bmi NUMERIC(5,2),
ADD COLUMN blood_pressure VARCHAR(15),
ADD COLUMN prescription VARCHAR(255);


UPDATE CLINIC.PATIENT
SET height = 1.72, weight = 65.0, blood_pressure = '120/80', prescription = 'Vitamin D supplement'
WHERE pk_patient_id = 'P-0001';

UPDATE CLINIC.PATIENT
SET height = 1.60, weight = 52.0, blood_pressure = '110/70', prescription = 'Antihistamines'
WHERE pk_patient_id = 'P-0002';

UPDATE CLINIC.PATIENT
SET height = 1.68, weight = 75.0, blood_pressure = '130/85', prescription = 'Metformin'
WHERE pk_patient_id = 'P-0003';

UPDATE CLINIC.PATIENT
SET height = 1.75, weight = 90.0, blood_pressure = '140/90', prescription = 'Lisinopril'
WHERE pk_patient_id = 'P-0004';

UPDATE CLINIC.PATIENT
SET height = 1.55, weight = 45.0, blood_pressure = '105/65', prescription = 'None'
WHERE pk_patient_id = 'P-0005';

UPDATE CLINIC.PATIENT
SET height = 1.80, weight = 85.0, blood_pressure = '125/80', prescription = 'Omega-3'
WHERE pk_patient_id = 'P-0006';

UPDATE CLINIC.PATIENT
SET height = 1.65, weight = 70.0, blood_pressure = '118/75', prescription = 'Ibuprofen as needed'
WHERE pk_patient_id = 'P-0007';

UPDATE CLINIC.PATIENT
SET height = 1.62, weight = 68.0, blood_pressure = '128/78', prescription = 'Inhaler - Salbutamol'
WHERE pk_patient_id = 'P-0008';

UPDATE CLINIC.PATIENT
SET height = 1.70, weight = 60.0, blood_pressure = '122/76', prescription = 'Antacids'
WHERE pk_patient_id = 'P-0009';

UPDATE CLINIC.PATIENT
SET height = 1.58, weight = 50.0, blood_pressure = '115/70', prescription = 'Calcium supplement'
WHERE pk_patient_id = 'P-0010';

-- add email

ALTER TABLE CLINIC.PATIENT
ADD COLUMN email VARCHAR(100);


update clinic.patient
set email = 'haruki.takahashi@example.jp'
where pk_patient_id = 'P-0001';

update clinic.patient
set email = 'yuki.sato@example.jp'
where pk_patient_id = 'P-0002';

update clinic.patient
set email = 'ren.kobayashi@example.jp'
where pk_patient_id = 'P-0003';

update clinic.patient
set email = 'aoi.tanaka@example.jp'
where pk_patient_id = 'P-0004';

update clinic.patient
set email = 'kaito.yamamoto@example.jp'
where pk_patient_id = 'P-0005';

update clinic.patient
set email = 'sora.inoue@example.jp'
where pk_patient_id = 'P-0006';

update clinic.patient
set email = 'hikaru.fujimoto@example.jp'
where pk_patient_id = 'P-0007';

update clinic.patient
set email = 'miyu.shimizu@example.jp'
where pk_patient_id = 'P-0008';

update clinic.patient
set email = 'takumi.okamoto@example.jp'
where pk_patient_id = 'P-0009';

update clinic.patient
set email = 'riko.nakamura@example.jp'
where pk_patient_id = 'P-0010';

--insert appointments and schedule appointments
INSERT INTO CLINIC.APPOINTMENT (
	  pk_appointment_id, fk_patient_id, date, time
) VALUES
('CM-0001', 'P-0001', '2023-10-05', '10:00:00'),
('CM-0002', 'P-0002', '2023-10-06', '11:00:00'),
('CM-0003', 'P-0003', '2023-10-07', '12:00:00'),
('CM-0004', 'P-0004', '2023-10-08', '13:00:00'),
('CM-0005', 'P-0005', '2023-10-09', '14:00:00'),
('CM-0006', 'P-0006', '2023-10-10', '15:00:00'),
('CM-0007', 'P-0007', '2023-10-11', '16:00:00'),
('CM-0008', 'P-0008', '2023-10-12', '17:00:00'),
('CM-0009', 'P-0009', '2023-10-13', '18:00:00'),
('CM-0010', 'P-0010', '2023-10-14', '19:00:00');

INSERT INTO CLINIC.SCHEDULE_APPOINTMENT (
	  fk_appointment_id, fk_specialist_id, room, appointment_date, appointment_time, shift, status, notes
) VALUES
('CM-0001', 'ME-0001', 'Room 101', '2023-10-05', '10:00:00', 'Morning', 'Scheduled', 'Initial consultation'),
('CM-0002', 'ME-0002', 'Room 102', '2023-10-06', '11:00:00', 'Morning', 'Scheduled', 'Follow-up visit'),
('CM-0003', 'ME-0003', 'Room 103', '2023-10-07', '12:00:00', 'Afternoon', 'Scheduled', 'Skin check-up'),
('CM-0004', 'ME-0004', 'Room 104', '2023-10-08', '13:00:00', 'Afternoon', 'Scheduled', 'Pediatric assessment'),
('CM-0005', 'ME-0005', 'Room 105', '2023-10-09', '14:00:00', 'Afternoon', 'Scheduled', 'Orthopedic evaluation'),
('CM-0006', 'ME-0006', 'Room 106', '2023-10-10', '15:00:00', 'Evening', 'Scheduled', 'Psychiatric consultation'),
('CM-0007', 'ME-0007', 'Room 107', '2023-10-11', '16:00:00', 'Evening', 'Scheduled', 'Oncology review'),
('CM-0008', 'ME-0008', 'Room 108', '2023-10-12', '17:00:00', 'Evening', 'Scheduled', 'Gastroenterology check'),
('CM-0009', 'ME-0009', 'Room 109', '2023-10-13', '18:00:00', 'Evening', 'Scheduled', 'Endocrinology assessment'),
('CM-0010', 'ME-0010', 'Room 110', '2023-10-14', '19:00:00', 'Evening', 'Scheduled','General medicine follow-up');

-- delete a patient
DELETE FROM CLINIC.PATIENT
WHERE pk_patient_id = 'P-0005';	

-- delete a specialist
DELETE FROM CLINIC.SPECIALIST
WHERE pk_specialist_id = 'ME-0003';

--insert medical diagnosis
INSERT INTO CLINIC.MEDICAL_DIAGNOSIS (
	  fk_specialist_id, fk_patient_id, age, weight, height, bmi, weight_level, blood_pressure, diagnosis, prescription, created_at
) VALUES
('ME-0001', 'P-0001', '38', '65.0', '172', '22.0', 'Normal', '120/80', 'Healthy', 'Vitamin D supplement', '2023-10-01 10:30:00'),
('ME-0002', 'P-0002', '33', '52.0', '160', '20.3', 'Normal', '110/70', 'Allergic Rhinitis', 'Antihistamines', '2023-10-02 11:15:00'),
('ME-0003', 'P-0003', '21', '75.0', '168', '26.6', 'Overweight', '130/85', 'Type 2 Diabetes', 'Metformin', '2023-10-03 12:45:00'),
('ME-0004', 'P-0004', '28', '90.0', '175', '29.4', 'Obese', '140/90', 'Hypertension', 'Lisinopril', '2023-10-04 12:55:00'),
('ME-0005', 'P-0006', '30', '85.0', '180', '26.2', 'Overweight', '125/80', 'Anxiety Disorder', 'Omega-3', '2023-11-06 15:15:00'),
('ME-0006', 'P-0007', '44', '70.0', '165', '25.7', 'Normal', '118/75', 'Joint Pain', 'Ibuprofen as needed', '2023-11-27 16:20:00'),
('ME-0007', 'P-0008', '23', '68.0', '162', '25.9', 'Normal', '128/78', 'Asthma', 'Inhaler - Salbutamol', '2023-12-18 17:05:00'),
('ME-0008', 'P-0009', '32', '60.0', '170', '20.8', 'Normal', '122/76', 'Gastritis', 'Antacids', '2023-12-09 17:35:00'),
('ME-0009', 'P-0010', '31', '50.0', '158', '20.0', 'Normal', '115/70', 'Calcium Deficiency', 'Calcium supplement', '2023-12-09 20:30:00');		

-- inner join exaple
select * from clinic.patient
inner join clinic.medical_record
on patient.pk_patient_id = medical_record.pk_patient_id;

-- complex inner join exaple
select * from clinic.patient
inner join clinic.medical_record
on patient.pk_patient_id = medical_record.pk_patient_id
inner join clinic.medical_diagnosis
on medical_record.pk_patient_id = medical_diagnosis.fk_patient_id
inner join clinic.specialist
on medical_diagnosis.fk_specialist_id = specialist.pk_specialist_id;
where patient.pk_patient_id = 'P-0001';

-- view creations
create view clinic.masculine_patients as 
	select * from clinic.patient where gender = 'F';

--nested consultation
select * from  clinic.specialist
	where pk_specialist_id
	not in (select fk_specialist_id
		from clinic.schedule_appointment
		where appointment_date between '2022-10-05' and '2021-10-05')
