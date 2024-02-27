#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


#函数
BY_NAME(){
  AN=$($PSQL "select atomic_number from elements where name='$1';")
   if [[ -z $AN ]]
  then
  echo "I could not find that element in the database."
  else
  SYMBOL=$($PSQL "select symbol from elements where name='$1';")
  TYPE=$($PSQL "select type from types where type_id=(select type_id from properties where atomic_number=$AN);")
  MASS=$($PSQL "SELECT TRIM(TRAILING '0' FROM CAST(atomic_mass AS text)) FROM properties WHERE atomic_number=$AN;")
  ML=$($PSQL "select melting_point_celsius from properties where atomic_number=$AN;")
  BL=$($PSQL "select boiling_point_celsius from properties where atomic_number=$AN;")
  OUTPUT="The element with atomic number $AN is $1 ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $1 has a melting point of $ML celsius and a boiling point of $BL celsius."
  echo $OUTPUT
  fi
}
BY_SYMBOL(){
  AN=$($PSQL "select atomic_number from elements where symbol='$1';")
  if [[ -z $AN ]]
  then
  echo "I could not find that element in the database."
  else
  NAME=$($PSQL "select name from elements where symbol='$1';")
  TYPE=$($PSQL "select type from types where type_id=(select type_id from properties where atomic_number=$AN);")
  MASS=$($PSQL "SELECT TRIM(TRAILING '0' FROM CAST(atomic_mass AS text)) FROM properties WHERE atomic_number=$AN;")
  ML=$($PSQL "select melting_point_celsius from properties where atomic_number=$AN;")
  BL=$($PSQL "select boiling_point_celsius from properties where atomic_number=$AN;")
  OUTPUT="The element with atomic number $AN is $NAME ($1). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $ML celsius and a boiling point of $BL celsius."
  echo $OUTPUT
  fi
}


BY_ATOMIC_NUMBER(){
  AN=$($PSQL "select atomic_number from elements where atomic_number='$1';")
   if [[ -z $AN ]]
  then
  echo "I could not find that element in the database."
  else
  NAME=$($PSQL "select name from elements where atomic_number=$1;")
  SYMBOL=$($PSQL "select symbol from elements where atomic_number=$1;")
  TYPE=$($PSQL "select type from types where type_id=(select type_id from properties where atomic_number=$AN);")
  MASS=$($PSQL "SELECT TRIM(TRAILING '0' FROM CAST(atomic_mass AS text)) FROM properties WHERE atomic_number=$AN;")
  ML=$($PSQL "select melting_point_celsius from properties where atomic_number=$AN;")
  BL=$($PSQL "select boiling_point_celsius from properties where atomic_number=$AN;")
  OUTPUT="The element with atomic number $AN is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $ML celsius and a boiling point of $BL celsius."
  echo $OUTPUT
  fi
}



# 检查是否提供了元素参数  
if [ "$#" -ne 1 ]; then  
  echo "Please provide an element as an argument."  
  exit 0  
fi  
  
ELEMENT=$1  
  
# 根据输入参数的类型（数字或字符串）决定调用哪个函数  
if [[ $ELEMENT =~ ^[0-9]+$ ]]; then  
  BY_ATOMIC_NUMBER $ELEMENT  
elif [[ ${#ELEMENT} -le 2 ]]; then  
  BY_SYMBOL $ELEMENT  
else  
  BY_NAME $ELEMENT  
fi