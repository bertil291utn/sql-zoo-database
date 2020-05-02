--1
/* Modify the query to show data from Spain  */
SELECT
  name,
  DAY(whn),
  confirmed,
  deaths,
  recovered
FROM
  covid
WHERE
  name = 'spain'
  AND MONTH(whn) = 3
ORDER BY
  whn;

--2
/* Modify the query to show confirmed for the day before. */
SELECT
  name,
  DAY(whn),
  confirmed,
  LAG(confirmed, 1) OVER (
    ORDER BY
      confirmed
  ) dbf
FROM
  covid
WHERE
  name = 'Italy'
  AND MONTH(whn) = 3
ORDER BY
  whn;

--3
/* Show the number of new cases for each day, for Italy, for March. */
SELECT
  name,
  DAY(whn),
  confirmed - LAG(confirmed, 1) OVER (
    PARTITION BY name
    ORDER BY
      whn
  ) new_cases
FROM
  covid
WHERE
  name = 'Italy'
  AND MONTH(whn) = 3;

--4
/* Show the number of new cases in Italy for each week - show Monday only */
SELECT
  name,
  DATE_FORMAT(whn, '%Y-%m-%d'),
  confirmed - LAG(confirmed, 1) OVER (
    PARTITION BY name
    ORDER BY
      whn
  )
FROM
  covid
WHERE
  name = 'Italy'
  AND WEEKDAY(whn) = 0;

--5
/* Show the number of new cases in Italy for each week - show Monday only. self JOIN */
SELECT
  tw.name,
  DATE_FORMAT(tw.whn, '%Y-%m-%d'),
  tw.confirmed - lw.confirmed
FROM
  covid tw
  LEFT JOIN covid lw ON DATE_ADD(lw.whn, INTERVAL 1 WEEK) = tw.whn
  AND tw.name = lw.name
WHERE
  tw.name = 'Italy'
  AND weekday(tw.whn) = 0;

--6
/* Include the ranking for the number of deaths in the table. Only include countries with a population of at least 10 million. */
SELECT
  name,
  confirmed,
  RANK() OVER (
    ORDER BY
      confirmed DESC
  ) rc,
  deaths,
  RANK() OVER (
    ORDER BY
      deaths DESC
  ) rc
FROM
  covid
WHERE
  whn = '2020-04-20'
ORDER BY
  confirmed DESC;

-- 7 
/* Show the infect rate ranking for each country. Only include countries with a population of at least 10 million. */
SELECT
  world.name,
  ROUND(100000 * confirmed / population, 0) cases_per_100K,
  RANK() OVER (
    ORDER BY
      confirmed / population
  ) rc
FROM
  covid
  JOIN world ON covid.name = world.name
WHERE
  whn = '2020-04-20'
  AND population >= 10000000
ORDER BY
  population DESC;

--8
/* For each country that has had at last 1000 new cases in a single day, show the date of the peak number of new cases.
 WARNING: Check to display in same order as example */
SELECT
  name,
  date,
  new_cases
FROM
(
    SELECT
      *,
      rank() over (
        PARTITION by name
        ORDER BY
          new_cases DESC
      ) rank
    FROM
      (
        SELECT
          name,
          DATE_FORMAT(whn, '%Y-%m-%d') date,
          confirmed - LAG(confirmed, 1) OVER (
            PARTITION BY name
            ORDER BY
              whn
          ) new_cases
        FROM
          covid
      ) temp
    WHERE
      new_cases >= 1000
    ORDER BY
      date,
      new_cases
  ) temp2
WHERE
  rank = 1;