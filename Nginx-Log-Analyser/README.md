# Nginx Log Analyser

A simple Bash script that analyzes an Nginx access log and displays the top 5 IP addresses, requested paths, HTTP response status codes, and user agents.

## Features

The script analyzes the Nginx log file and displays:

* Top 5 IP addresses with the most requests
* Top 5 most requested paths
* Top 5 HTTP response status codes
* Top 5 user agents

## Project Structure

```text
Nginx-Log-Analyser/
├── access.log
├── nginx-log-analyser.sh
└── README.md
```

## Requirements

* Linux / WSL
* Bash
* Standard Linux command-line utilities:

  * `awk`
  * `sort`
  * `uniq`
  * `head`
  * `grep`

## Usage

Make the script executable:

```bash
chmod +x nginx-log-analyser.sh
```

Run the analyser by providing the Nginx log file as an argument:

```bash
./nginx-log-analyser.sh nginx-access.log



## Project Source

This project was completed as part of my DevOps learning journey following the projects from [roadmap.sh](https://roadmap.sh/).

