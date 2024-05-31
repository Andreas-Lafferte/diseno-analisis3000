***********************************************************

/*** 0. Identificacion

Titulo: Tarea 1 Diseño y Analisis de Investigacion Social 
Institucion: Instituto de Sociologia UC
Tema: Análisis de datos
Autor: Andreas Laffert     
Fecha: 12-04-2024 

***/

**************************************************************

/*** 1. Cargar datos ***/

use "/Users/macbookair/Documents/Magister UC/1° Semestre 2024/Diseño y Análisis de Investigación Social/tarea1/output/db_proc.dta"

count // contar casos

/*** 2. Descriptivos ***/

describe

codebook, compact // forma compacta

sum

tabstat psci ess, stats (mean median sd variance min max n skew kurt) // para variables continuas

tab sexo
tab sindicato

// Variable dependiente: PSCi //

hist psci, width(1) normal

qnorm psci

a2 psci, dist(normal)  // test de normalidad de Anderson-Darling: se rechaza H0 con un 95%, por lo que no hay evidencia de que los datos PSCi sigan dist normal. Otros test dan los mismos resultados


// Intervalos de confianza para una muestra //

ci means psci, level(95)

ci means psci, level(99)

ci means ess, level(95)

ci means ess, level(99)


ci proportion sindicato, level (95)

ci proportion sindicato, level (99)

ci proportion sexo, level (95)

ci proportion sexo, level (99)

// Test de hipotesis// 

// PSCi será menor en personas que se definan en lo medio o alto de la escala social (>3) en comparacion a quienes se definen autoubican en la parte baja //

//H0 = //
//H1 =  // 

gen clase_baja=.
replace clase_baja=0 if ess<=3 // considerando el promedio de ess como 4.05
replace clase_baja=1 if ess>=4

bysort clase_baja: ci means psci, total 

ciplot psci, by(clase_baja)

ttest psci, by(clase_baja) unequal level(95)
ttest psci, by(clase_baja) unequal level(99)

// PSCi segun sexo//

//H0 = no hay diferencias en el promedio de PSCi entre hombres y mujeres//
//H1 = existen diferencias en el promedio de PSCi entre hombres y mujeres // 

bysort  sexo: ci means psci, total 

ciplot psci, by(sexo)

ttest psci, by(sexo) unequal level(95)
ttest psci, by(sexo) unequal level(99)

// PSCi segun sindicato//

//H0 = no hay diferencias en el promedio de PSCi entre miembros y no miembros//
//H1 = existen diferencias en el promedio de PSCi entre miembros y no miembros// 

bysort  sindicato: ci means psci, total 

ciplot psci, by(sindicato)

ttest psci, by(sindicato) unequal level(95)
ttest psci, by(sindicato) unequal level(99)

// Clase baja segun sexo //

//H0 = //
//H1 =  // 

prtest clase_baja, by(sexo) level(95)
prtest clase_baja, by(sexo) level(99)
