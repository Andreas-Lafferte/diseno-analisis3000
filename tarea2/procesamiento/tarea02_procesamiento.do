
***********************************************************

/*** 0. Identificacion

Titulo: Tarea 2 Diseño y Analisis de Investigacion Social 
Institucion: Instituto de Sociologia UC
Tema: Procesamiento de datos
Autor: Andreas Laffert     
Fecha: 19-05-2024 

***/

  
**************************************************************


/*** 1. Cargar datos ***/

use "/Users/macbookair/Documents/Magister UC/1° Semestre 2024/Diseño y Análisis de Investigación Social/tarea2/input/db_isuc2.dta"


/*** 2. Procesamiento ***/

keep v40 v41 v42 v43 topbot union sex educyrs cl_prty // seleccionar

describe // describir tipo de variable y label

// sindicato //

tab union 

recode union (1=1) (2=1) (3=0) (9=.), generate(sindicato) // recodificar 

// sexo //

tab sex 

recode sex (1=0) (2=1), generate(sexo) // recodificar 

// ESS //

tab topbot

recode topbot (1=1) (2=2) (3=3) (4=4) (5=5) (6=6) (7=7) (8=8) (9=9) (10=10) (98=.) (99=.), generate(ess)

// educacion en años //

tab educyrs

replace educyrs = . if inlist(educyrs, 0, 97, 99) // recodificar valores 0 y no sabe o no responde como perdido

// ideologia politica //

tab cl_prty

gen ideologia = ""
replace ideologia = "Derecha" if inlist(cl_prty, 2, 4, 9, 10)
replace ideologia = "Centro" if inlist(cl_prty, 1, 6, 7)
replace ideologia = "Izquierda" if inlist(cl_prty, 3, 5, 8)
replace ideologia = "Sin identificación" if inlist(cl_prty, 95, 96)

tab ideologia

// PSCi (Perceived Social Conflict Index) //

tab v40
tab v41
tab v42
tab v43

gen conflict_rp = .
replace conflict_rp = 3 if v40 == 1
replace conflict_rp = 2 if v40 == 2
replace conflict_rp = 1 if v40 == 3
replace conflict_rp = 0 if v40 == 4

gen conflict_wcmc = .
replace conflict_wcmc = 3 if v41 == 1
replace conflict_wcmc = 2 if v41 == 2
replace conflict_wcmc = 1 if v41 == 3
replace conflict_wcmc = 0 if v41 == 4

gen conflict_wm = .
replace conflict_wm = 3 if v42 == 1
replace conflict_wm = 2 if v42 == 2
replace conflict_wm = 1 if v42 == 3
replace conflict_wm = 0 if v42 == 4

gen conflict_tb = .
replace conflict_tb = 3 if v43 == 1
replace conflict_tb = 2 if v43 == 2
replace conflict_tb = 1 if v43 == 3
replace conflict_tb = 0 if v43 == 4

egen psci = rowtotal(conflict_rp conflict_wcmc conflict_wm conflict_tb), missing // crear indice rowwise

// Seleccionar y tratar casos perdidos // 

keep psci ess sindicato sexo educyrs ideologia

drop if missing(psci) | missing(ess) | missing(sindicato) | missing(sexo) | missing(educyrs) | missing(ideologia) // tratamiento casos perdidos: listwise deletion, solo casos completos

/*** 3. Guardar ***/

save "/Users/macbookair/Documents/Magister UC/1° Semestre 2024/Diseño y Análisis de Investigación Social/tarea2/output/db_proc.dta", replace 




