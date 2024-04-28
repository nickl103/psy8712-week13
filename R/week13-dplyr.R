###Script Setting and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
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

employees_tbl <- as_tibble(
  dbGetQuery(conn, "SELECT *
             FROM datascience_employees;")
) #importing employee data into tibble format

testscores_tbl <- as_tibble(
  dbGetQuery(conn, "SELECT *
            FROM datascience_testscores;")
) #importing testsocres data into tibble format

offices_tbl <- as_tibble(
  dbGetQuery(conn, "SELECT *
            FROM datascience_offices;")
)#importing offices data into tibble 

#writing csv files per assignment instructions
write_csv(employees_tbl, "../data/employees.csv")
write_csv(testscores_tbl, "../data/testscores.csv")
write_csv(offices_tbl, "../data/offices.csv")

week13_tbl <- employees_tbl %>% 
  inner_join(testscores_tbl, by= "employee_id") %>%
  #used inner join because it got rid of the employees without testscores which is checked by the original employees tbl having 571 but going down to 549 in the week13_tbl 
  full_join(offices_tbl, by= join_by("city" == "office"))
#used full join to add the offices information to the existing week 13 tbl

#writing csv for week13_tbl per assignment instructions
write_csv(week13_tbl, "../out/week13.csv")
  

###Visualization 
###Analysis
###Publication