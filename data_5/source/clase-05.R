# author: Eduard F. Martínez-González
# update: 11-11-2021
# R version 4.1.1 (2021-08-10)

# initial configuration
rm(list=ls()) # limpiar entorno
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8

# install/load packages
require(pacman)
p_load(janitor,rio,skimr,png,grid)

# verifiquemos directorio
getwd()
list.files(".")

#=================#
# 1. Introducción #
#=================#

#------------------------------#
## Raw data y tidy data
cat("Tidy datasets are all alike, but every messy dataset is messy in its own way. -Hadley Wickham")
dev.off()
grid.raster(readPNG("pics/raw_tidy.png"))


#------------------------------#
## Reglas de un conjunto de datos tidy
dev.off()
grid.raster(readPNG("pics/tidy_rules.png"))


#------------------------------#
## tidyverse
dev.off()
grid.raster(readPNG("pics/tidy_monster.png"))
browseURL("https://github.com/allisonhorst/stats-illustrations") # source


#------------------------------#
## tidyverse (cont.)
cat("Antes de continuar, debe instalar y llamar la librería `tidyverse` así:")
install.packages("tidyverse")
library(tidyverse)
cat("Para ver los conflictos entre nombres de funciones en `tidyverse` con nombre de 
    funciones en otras librerías, puede escribir sobre la consola `tidyverse_conflicts()`")


#------------------------------#
## Cheat sheet
dev.off()
grid.raster(readPNG("pics/cheat_sheet_dplyr.png"))

# cheat shets para packages de tyfiverse
browseURL("https://www.rstudio.com/resources/cheatsheets/")
vignette("dplyr")
vignette("tibble")

#============================#
# Remover filas y/o columnas #
#============================#
rm(list=ls())

cat("`select()` selecciona columnas de un dataframe o un tibble,
    usando el nombre o la posición de la variable en el conjunto de datos:")


#------------------------------#
## Seleccionar variables
db = tibble(iris) %>% mutate(Species=as.character(Species))

db


#------------------------------#
## Seleccionar variables (cont.)
db %>% select(c(1,3,5))

df = db %>% select(Petal.Length , Petal.Width , Species)


#------------------------------#
## Seleccionar variables usando partes del nombre)

#### variables que comienzan con sepal
db %>% select(starts_with("Sepal"),Species)
db %>% select(ends_with("Length"),Species) # finalizan

#### variables que terminan con width
db %>% select(contains("Width")) 


#------------------------------#
## Seleccionar variables usando el tipo

#### Variables character
db %>% select_if(is.character)

####variables numericas
db %>% select_if(is.numeric) 


#------------------------------#
## Cambiar títulos de las variables 
cat("Usando select all se cambia los nombres a minuscula")
db %>% select_all(tolower) 


#------------------------------#
## Seleccionar variables usando un vector
cat("Tambien se puede selecionar las variables con un vector")

vars = c("Species","Sepal.Length","Petal.Width")
db %>% select(all_of(vars))

nums = c(5,2,3)
db %>% select(all_of(nums)) 

# drop vars
nums = c(1,3)
db %>% select(-all_of(nums)) 


#------------------------------#
## Remover filas/observaciones (cont.)
cat("Los condicionales permiten expresar un argumento logico, se pueden utilizar para manipular data")
dev.off()
grid.raster(readPNG("pics/operadores_logicos.png"))

#### importar datos
db = read.csv("https://nyc-tlc.s3.amazonaws.com/trip+data/green_tripdata_2020-12.csv") %>%    
  select(passenger_count:payment_type) %>% tibble()

#### Informacion extra de los datos
browseURL("https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page") # source
browseURL("https://www1.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf") # data dictionaries 

#### Variables escogidas
# trip_distance  : The elapsed trip distance in miles reported by the taximeter
# total_amount   : The total amount charged to passengers. Does not include cash tips.
# payment_type   : 1= Credit card 2= Cash 3= No charge 4= Dispute 5= Unknown 6= Voided trip
# passenger_count: The number of passengers in the vehicle.
# trip_type      : 1= Street-hail 2= Dispatch


#------------------------------#
## Remover filas usando condicionales
cat("La función `subset()` pertenece a una de las librerías base de `R` y
    permite seleccionar todas las filas/observaciones de un conjunto de datos que cumplen una o más condiciones lógicas:")
subset(x = db , trip_distance > 5)  # Distancia del viaje mayor a 5 millas
db %>% subset(trip_distance > 5)  # Distancia del viaje mayor a 5 millas


cat("usando la funcion `filter()` de la librería `dplyr`")
db %>% filter(passenger_count > 3) # Más de 3 pasajeros

#------------------------------#
## Remover valores faltantes
is.na(db$passenger_count) %>% tabyl() # número de observaciones faltantes
skim(db) # describir datos

cat(" filas con valores faltantes en la variable `passenger_count`")
db = db %>% drop_na(passenger_count)

is.na(db$passenger_count) %>% tabyl() # número de observaciones faltantes


