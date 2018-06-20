CREATE TABLE IF NOT EXISTS crocodile (
       id serial,
       first_name varchar(250) NOT NULL,
       last_name varchar(250) NOT NULL,
       birthday date NOT NULL,
       number_of_teeth integer NOT NULL,
       last_check_up timestamp with time zone,

       CONSTRAINT crocodile_pkey PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS plover_bird (
       id serial,
       first_name varchar(250) NOT NULL,
       last_name varchar(250) NOT NULL,
       teacher_id INTEGER REFERENCES plover_bird (id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,

       CONSTRAINT plover_bird_pkey PRIMARY KEY (id)
);

CREATE EXTENSION btree_gist;

CREATE TABLE IF NOT EXISTS appointment (
       id serial,
       crocodile_id INTEGER NOT NULL REFERENCES crocodile (id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
       plover_bird_id INTEGER REFERENCES plover_bird (id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED,
       emergency_level integer NOT NULL CHECK (emergency_level > 0 AND emergency_level < 11),
       schedule tsrange NOT NULL,
       done BOOLEAN DEFAULT FALSE,
       area GEOMETRY(Point, 4326),

       EXCLUDE USING GIST (crocodile_id WITH =, schedule WITH &&),
       CONSTRAINT appointment_pkey PRIMARY KEY (id)
);


CREATE OR REPLACE FUNCTION update_last_check_up()
       RETURNS TRIGGER
       AS $$
       BEGIN
           IF NEW.done IS TRUE AND OLD.done IS FALSE THEN
              UPDATE crocodile SET last_check_up = upper(NEW.schedule)
              WHERE crocodile.id = NEW.crocodile_id AND (crocodile.last_check_up IS NULL OR crocodile.last_check_up < upper(NEW.schedule));
          END IF;
      RETURN NEW;
      END $$ LANGUAGE plpgsql;


CREATE TRIGGER update_last_check_up_trigger
AFTER UPDATE OF done ON appointment
FOR EACH ROW
EXECUTE PROCEDURE update_last_check_up();
