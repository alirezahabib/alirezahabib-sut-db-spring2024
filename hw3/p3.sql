CREATE TABLE users
(
    first_name VARCHAR(100),
    last_name  VARCHAR(100),
    email      VARCHAR(200) UNIQUE,
    user_id    SERIAL PRIMARY KEY
);

CREATE TABLE actors
(
    actor_id SERIAL PRIMARY KEY,
    name     VARCHAR(100)
);

CREATE TABLE movies
(
    movie_id VARCHAR(20) PRIMARY KEY,
    title    VARCHAR(200),
    director VARCHAR(100),
    budget   DECIMAL(15, 2),
    summary  TEXT,
    country  VARCHAR(100)
);

CREATE TABLE reviews
(
    user_id     INTEGER REFERENCES users (user_id),
    movie_id    VARCHAR(20) REFERENCES movies (movie_id),
    review_id   SERIAL PRIMARY KEY,
    review_text TEXT,
    score       NUMERIC CHECK (score >= 0 AND score <= 10)
);

CREATE TABLE act
(
    movie_id VARCHAR(20) REFERENCES movies (movie_id),
    actor_id INTEGER REFERENCES actors (actor_id),
    PRIMARY KEY (actor_id, movie_id)
);

-- COPY users FROM '/Users/alireza/PycharmProjects/db-hw3/p3/tables/users.csv' DELIMITER ',' CSV HEADER;
-- insert into users(first_name, last_name, Email, user_id)
-- values ('hamid', 'farzane', 'fhamid@gmail.com', 104);
--
-- COPY actors FROM '/Users/alireza/PycharmProjects/db-hw3/p3/tables/actors.csv' DELIMITER ',' CSV HEADER;
-- COPY movies FROM '/Users/alireza/PycharmProjects/db-hw3/p3/tables/movies.csv' DELIMITER ',' CSV HEADER;
-- COPY reviews FROM '/Users/alireza/PycharmProjects/db-hw3/p3/tables/reviews.csv' DELIMITER ',' CSV HEADER;
-- COPY act FROM '/Users/alireza/PycharmProjects/db-hw3/p3/tables/act.csv' DELIMITER ',' CSV HEADER;

-- 1: Movies that have the term "Gotham" in their summary.
SELECT *
FROM movies
WHERE summary LIKE '%Gotham%';

-- 2
UPDATE users
SET email = 'pawan.kumar@gmail.com'
WHERE first_name = 'Pawan'
  AND last_name = 'Kumar';

SELECT *
FROM users
WHERE first_name = 'Pawan'
  AND last_name = 'Kumar';

-- 3
SELECT actors.name, AVG(movies.budget)
FROM actors
         JOIN act ON actors.actor_id = act.actor_id
         JOIN movies ON act.movie_id = movies.movie_id
GROUP BY actors.name;

-- 4
SELECT country, COUNT(*) AS num_movies
FROM movies
GROUP BY country
ORDER BY num_movies DESC
LIMIT 1;

-- 5
CREATE OR REPLACE FUNCTION num_reviews(movie_id_input VARCHAR) RETURNS INTEGER AS
$$
BEGIN
    RETURN (SELECT COUNT(*) FROM reviews WHERE movie_id = movie_id_input);
END;
$$ LANGUAGE plpgsql;

-- 6
SELECT title, num_reviews(movie_id)
FROM movies;
