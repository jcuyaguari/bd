#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~~~~ Salon Appointment Scheduler ~~~~~\n"

# Function to show services
show_services() {
  echo -e "\nHere are the available services:"
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE_NAME; do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done
}

# Function to schedule an appointment
schedule_appointment() {
  # Ask for the service
  show_services
  echo -e "\nPlease select a service by entering the service ID:"
  read SERVICE_ID_SELECTED

  # Validate service ID
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]]; then
    echo -e "\nInvalid service selected. Please try again."
    schedule_appointment
  else
    # Get customer info
    echo -e "\nEnter your phone number:"
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]; then
      # New customer, ask for name
      echo -e "\nIt looks like you're new. What's your name?"
      read CUSTOMER_NAME
      # Insert new customer into customers table
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi

    # Get customer_id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    # Ask for appointment time
    echo -e "\nAt what time would you like your $SERVICE_NAME appointment?"
    read SERVICE_TIME

    # Insert appointment into appointments table
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

    # Confirm appointment
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

# Start the scheduling process
schedule_appointment
