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
)
#importing offices data into tibble 


###Visualization 
###Analysis
###Publication