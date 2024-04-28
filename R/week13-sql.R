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
totalmanagers <- "SELECT COUNT(*) 
                  FROM datascience_employees 
                  INNER JOIN datascience_testscores ON datascience_employees.employee_id = datascience_testscores.employee_id;"
#SELECT COUNT gives a count for the number 
#FROM datascience_employees pulls from the employees table
#Inner join joins the employees table with the testscores table, only keeping rows that have matching ones from the testscores table
dbGetQuery(conn, totalmanagers) #pulling the number
#549 managers

#Total number of unique managers


#Display a summary of the numbers of managers split by location but only include those who were not originally hired 

#Display the mean and sd of number of years of employment split by performance


#Display each manager's location classification, ID, number, and test score, in alphabetical order by location type and then dec order of test score 