#!/bin/bash

# Definir el comando PSQL
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Verificar si se ha pasado un argumento
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # Verificar si el argumento es un número atómico
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
  else
    # Si no es número atómico, verificar si es símbolo o nombre
    ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
  fi

  # Verificar si se encontró el elemento
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
    # Formatear y mostrar la salida
    echo $ELEMENT | while IFS=" | " read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING BOILING
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi
