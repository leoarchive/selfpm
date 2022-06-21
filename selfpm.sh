#!/usr/bin/env bash

if [ $1 = "-help" ]
then
  printf "
  \tselfpm <repository_name> \t# get package\n \
  \tselfpm <repository_name> -url <url> \t# pass a custom hosting url\n \
  "
  exit 0
fi

HOSTING_URL="https://github.com/leozamboni/"
if [ ! -z "$2" ] && [ $2 = "-url" ]
then
  HOSTING_URL=$3
  echo 'a'
fi

GIT=$(which git)
if [ $? != 0 ]
  then
    echo "GIT NOT FOUND."
    exit 1
fi

WGET=$(which wget)
if [ $? != 0 ]
  then
    echo "WGET NOT FOUND."
    exit 1
fi

if [ -z "$HOSTING_URL" ] 
  then
    echo "NO HOSTING URL SUPPLIED."
    exit 1
fi 

$WGET -q --method=HEAD $HOSTING_URL

if [ $? != 0 ]
  then
    echo "THIS HOSTING URL DOES NOT EXIST."
    exit 1
fi

if [ -z "$1" ]
then
  echo "NO REPOSITORY SUPPLIED."
  exit 1
fi
REPOSITORY=$1

if [ "${HOSTING_URL: -1}" != '/' ]
then
  HOSTING_URL="$HOSTING_URL/"
fi
REPOSITORY_URL="$HOSTING_URL$REPOSITORY"

$WGET -q --method=HEAD $REPOSITORY_URL

if [ $? != 0 ]
then
  echo "THIS REPOSITORY DOES NOT EXIST."
  exit 1
fi

$GIT clone $REPOSITORY_URL