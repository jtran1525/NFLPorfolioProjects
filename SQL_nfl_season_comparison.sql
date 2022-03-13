
######### Denotes changes made to table
-- ----- Denotes Table Queries

Use Portfolio_schema;

-- Our goal is to compare raw nfl data from the 2019 and 2020 seasons
-- 2020 Season was played without fans due to the COVID-19 Virus

-- Rename Table
-- ALTER TABLE `Portfolio_schema`.`data - nfl_pass_rush_receive_raw_data` 
-- RENAME TO  `Portfolio_schema`.`nfl_data` ;



Select *
From nfl_data;

############################################################################################################
-- 2019 Season Ends 01-19-2020
-- Add column 'Season_Year' to show which games were played in what Season

ALTER TABLE nfl_data
ADD Season_Year VARCHAR(255);

SET SQL_SAFE_UPDATES = 0;

UPDATE nfl_data
SET Season_Year =
CASE When game_date <= '2020-01-19' THEN '2019'
	 When game_date > '2020-01-19' THEN '2020'
     Else game_date
     End;
     
SET SQL_SAFE_UPDATES = 1;

############################################################################################################
-- Remove Playoff Games from data so we can see only regular season stats

-- 2019 Season Playoff games start 2020-01-04 and end 2020-02-02
SET SQL_SAFE_UPDATES = 0;

DELETE FROM nfl_data
Where game_date >= '2020-01-04' and game_date <= '2020-02-02';

SET SQL_SAFE_UPDATES = 1;

-- 2020 Season Playoff Games start 2021-01-09 and end 2021-02-07
SET SQL_SAFE_UPDATES = 0;

DELETE FROM nfl_data
Where game_date >= '2021-01-09' and game_date <= '2021-02-07';

SET SQL_SAFE_UPDATES = 1;

-- -------------------------------------------------------------------------------------------------------------
-- Check to make sure each season has the same number of games played

SELECT Count(distinct game_id) as '# of Games', Season_Year
FROM nfl_data
GROUP BY Season_Year;

-- -------------------------------------------------------------------------------------------------------------
-- Display total amount of pass completions Quarterbacks had each season
SELECT Sum(pass_cmp) as 'Total_Pass_Cmp', Season_Year
FROM nfl_data
WHERE pos = 'QB'
GROUP BY Season_Year;

-- -------------------------------------------------------------------------------------------------------------
-- Display total amount of pass yards Quarterbacks had each season
SELECT Sum(pass_yds) as 'Total_QB_Pass_Yds', Season_Year
FROM nfl_data
WHERE pos = 'QB'
GROUP BY Season_Year;

-- -------------------------------------------------------------------------------------------------------------
-- Display total amount of pass attempts and rush attempts for all players each season
SELECT Sum(pass_att) as 'Total_Pass_Att', Sum(rush_att) as 'Total_Rush_Att', Season_Year
FROM nfl_data
GROUP BY Season_Year;

-- -------------------------------------------------------------------------------------------------------------
-- Display average amount of rush yards by Running Backs based on field Surface
SELECT Sum(rush_yds) as 'Total_RB_Rush_Yds', Count(distinct game_id) as '# of Games', (Sum(rush_yds)/Count(distinct game_id)) as 'Avg_Yds_Game', Surface
FROM nfl_data
Where pos = 'RB'
Group By Surface
Order By (Sum(rush_yds)/Count(distinct game_id)) desc ;

-- --------------------------------------------------------------------------------------------------------------
-- Do months (weather) effect average pass yards and rush yards?
-- Display average amount of pass yards and rush yards and pass yards for all players each game and date (We want to visualize average yardage thorught each month)
Select Sum(pass_yds) as 'Total_Pass_Yds', Sum(rush_yds) as 'Total_RB_Rush_Yds', Count(distinct game_id) as '# of Games', 
(Sum(pass_yds)/Count(distinct game_id)) as 'Avg_Pass_Yds', (Sum(rush_yds)/Count(distinct game_id)) as 'Avg_Rush_Yds', Monthname(game_date) as 'Month'
From nfl_data
Group by Monthname(game_date)
Order by (Sum(pass_yds)/Count(distinct game_id)) desc;

-- --------------------------------------------------------------------------------------------------------------
-- Which players had the highest average passer rating with at least 500 pass attempts in 2019 and in 2020
SELECT player, AVG(pass_rating)
FROM nfl_data
WHERE Season_Year = '2019'
GROUP BY player
HAVING SUM(pass_att) > 500
ORDER BY 2 desc;

SELECT player, AVG(pass_rating)
FROM nfl_data
WHERE Season_Year = '2020'
GROUP BY player
HAVING SUM(pass_att) > 500
ORDER BY 2 desc;












