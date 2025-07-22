-- Create a new schema
CREATE SCHEMA CLINIC AUTHORIZATION postgres;

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