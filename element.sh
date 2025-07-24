#!/bin/bash

echo -e "\nPlease provide an element as an argument."


if [[ -z $1 ]]
then
  echo -e "\nPlease provide an element as an argument."
else

  ELEMENT_INFO=""

  if  [[ "$1" =~ ^[0-9]+$ ]]
  then
    # NUMBER=$1
    ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, p.atomic_mass, t.type, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e JOIN properties AS p ON e.atomic_number = p.atomic_number JOIN types AS t ON p.type_id = t.type_id WHERE e.atomic_number = $1;")
  fi

  if [[ -z "$ELEMENT_INFO" && "$1" =~ ^[A-Z][a-z]?$ ]]
  then
    # LETTER=$1
    ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, p.atomic_mass, t.type, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e JOIN properties AS p ON e.atomic_number = p.atomic_number JOIN types AS t ON p.type_id = t.type_id WHERE e.symbol = '$1';")
  fi

  if [[ -z "$ELEMENT_INFO" ]]
  then
    # WORD=$1
    ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, p.atomic_mass, t.type, p.melting_point_celsius, p.boiling_point_celsius FROM elements AS e JOIN properties AS p ON e.atomic_number = p.atomic_number JOIN types AS t ON p.type_id = t.type_id WHERE e.name = '$1';")
  fi

  if [[ -z "$ELEMENT_INFO" ]]
  then
    echo "I could not find that element in the database."
  else
    IFS="|" read ATOMIC_NUMBER NAME SYMBOL ATOMIC_MASS TYPE MELTING_POINT BOILING_POINT <<< "$ELEMENT_INFO"
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi


  # echo $($PSQL "The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.")
  
fi
