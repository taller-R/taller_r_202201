# Elaborado por: Eduard Martinez
# Colaboradores: 
# Fecha de elaboracion: 31/08/2021
# Ultima modificacion: 31/08/2021
# Version de R: 4.1.0

# configuracion inicial 
rm(list = ls()) # limpia el entorno de R
require(pacman) # Llamar la librería pacman
p_load(rio,skimr,tidyverse) # Llamar y/o instalar las librerías de la clase
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8

# skimr:
# rio:
# tidyverse:

#------------------------------------------------------------------------------#
#-------------------- 1. importar & exportar base de datos --------------------#
#------------------------------------------------------------------------------#

#-------------------------#
#         1.2 rio         #
#-------------------------#

# Informacion extra
?rio

#------ 1.2.1 Import -----#
# Informacion extra
?rio::import

# Importar bases de datos en formato .csv
data_csv = import(file = "data_4/input/censo 2018.csv" , sep = "," , header = T, stringsAsFactors = F, skip = 6) 

# Importar bases de datos en formato .xls y .xlsx 
data_xls = import(file= "data_4/input/hurto-personas-2020_0.xlsx" , sheet = "Sheet1" , col_names = TRUE, skip = 9) 

# Importar bases de datos en formato .dta
data_dta = import(file = "data_4/input/Area - Caracteristicas generales (Personas).dta")

# Importar bases de datos en formato .rds
data_rds = import(file = "data_4/input/proyecciones DANE 2005-2020.rds") 

# Importar bases de datos en formato .Rdata
data_rdata = import(file = "data_4/input/Homicidios 2020.Rdata")


#---- 1.2.2 Import -------#
# Informacion extra
?rio::export

# exportar bases de datos en formato .csv
export(data_csv, "data_4/output/censo 2018.csv" ) 

# exportar bases de datos en formato .xls y .xlsx 
export(data_xls,"data_4/output/hurto-personas-2020_0.xlsx",overwrite = T)

# exportar bases de datos en formato .dta
export(data_dta,"data_4/output/Area - Caracteristicas generales (Personas).dta")

# exportar bases de datos en formato .rds
export(data_rds,"data_4/output/proyecciones DANE 2005-2020.rds") 

# exportar base de datos en formato .Rdata
export(data_rdata,"data_4/output/Homicidios 2020.Rdata")

 
#----- 1.2.3 convert -----#
# Informacion extra
?rio::convert

# Convertir a formato .csv
convert(in_file = "data_4/input/Homicidios 2020.Rdata" ,out_file = "data_4/output/Homicidios 2020_rio.csv")

# Convertir a formato .rds
convert("data_4/input/hurto-personas-2020_0.xlsx" ,"data_4/output/hurto-personas-2020_0.rds")

# Convertir a formato .dta
convert("data_4/input/proyecciones DANE 2005-2020.rds" ,"data_4/input/proyecciones DANE 2005-2020.dta")


#-------------------------#
#       1.3  skimr        #
#-------------------------#
# Informacion extra
?skimr::skim()

# 1.3.1 resumen del data -#
skim(data_csv)
skim(data_dta)
skim(data_rdata)
skim(data_rds)
skim(data_xls)


#------------------------------------------------------------------------------#
#------------------------- 2. operador pipe (%>%) -----------------------------#
#------------------------------------------------------------------------------#

# Informacion extra
browseURL("https://rsanchezs.gitbooks.io/rprogramming/content/chapter9/pipeline.html" , browser = getOption("browser"))
browseURL("https://rsanchezs.gitbooks.io/rprogramming/content/chapter9/dplyr.html" , browser = getOption("browser"))

#-------------------------#
#      2.1 sin pipe       #
#-------------------------#

# ejemplo 1
head(data_rds)
df = as_tibble(data_rds)
df = df[1:16,] # Selecionamos filas 1:5
df = df[,1:3] # Selecionamos columnas 1:3
df

# ejemplo 2
a = 1:15
a = as.character(a)
a = paste0("Número ", a)
a

#-------------------------#
#      2.2 con pipe       #
#-------------------------#

# ejemplo 1
df = as_tibble(mtcars) %>% .[1:5,] %>% .[,1:3]
df

# ejemplo 2
a = 1:15 %>% as.character(.) %>% paste0("Número ", .)
a

#------------------------------------------------------------------------------#
#--------------------------- 3. crear variables -------------------------------#
#------------------------------------------------------------------------------#

"Se puden adicionar y/o eliminar variables de dos maneras: usando $ (una función de la base de R)
 o usando mutate() de la librería dplyr."

#------------------------------#
## data$var

cat("Preparar la base de datos `mtcars`") 
library(help = "datasets")

df = as_tibble(mtcars) # convertir en tibble
df = df[,c(1,4,6,10)] # mantener solo las columnas 1,4,6 y 10


cat("Agregar una variable con la relación caballos de fuerza / peso del vehículo")
df$hp_vt = df$hp/df$wt # agregar nueva variable
df


#------------------------------#
## mutate()
cat("Generar una variable con la relación millas/galón sobre el número de caballos de fuerza:")

df = mutate(.data = df , mpg_hp = mpg/hp)
df


#------------------------------#
## Aplicar una condición

cat("Generar una variable para los vehículos pesados (wt>4) y otra para los vehículos con más de 3 velocidades")

# data$var
df$wt_4 = ifelse(test=df$wt>4 , yes=1 , no=0)

#mutate
df = mutate(.data=df , gear_4 = ifelse(test=gear>3 , yes=1 , no=0))

df


#------------------------------#
## Aplicar más de una condición
cat("Generar una variable de acuerdo al peso del vehículos: liviano (wt<3), estándar (wt>=3 & wt<=4) y pesado (wt>4).")

df = mutate(df , wt_chr = case_when(wt<3 ~ "liviano" ,
                                    wt>=3 & wt<=4 ~ "estándar" ,
                                    wt>4 ~ "pesado"))
df


#------------------------------#
## Aplicar una función a todas las variables
df = mutate_all(.tbl=df , .funs = as.character)
df

#------------------------------#
## Renombrar variables
colnames(df)
colnames(df)[5] = "hp_vt_chr"
colnames(df)

colnames(df) = toupper(colnames(df))

df = rename(.data = df , mpg_min=MPG)
df = rename(.data = df , hp_min=HP , wt_4_min=WT_4)
df = rename(.data = df , `mpg hp`=MPG_HP)


