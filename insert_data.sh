#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#Check if winner or opponent is in teams 
if [[ $WINNER != 'winner' ]] 
  then 
    TEAM1_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'") 
      if [[ -z $TEAM1_NAME ]]
        then 
          INSERT_TEAM1_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
            if [[ $INSERT_TEAM1_NAME == "INSERT 0 1" ]]
              then 
                echo Inserted team $WINNER
            fi 
      fi
fi 
if [[ $OPPONENT != 'opponent' ]] 
  then 
    TEAM2_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'") 
      if [[ -z $TEAM2_NAME ]]
        then 
          INSERT_TEAM2_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
            if [[ $INSERT_TEAM2_NAME == "INSERT 0 1" ]]
              then 
                echo Inserted team $OPPONENT
            fi 
      fi
fi 
if [[ $YEAR != "year" ]] 
  then 
    GET_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    GET_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $GET_WINNER_ID, $GET_OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
fi
done

