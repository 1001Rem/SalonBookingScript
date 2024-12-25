#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


MAIN_MENU(){
  #display message if passed to the function
  if [[ $1 ]]
  then
  echo -e "\n$1"
  fi

  #get services

  SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

  #display services menu

  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
  echo "$SERVICE_ID) $NAME"
  done

#ask for service to aquire
echo -e "\nWhich service would you like?"

read SERVICE_ID_SELECTED

#if input is not a number 
if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then

#send to main menu

MAIN_MENU "That is not a valid service number."
else

echo -e "\nPlease Enter Customer Phone Number:"
read CUSTOMER_PHONE

FOUND_CUSTOMER=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")

if [[ -z $FOUND_CUSTOMER ]]
then

#get name + phone + service ID + TIME
echo -e "\nNo Appointments Found Under this number, Please enter your name:"
read CUSTOMER_NAME

echo -e "\nEnter Desired Appointment Time:"
read SERVICE_TIME
#insert data into customers table and appointments table.

echo "$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")"

#get customer ID

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

#insert into appointments

echo "$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")"

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

fi

fi

}
MAIN_MENU