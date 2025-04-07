#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# check if an argument is provided
if [[ $1 ]]
then

  # if an argument is provided check if it is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then

    # if the argument is a number, check if it is a valid atomic number
    CHECK_ATOMIC_NUMBER=$($PSQL "SELECT * FROM elements WHERE atomic_number = $1")
    if [[ -z $CHECK_ATOMIC_NUMBER ]]
    then

      # if invalid atomic number
      echo "I could not find that element in the database."
    else

      # if valid atomic number, search for properties related to that atomic number
      ATOMIC_NUMBER_PROPERTIES=$($PSQL "SELECT * FROM types FULL JOIN properties USING(type_id) FULL JOIN elements USING(atomic_number) WHERE atomic_number = $1")

      # parse query result
      echo "$ATOMIC_NUMBER_PROPERTIES" | while IFS=\| read ATOMIC_NUMBER TYPE_ID TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS SYMBOL NAME
      do
        # output data
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done

    fi
  else

  # if the argument is not a number check if argument is symbol
    CHECK_SYMBOL=$($PSQL "SELECT * FROM elements WHERE symbol = '$1'")
    if [[ -z $CHECK_SYMBOL ]]
    then

      # if argument is not a symbol check if argument is name
      CHECK_NAME=$($PSQL "SELECT * FROM elements WHERE name = '$1'")
      if [[ -z $CHECK_NAME ]]
      then

        # if argument is not a symbol nor a name
        echo "I could not find that element in the database."
      else
        # if argument is a name, search it's atomic number
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements  WHERE name = '$1'")

        # search for properties related to that atomic number
        ATOMIC_NUMBER_PROPERTIES=$($PSQL "SELECT * FROM types FULL JOIN properties USING(type_id) FULL JOIN elements USING(atomic_number) WHERE atomic_number = $ATOMIC_NUMBER")

        # parse query result 
        echo "$ATOMIC_NUMBER_PROPERTIES" | while IFS=\| read ATOMIC_NUMBER TYPE_ID TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS SYMBOL NAME
        do
          # output data
          echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
        done
      fi
    else
      # if argument is a symbol, search it's atomic number
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements  WHERE symbol = '$1'")

      # search for properties related to that atomic number
      ATOMIC_NUMBER_PROPERTIES=$($PSQL "SELECT * FROM types FULL JOIN properties USING(type_id) FULL JOIN elements USING(atomic_number) WHERE atomic_number = $ATOMIC_NUMBER")

      # parse query result 
      echo "$ATOMIC_NUMBER_PROPERTIES" | while IFS=\| read ATOMIC_NUMBER TYPE_ID TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS SYMBOL NAME
      do
        # output data
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    fi
  fi

else
  # if no argument is provided
  echo "Please provide an element as an argument."
fi