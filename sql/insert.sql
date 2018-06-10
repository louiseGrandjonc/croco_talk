INSERT INTO crocodile (first_name, last_name, birthday, number_of_teeth) VALUES ('Louise', 'Grandjonc', '1991-12-21', 58);

INSERT INTO crocodile (first_name, last_name, birthday, number_of_teeth) VALUES ('Stephan', 'Zimmerli', '1976-12-14', 61);


-- Test insert appointment with wrong emergency level

INSERT INTO appointment (crocodile_id, emergency_level, schedule) VALUES
(1, 12, '[2018-06-10 11:30, 2018-06-10 12:30]');

-- ERROR:  new row for relation "appointment" violates check constraint "appointment_emergency_level_check"
-- DETAIL:  Failing row contains (1, 1, null, 12, ["2018-06-10 11:30:00","2018-06-10 12:30:00"], f).


-- Test insert first appointment
INSERT INTO appointment (crocodile_id, emergency_level, schedule) VALUES
(1, 10, '[2018-06-10 11:30, 2018-06-10 12:30]');

-- Test insert second overlapping
INSERT INTO appointment (crocodile_id, emergency_level, schedule) VALUES
(1, 10, '[2018-06-10 11:00, 2018-06-10 12:00]');

-- ERROR:  conflicting key value violates exclusion constraint "appointment_crocodile_id_schedule_excl"
-- DETAIL:  Key (crocodile_id, schedule)=(1, ["2018-06-10 11:00:00","2018-06-10 12:00:00"]) conflicts with existing key (crocodile_id, schedule)=(1, ["2018-06-10 11:30:00","2018-06-10 12:30:00"]).

-- Test insert overlapping but for an other croco
INSERT INTO appointment (crocodile_id, emergency_level, schedule) VALUES
(2, 10, '[2018-06-10 11:00, 2018-06-10 12:00]');

-- Test update appointment, value of last_check_up
UPDATE appointment SET done=False WHERE crocodile_id = 1;

-- croco=# SELECT * FROM crocodile
-- ;
--  id | first_name | last_name |  birthday  | number_of_teeth |     last_check_up
-- ----+------------+-----------+------------+-----------------+------------------------
--   2 | Stephan    | Zimmerli  | 1976-12-14 |              61 |
--   1 | Louise     | Grandjonc | 1991-12-21 |              58 | 2018-06-10 12:30:00+02
