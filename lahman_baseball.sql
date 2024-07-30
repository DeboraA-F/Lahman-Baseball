--1. What range of years for baseball games played does the provided database cover?
SELECT MIN(yearid),
	   MAX(yearid),
	   MAX(yearid)-MIN(yearid) AS range_years
FROM teams;

--2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
SELECT DISTINCT namelast, height, g_all, name
FROM people
INNER JOIN appearances USING(playerid)
	INNER JOIN teams USING(teamid)
WHERE height IN(SELECT
	            	MIN(height)
             	FROM people);	

--4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
SELECT position,
	   SUM(po) AS putout_sum
FROM	
	(SELECT playerid,
	   teamid,
	   po,
	CASE WHEN pos='OF' THEN 'Outfield'
		 WHEN pos='SS' OR pos='1B' OR pos='2B' OR pos='3B' THEN 'Infield'
		 WHEN pos='P' OR pos='C' THEN 'Battery'
	END AS position
    FROM fielding
    WHERE yearid=2016 AND po>0)
GROUP BY position;

--9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.
WITH winners AS(
				(SELECT playerid
				 FROM awardsmanagers
				 WHERE awardid ILIKE 'tsn%' AND lgid='AL'
				 GROUP BY playerid)
					INTERSECT
				 (SELECT playerid
				 FROM awardsmanagers
				 WHERE awardid ILIKE 'tsn%' AND lgid='NL'
				 GROUP BY playerid)
				)
SELECT DISTINCT namefirst ||' '|| namelast AS name
FROM people
	INNER JOIN winners USING(playerid)
	;


WITH winners AS (
	(SELECT DISTINCT managers.playerid, awardsmanagers.awardid, awardsmanagers.lgid, managers.teamid
     FROM managers
	 CROSS JOIN awardsmanagers
	 WHERE managers.playerid LIKE'leylaji99' OR managers.playerid LIKE'johnsda02')
				)
SELECT DISTINCT namefirst ||' '|| namelast AS name, awardid, lgid, teamid
FROM
	(SELECT playerid, awardid, lgid, teamid
	FROM winners
	WHERE lgid <> 'ML') 
LEFT JOIN people USING(playerid)
WHERE awardid ILIKE'tsn%';

--12. In this question, you will explore the connection between number of wins and attendance.
    --<ol type="a">
    --<li>Does there appear to be any correlation between attendance at home games and number of wins? </li>
    --<li>Do teams that win the world series see a boost in attendance the following year? What about teams that made the playoffs? Making the playoffs means either being a division winner or a wild card winner.</li>
   --</ol>
		
SELECT DISTINCT name, ghome, w, attendance, yearid, wswin
FROM teams AS t
WHERE ghome IS NOT NULL
ORDER BY yearid ; 

SELECT DISTINCT name, round, ghome, w, attendance, t.yearid, wswin
FROM teams AS t
	LEFT JOIN seriespost as s 
		ON t.yearid = s.yearid AND t.teamid = s.teamidwinner
WHERE round IS NOT NULL
ORDER BY yearid  ;
		
SELECT *
FROM seriespost;



