#!/bin/bash 

# nginx_log_analyzer.sh
#
# A simple shell tool to analyze an nginx access log file.
# Reports:
#   1. Top 5 IP addresses with the most requests
#   2. Top 5 most requested paths
#   3. Top 5 response status codes
#   4. Top 5 user agents

# TAKE THE LOG FILE AS AN INPUT 

if [ $# -ne 1 ]; then  
     echo "Usage: $0 <log-file>"	
     exit 1 
fi 

LOG_FILE="$1"

if [ ! -f "$LOG_FILE" ]; then 
	echo "ERROR: File '$LOG_FILE' not found."
	exit 1 
fi

## Command to print the top 5 IP 

echo "Top 5 IP addresses with the most requests :"
echo ""
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests "}'

echo ""

## Command to print the top 5 requested path 


echo "Top 5 most requested paths :"
echo ""
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests "}'

echo ""

## Command to print the top 5 response status code 

echo "Top 5 response status codes : "
echo ""
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " $1 " requests "}'
echo ""

## Command to print the top 5 user agents 

echo "Top 5 user agents : "
echo ""
awk -F '"' '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5 | awk '{print $2 " - " 1 " requests "}'
echo ""
