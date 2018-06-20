INSERT INTO plover_bird (first_name, last_name)
SELECT name_first, name_last
FROM (
   -- name_first
  SELECT (
        SELECT initcap(string_agg(x,''))  as name_first
               FROM (
                    select start_arr[ 1 + ( (random() * 33)::int) % 33 ]
                    FROM (
                         select '{alfred,harry,lisa,louise,mary,will,han,li,mustafa,lila,samuel,david,sophia,clemence,pauline,guy,romain,florent,yann,rebecca,deborah,perrine,quentin,noe,valentin,adrian,agustin,robin,gabriel,anne,pedro,pablo,oussama}'::text[] as start_arr
                    ) syllarr,
                    generate_series(1, 1 + (generator*0))
               ) AS con_name_first(x)
    ),
    -- name_last
    (
        SELECT initcap(string_agg(x,''))  as name_last
               FROM (
                    select start_arr[ 1 + ( (random() * 369)::int) % 369 ]
                    FROM (
                         select '{Díaz,Mora,Rodríguez,González,Hernández,Morales,Sánchez,Ramírez,Pérez,Calderón,Gutiérrez,Rojas,Salas,Vargas,Torres,Segura,Valverde,Villalobos,Araya,Herrera,López,Madrigal,Smith,Johnson,Williams,Brown,Jones,Miller,Davis,Garcia,Rodriguez,Wilson,Martinez,Anderson,Taylor,Thomas,Hernandez,Moore,Martin,Jackson,Thompson,White,Lopez,Lee,Gonzalez,Harris,Clark,Lewis,Robinson,Walker,Perez,Hall,Young,Allen,Sanchez,Wright,King,Scott,Green,Baker,Adams,Nelson,Hill,Ramirez,Campbell,Mitchell,Roberts,Carter,Phillips,Evans,Turner,Torres,Parker,Collins,Edwards,Stewart,Flores,Morris,Nguyen,Murphy,Rivera,Cook,Rogers,Morgan,Peterson,Cooper,Reed,Bailey,Bell,Gomez,Kelly,Howard,Ward,Cox,Diaz,Richardson,Wood,Watson,Brooks,Bennett,Gray,James,Reyes,Cruz,Hughes,Price,Myers,Long,Foster,Sanders,Ross,Morales,Powell,Sullivan,Russell,Ortiz,Jenkins,Gutierrez,Perry,Butler,Barnes,Fisher,Wong,Lee,Cheung,Lau,Chan,Yeung,Wong,Chiu,Chow,Tsui,Suen,Ma,Chu,Woo,Kwok,Ho,Ko,Lam,Beridze,Mammadov,Kapanadze,Gelashvili,Maisuradze,Giorgadze,Tsiklauri,Bolkvadze,Kvaratskhelia,Khutsishvili,Shengelia,Mikeladze,Tabatadze,Mchedlishvili,Bairamov,Gogoladze,Ahmed,Ali,Aktar,Bonik,Byapari,Boruya,Bishwas,Bhoumik,Bosu,Chakma,Chokroborti,Chottopadhyay,Choudhuri,Das,Debnath,Dewan,De,Dotto,Gazi,Hok,Hasan,Hosen,Singh,Kumar,Das,Kaur,Mandal,Ram,Yadav,Kumari,Ali,Lal,Bibi,Khatun,Bai,Sharma,Shah,Khan,Patel,Patil,Rajput,Satō,Suzuki,Takahashi,Tanaka,Watanabe,Ito,Nakamura,Kobayashi,Yamamoto,Katō,Yoshida,Yamada,Sasaki,Yamaguchi,Matsumoto,Inoue,Kimura,Shimizu,Hayashi,Yamasaki,Nakashima,Mori,Abe,Ikeda,Hashimoto,Ishikawa,Yamashita,Ogawa,Kim,Lee,Park,Choi,Jeong,Kang,Cho,Yoon,Jang,Lim,Han,O,Shin,Seo,Kwon,Hwang,Ahn,Martin,Bernard,Dubois,Thomas,Robert,Richard,Petit,Durand,Leroy,Moreau,Simon,Laurent,Lefebvremith,Michel,Garcia,David,Bertrand,Roux,Vincent,Fournier,Morel,Girard,André,Lefèvre,Mercier,Dupont,Lambert,Bonnet,François,Martinez,Müller,Schmidt,Schneide,Fischer,Meyer,Weber,Schulz,Wagner,Becker,Hoffmannthe,Rossi,Russo,Ferrari,Esposito,Bianchi,Romano,Colombo,Bruno,Ricci,Greco,Marino,Gallo,De Luca,Conti,Costa,Mancini,Giordano,Rizzo,Lombardi,Barbier,Moretti,Fontana,Caruso,Mariani,Ferrara,Santoro,Rinaldi,Leone,DAngelo,Longo,Galli,Martini,Martinelli,Serra,Conte,Vitale,De Santis,Marchetti,Messina,Gentile,Villa,Marini,Lombardo,Coppola,Ferri,Parisi,De Angelis,Bianco,Amato,Fabbri,Gatti,Sala,Morelli,Grasso,Pellegrini,Ferraro,Monti,Palumbo,Grassi,Testa,Valentini,Carbono,Benedetti,Silvestri,Farina,Martino,Bernardi,Caputo,Mazza,Sanna,Fiore,De Rosa,Pellegrino,Giuliani,Rizzi,Di Stefano,Cattaneo,Rossetti,Orlando,Basile,Neri,Barone,Palmieri,Riva,Romeo,Franco,Sorrentino,Pagano}'::text[] as start_arr
               ) syllarr,
               generate_series(1, 1 + (generator*0))
         ) AS con_name_last(x)

    ),
    generator as id
    FROM generate_series(1, 100000) as generator
) main_sub;


