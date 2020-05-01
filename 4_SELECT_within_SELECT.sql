--1
/* List each country name where the population is larger than that of 'Russia' */
SELECT
  name
FROM
  world
WHERE
  population > (
    SELECT
      population
    FROM
      world
    WHERE
      name = 'russia'
  );

--2
/* Show the countries in Europe with a per capita GDP greater than 'United Kingdom'. */
SELECT
  name
FROM
  world
WHERE
  gdp / population > (
    SELECT
      gdp / population
    FROM
      world
    WHERE
      name = 'united kingdom'
  )
  AND continent = 'europe';

--3
/* List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country. */
SELECT
  name,
  continent
FROM
  world
WHERE
  continent IN(
    (
      SELECT
        continent
      FROM
        world
      WHERE
        name IN ('argentina', 'australia')
    )
  )
ORDER BY
  name;

--4 
/* Which country has a population that is more than Canada but less than Poland? Show the name and the population. */
SELECT
  name,
  population
FROM
  world
WHERE
  population BETWEEN (
    SELECT
      population
    FROM
      world
    WHERE
      name = 'poland'
  )
  AND (
    SELECT
      population
    FROM
      world
    WHERE
      name = 'canada'
  );

--5
/* Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany.
 Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany. */
SELECT
  name,
  concat(
    round(
      (
        population /(
          SELECT
            population
          FROM
            world
          WHERE
            name = 'germany'
        )
      ) * 100
    ),
    '%'
  ) AS percentage
FROM
  world
WHERE
  continent = 'europe';

--6
/* Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values) */
SELECT
  name
FROM
  world
WHERE
  gdp > ALL(
    SELECT
      gdp
    FROM
      world
    WHERE
      continent = 'europe'
      AND gdp IS NOT NULL
  );

--7
/* Find the largest country (by area) in each continent, show the continent, the name and the area: */
SELECT
  continent,
  name,
  area
FROM
  world x
WHERE
  x.area >= ALL (
    SELECT
      area
    FROM
      world y
    WHERE
      y.continent = x.continent
  );

--8 
/* List each continent and the name of the country that comes first alphabetically */
SELECT
  continent,
  name
FROM
  world w
WHERE
  name <= ALL (
    SELECT
      name
    FROM
      world
    WHERE
      continent = w.continent
  );

--9
/* Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population. */
SELECT
  name,
  continent,
  population
FROM
  world w
WHERE
  25000000 > ALL (
    SELECT
      population
    FROM
      world
    WHERE
      continent = w.continent
  );

--10
/* Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents. */
SELECT
  name,
  continent
FROM
  world w
WHERE
  population / 3 > ALL (
    SELECT
      population
    FROM
      world
    WHERE
      continent = w.continent
      AND name NOT LIKE w.name
  );