
######### Denotes changes made to table
-- ----- Denotes table queries

Use Portfolio_schema;

-- Our goal is to create a table of stats for each distinct game using raw data from the 2019 and 2020 NFL seasons
-- This table will be visualized in Tableu to show season stats for each team

Select distinct(game_id), team, team_abbrev, home_team, home_score, vis_team, vis_score, Win_Loss
From nfl_data;

ALTER Table nfl_data
Drop Column Win_Loss;

##############################################################################################
-- Add Win_Loss Column to denote whether team won, lost or tied the game
ALTER TABLE nfl_data
Add Win_Loss VARCHAR(255);

SET SQL_SAFE_UPDATES = 0;

UPDATE nfl_data
SET Win_Loss = 
Case When team = home_team and home_score > vis_score THEN 'Win'
	 When team = home_team and home_score < vis_score THEN 'Loss'
	 When team = vis_team and vis_score > home_score THEN 'Win'
     When team = vis_team and vis_score < home_score THEN 'Loss'
	 Else 'Tie'
	 End;
     
SET SQL_SAFE_UPDATES = 1;

##############################################################################################
-- Add Team_Score Column to display the score of the team for each game
ALTER TABLE nfl_data
Add Team_Score VARCHAR(255);

SET SQL_SAFE_UPDATES = 0;

UPDATE nfl_data
SET Team_Score = 
Case When team = home_team Then home_score
	 When team = vis_team Then vis_score
	 Else null
	 End;

SET SQL_SAFE_UPDATES = 1;

-- --------------------------------------------------------
-- Create table of game data to visualize in Tableu

Select game_id, team, sum(pass_yds) as 'Total_Pass_Yards', sum(pass_td) as 'Total_Pass_TD', sum(rush_yds) as 'Total_Rush_Yards', sum(rush_td) as 'Total_Rush_TD', Team_Score, Win_Loss, game_date, Season_Year
from nfl_data
group by 1,2,7,8,9,10;

