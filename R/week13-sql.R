###Script Setting and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(RMariaDB)
library(keyring)


###Data Import and Cleaning
conn <- dbConnect(MariaDB(),
                  user= "nickl103",
                  password = key_get("latis-mysql", "nickl103"),
                  host= "mysql-prod5.oit.umn.edu",
                  port=3306,
                  ssl.ca= '../mysql_hotel_umn_20220728_interm.cer') #using code from slides to connect to sql

dbExecute(conn, "USE cla_tntlab;") #specifying what schema to look into for tables

###Analysis

#Total number of managers
total_managers <- "SELECT COUNT(*) AS total_managers
                  FROM datascience_employees 
                  INNER JOIN datascience_testscores ON datascience_employees.employee_id = datascience_testscores.employee_id;"
#SELECT COUNT gives a count for the number 
#FROM datascience_employees pulls from the employees table
#Inner join joins the employees table with the testscores table, only keeping rows that have matching ones from the testscores table
dbGetQuery(conn, total_managers) #pulling the number
#549 managers

#Total number of unique managers
total_unique_managers <- "SELECT COUNT(DISTINCT datascience_employees.employee_id) AS total_unique_managers
                  FROM datascience_employees 
                  INNER JOIN datascience_testscores ON datascience_employees.employee_id = datascience_testscores.employee_id;"

#did COUNT distinct for employee_id column to get the unique managers 
dbGetQuery(conn, total_unique_managers)

#Display a summary of the numbers of managers split by location but only include those who were not originally hired 
summary_by_location <- "SELECT COUNT(datascience_employees.employee_id) AS number_of_managers, datascience_employees.city AS location
                    FROM datascience_employees
                     INNER JOIN datascience_testscores ON datascience_employees.employee_id = datascience_testscores.employee_id
                    WHERE manager_hire = 'N'
                    GROUP BY city;"

dbGetQuery(conn, summary_by_location)
#Display the mean and sd of number of years of employment split by performance


#Display each manager's location classification, ID, number, and test score, in alphabetical order by location type and then dec order of test score 