-- first generation of teachers

WITH teacher_ids AS (SELECT id as teacher_id FROM plover_bird ORDER BY id LIMIT 25000),
students_ids AS (SELECT id as student_id FROM plover_bird ORDER BY id OFFSET 25000 LIMIT 25000),
update_values AS (
    SELECT s_id, t_id FROM (
        SELECT (
               SELECT x::int as t_id FROM (
                      SELECT teacher_id
                             FROM (SELECT teacher_id FROM teacher_ids ORDER BY random() LIMIT 1) randomid,
                             generate_series(1, 1 + (generator*0))
                     ) AS y(x)
              ),
              (
                SELECT student_id as s_id FROM students_ids ORDER BY student_id OFFSET generator LIMIT 1
              ),
              generator as id FROM generate_series(1, 25000) as generator
       ) main_sub
)

UPDATE plover_bird SET teacher_id=u.t_id FROM update_values u WHERE u.s_id=plover_bird.id;



-- second generation of teachers

WITH teacher_ids AS (SELECT id as teacher_id FROM plover_bird ORDER BY id LIMIT 50000),
students_ids AS (SELECT id as student_id FROM plover_bird ORDER BY id OFFSET 50000 LIMIT 25000),
update_values AS (
    SELECT s_id, t_id FROM (
        SELECT (
               SELECT x::int as t_id FROM (
                      SELECT teacher_id
                             FROM (SELECT teacher_id FROM teacher_ids ORDER BY random() LIMIT 1) randomid,
                             generate_series(1, 1 + (generator*0))
                     ) AS y(x)
              ),
              (
                SELECT student_id as s_id FROM students_ids ORDER BY student_id OFFSET generator LIMIT 1
              ),
              generator as id FROM generate_series(1, 25000) as generator
       ) main_sub
)

UPDATE plover_bird SET teacher_id=u.t_id FROM update_values u WHERE u.s_id=plover_bird.id;


-- third generation of teachers

WITH teacher_ids AS (SELECT id as teacher_id FROM plover_bird ORDER BY id),
students_ids AS (SELECT id as student_id FROM plover_bird ORDER BY id OFFSET 75000 LIMIT 25000),
update_values AS (
    SELECT s_id, t_id FROM (
        SELECT (
               SELECT x::int as t_id FROM (
                      SELECT teacher_id
                             FROM (SELECT teacher_id FROM teacher_ids ORDER BY random() LIMIT 1) randomid,
                             generate_series(1, 1 + (generator*0))
                     ) AS y(x)
              ),
              (
                SELECT student_id as s_id FROM students_ids ORDER BY student_id OFFSET generator LIMIT 1
              ),
              generator as id FROM generate_series(1, 25000) as generator
       ) main_sub
)
UPDATE plover_bird SET teacher_id=u.t_id FROM update_values u WHERE u.s_id=plover_bird.id;
