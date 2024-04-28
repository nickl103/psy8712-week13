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
#SELECT count to count number of employees labeled as number_of_managers, city labeled as location to show cities
#FROM datascience_employees to get data from that table
#Innerjoin to only include those with testscores
#WHERE manager_hire = N to only include those not hired as managers
#GROUP BY city to split by location
dbGetQuery(conn, summary_by_location)


#Display the mean and sd of number of years of employment split by performance

mean_sd_by_performance <- "SELECT AVG(datascience_employees.yrs_employed) AS mean_yrs_employed, STDDEV(datascience_employees.yrs_employed) AS sd_yrs_employed, performance_group AS performance_group
                          FROM datascience_employees
                          INNER JOIN datascience_testscores ON datascience_employees.employee_id = datascience_testscores.employee_id
                          GROUP BY performance_group;"
#SELECT AVG gives the average of years employed labelled as mean_yrs_employed
#STDDEV gives the sd of years employed labelled as sd_yrs_employed
#Displays performance group labeled as performance group
#FROM datascience_employees to take from that table
#Innerjoin to only use employees with testscores
#group ny performance group per instructions

dbGetQuery(conn, mean_sd_by_performance)


#Display each manager's location classification, ID, number, and test score, in alphabetical order by location type and then dec order of test score 
query1 <- "SELECT datascience_employees.employee_id AS employee_id, datascience_testscores.test_score AS test_score, datascience_offices.type AS type
            FROM datascience_employees
            INNER JOIN datascience_testscores ON datascience_employees.employee_id = datascience_testscores.employee_id
            INNER JOIN datascience_offices ON datascience_employees.city = datascience_offices.office
            ORDER by datascience_offices.office, datascience_testscores.test_score DESC;"

dbGetQuery(conn, query1)
            