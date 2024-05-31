***********************************************************

/*** 0. Identificacion

Titulo: Tarea 2 Diseño y Analisis de Investigacion Social 
Institucion: Instituto de Sociologia UC
Tema: Análisis de datos
Autor: Andreas Laffert     
Fecha: 19-05-2024 

***/

**************************************************************

clear all

cd "/Users/macbookair/Documents/Magister UC/1° Semestre 2024/Diseño y Análisis de Investigación Social/tarea2/"

capture log close 						
log using respaldo, replace  
dir	

/*** 1. Cargar datos ***/
									
use "output/db_proc.dta", clear

count // contar casos

/*** 2. Descriptivos ***/

describe

codebook, compact // forma compacta

sum

tabstat psci ess educyrs, stats (mean median sd variance min max n skew kurt) // para variables continuas

tab sexo
tab sindicato
tab ideologia

* encode la variable ideologia
encode ideologia, generate(ideologia_rec)
tab ideologia_rec

/*** 3. Analisis ***/

// Regresion lineal bivariada //

regress psci ess, beta

listcoef

correlate psci ess

dis 0.0839^2

predict predm0_psci
list in 1/6

predict residuom0, residuals 
list in 1/6

margins, at(ess=(1/10))

quietly regress psci ess, beta
outreg2 using output/modelos_tarea2.xls, replace ctitle(Model 0) alpha(0.001, 0.01, 0.05)

// Regresion lineal multiple //

regress psci ess sindicato, beta

listcoef

predict predm1_psci
list in 1/6

predict residuom1, residuals 
list in 1/6

margins, at(sindicato)

quietly regress psci ess sindicato, beta
outreg2 using output/modelos_tarea2.xls, append ctitle(Model 1) alpha(0.001, 0.01, 0.05)

// Regresion lineal multiple + controles //

regress psci ess sindicato educyrs sexo ib2.ideologia_rec, beta

listcoef

predict predm2_psci
list in 1/6

predict residuom2, residuals 
list in 1/6

quietly regress psci ess sindicato educyrs sexo ib2.ideologia_rec, beta
outreg2 using output/modelos_tarea2.xls, append ctitle(Model 2) alpha(0.001, 0.01, 0.05)

ttest ess, by(sexo) 

test _b[ess]=0

*------------------------------------------------------------------------------- 
* Cerrar sesión y guardar nuestros resultados 
*-------------------------------------------------------------------------------	
* Cerramos el Log File
log close
