#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ELEMENT=$1

ELEMENT_DESCRIPTION() {
  
  # if argument doesn't exist 
  if [[ -z $ELEMENT ]]
  then 
    echo "Please provide an element as an argument."
  else
    # if argument is number
    if [[ $ELEMENT =~ ^[0-9]+$ ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ELEMENT")
    # if argument is string
    else 
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ELEMENT' OR name='$ELEMENT'")
    fi

    # if element doesn't exist
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
    else
    #display element details
      ELEMENT_DETAILS=$($PSQL "SELECT symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER") 
      echo $ELEMENT_DETAILS | while IFS=\| read SYMBOL NAME ATOMIC_MASS MELTING BOILING TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    fi
  fi
}

ELEMENT_DESCRIPTION
