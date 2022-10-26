#!/bin/bash

INPUT=9

until [ $INPUT = 3 ]
do 
    echo ""
    echo "Welcome to Jackie's Login Program"
    echo 1. Sign in
    echo 2. Sign up
    echo 3. Exit
    read -p "Please choose your option: " INPUT
    
    SALT="sfjxctevtkshkisdc"
    LOG="logfile.txt"

    case $INPUT in 
    #Signing in 
    1 ) 
        echo "------> Signing in <--------"
        read -p "Enter Username: " USER  #
        grep -q -w -i $USER Credentials.csv || { echo ERROR: User $USER not found. Please sign up.; continue; }
        read -s -p "Enter Password: " PASS ; echo ""
        PASS_HASH=$(echo "$PASS$SALT"| sha256sum )  
        grep -i -q "$USER,$PASS_HASH" Credentials.csv || { echo ERROR: Password incorrect.; continue; }
        echo Logged on successfully. Welcome $USER.
        echo [LOG ON] $USER logged on successfully on $(date) >> $LOG
        echo What would you like to do?
        echo "1. Sign out"
        read -p "Please choose your option: " INPUT2
        if [ $INPUT2 -eq 1 ]
        then
            echo Logging off.
            echo [LOG OFF] $USER logged off at $(date) >> $LOG
        else
            echo "Command isn't available yet"
        fi
        ;;

    # Signing UP    
    2 )
        echo "------> Signing up <--------"
        read -p "Enter Username: " USER  ##
        USER_FOUND=$(grep -c -w -i $USER Credentials.csv)
        if [ $USER_FOUND -eq 0 ]
        then
            read -s -p "Enter Password: " PASS ; echo ""
            PASS_HASH=$(echo "$PASS$SALT"| sha256sum )
            #add entry to credentials
            echo "$USER,$PASS_HASH" >> Credentials.csv || { echo ERROR: Adding user failed. Try again.; continue; }
            echo USER $USER successfully created. Sign in.
            echo [NEW USER] User $USER successfully created on $(date) >> $LOG

        else
            echo User $USER already exists. Sign in.
        fi
        ;;
    3 )
        echo Exiting Program
        exit 0
        ;;
    * ) 
        echo "ERROR: Invalid Command "
        ;;
    esac
done