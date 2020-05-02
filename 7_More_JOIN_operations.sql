--1
/* List the films where the yr is 1962 [Show id, title] */
SELECT
  id,
  title
FROM
  movie
WHERE
  yr = 1962;

--2
/* Give year of 'Citizen Kane'. */
SELECT
  yr
FROM
  movie
WHERE
  title = 'Citizen Kane';

--3
/* List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year. */
SELECT
  id,
  title,
  yr
FROM
  movie
WHERE
  title LIKE 'Star Trek%'
ORDER BY
  yr;

--4
/* What id number does the actor 'Glenn Close' have? */
SELECT
  id
FROM
  actor
WHERE
  name = 'Glenn Close';

--5
/* What is the id of the film 'Casablanca' */
SELECT
  id
FROM
  movie
WHERE
  title = 'Casablanca';

--6
/* Obtain the cast list for 'Casablanca'. */
SELECT
  name
FROM
  movie m
  JOIN casting c ON c.movieid = m.id
  JOIN actor a ON a.id = c.actorid
WHERE
  m.title = 'Casablanca';

--7
/* Obtain the cast list for the film 'Alien' */
SELECT
  name
FROM
  movie m
  JOIN casting c ON c.movieid = m.id
  JOIN actor a ON a.id = c.actorid
WHERE
  m.title = 'alien';

--8
/* List the films in which 'Harrison Ford' has appeared */
SELECT
  m.title
FROM
  actor a
  JOIN casting c ON c.actorid = a.id
  JOIN movie m ON m.id = c.movieid
WHERE
  a.name = 'Harrison Ford';

--9
/* List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role] */
SELECT
  m.title
FROM
  actor a
  JOIN casting c ON c.actorid = a.id
  JOIN movie m ON m.id = c.movieid
WHERE
  a.name = 'Harrison Ford'
  AND c.ord != 1;

--10
/* List the films together with the leading star for all 1962 films. */
SELECT
  m.title,
  a.name
FROM
  movie m
  JOIN casting c ON c.movieid = m.id
  JOIN actor a ON a.id = c.actorid
WHERE
  c.ord = 1
  AND m.yr = 1962;

-11
/* Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies. */
SELECT
  yr,
  COUNT(title)
FROM
  movie
  JOIN casting ON movie.id = movieid
  JOIN actor ON actorid = actor.id
WHERE
  name = 'Rock Hudson'
GROUP BY
  yr
HAVING
  COUNT(title) > 2;

--12
/* List the film title and the leading actor for all of the films 'Julie Andrews' played in. */
SELECT
  title,
  name
FROM
  movie
  JOIN casting ON movieid = movie.id
  AND ord = 1
  JOIN actor ON actorid = actor.id
WHERE
  movie.id IN(
    SELECT
      movieid
    FROM
      casting
    WHERE
      actorid IN (
        SELECT
          id
        FROM
          actor
        WHERE
          name = 'Julie Andrews'
      )
  );

--13
/* Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles. */
SELECT
  name
FROM
  casting c
  JOIN actor a ON a.id = c.actorid
WHERE
  ord = 1
GROUP BY
  name
HAVING
  sum(ord) >= 15
ORDER BY
  name;

--14
/* List the films released in the year 1978 ordered by the number of actors in the cast, then by title. */
SELECT
  title,
  count(actorid)
FROM
  movie m
  JOIN casting c ON c.movieid = m.id
WHERE
  yr = 1978
GROUP BY
  title
ORDER BY
  count(actorid) DESC,
  title;

--15
/* List all the people who have worked with 'Art Garfunkel'.  */
SELECT
  name
FROM
  actor
  JOIN casting ON actor.id = actorid
WHERE
  movieid IN (
    SELECT
      movieid
    FROM
      casting
    WHERE
      actorid IN (
        SELECT
          id
        FROM
          actor
        WHERE
          name = 'art garfunkel'
      )
  )
  AND name != 'Art Garfunkel';