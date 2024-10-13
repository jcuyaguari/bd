#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

USER_INFO=$($PSQL "SELECT user_id, games_played, best_game FROM users WHERE username='$USERNAME'")

if [[ -n $USER_INFO ]]; then
  echo "$USER_INFO" | while IFS="|" read USER_ID GAMES_PLAYED BEST_GAME; do
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
else
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  # Inserta el usuario en la base de datos
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
fi

SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
echo "Guess the secret number between 1 and 1000:"

NUMBER_OF_GUESSES=0

while true; do
  read GUESS

  if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
  else
    NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))

    if [[ $GUESS -eq $SECRET_NUMBER ]]; then
      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
      break
    elif [[ $GUESS -lt $SECRET_NUMBER ]]; then
      echo "It's higher than that, guess again:"
    else
      echo "It's lower than that, guess again:"
    fi
  fi
done

if [[ -n $USER_INFO ]]; then
  UPDATE_USER_RESULT=$($PSQL "UPDATE users SET games_played=games_played+1 WHERE username='$USERNAME'")

  if [[ $NUMBER_OF_GUESSES -lt $BEST_GAME ]] || [[ -z $BEST_GAME ]]; then
    UPDATE_BEST_GAME=$($PSQL "UPDATE users SET best_game=$NUMBER_OF_GUESSES WHERE username='$USERNAME'")
  fi
else
  UPDATE_USER_RESULT=$($PSQL "UPDATE users SET games_played=1, best_game=$NUMBER_OF_GUESSES WHERE username='$USERNAME'")
fi
