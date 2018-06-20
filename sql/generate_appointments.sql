CREATE OR REPLACE FUNCTION generateAppointments() RETURNS SETOF crocodile AS
$BODY$
DECLARE
    r crocodile%rowtype;
BEGIN
FOR r IN SELECT * FROM crocodile ORDER BY id ASC OFFSET 10 LIMIT 1000
    LOOP
        WITH dates AS (
             SELECT generate_series(current_timestamp - interval '5 years', current_timestamp, '2 hour') as d
        )

        INSERT INTO appointment (crocodile_id, plover_bird_id, emergency_level, schedule, done, area)
        SELECT
                r.id,
                plover_bird_id,
                emergency_level,
                tsrange(date_trunc('minute', from_time)::timestamp, date_trunc('minute', from_time + '1hour'::interval)::timestamp) as schedule,
                emergency_level %2 = 0 AS done,
                ST_SetSRID(ST_MakePoint(longitude, latitude), 4326) as area
        FROM (
             SELECT(
                SELECT x::int  as plover_bird_id
                       FROM (
                            select id
                            FROM ( SELECT id FROM plover_bird order by random() LIMIT 1
                                 ) randomid,
                           generate_series(1, 1 + (generator*0))
                      ) AS y(x)
             ),
             (
                SELECT x::int as emergency_level
                FROM (
                     SELECT l
                     FROM (SELECT floor(random()*10 + 1)::int as l
                     ) randomlevel,
                     generate_series(1, 1 + (generator*0))
                     ) AS y(x)
             ),
             (
                SELECT x as from_time FROM (
                       SELECT d
                       FROM (SELECT d FROM dates ORDER BY random() LIMIT 1) randomdate,
                       generate_series(1, 1+ (generator*0))
                       ) AS y(x)
             ),
             (
                SELECT x::int as longitude FROM (
                       SELECT l
                       FROM (SELECT floor(random()*49 - 129)::int as l
                       ) randomlongitude,
                       generate_series(1, 1+ (generator*0))
                       ) AS y(x)
             ),
             (
                SELECT x::int as latitude FROM (
                       SELECT l
                       FROM (SELECT floor(random()*16 - 32)::int as l
                       ) randomlongitude,
                       generate_series(1, 1+ (generator*0))
                       ) AS y(x)
             ),
             generator as id FROM generate_series(1, floor(random()*5 + 8)::int) as generator
        ) sub;

        RETURN NEXT r;
    END LOOP;
END
$BODY$
LANGUAGE plpgsql;
