#!/bin/bash

#============================================================================#
#				"FUNCTIONS"				     #
#============================================================================#

#____________________________________________________________ MENU, ARGUMENTS, PERMISSIONS

#Prints the game menu
function menu(){
	clear
	echo "=========================================="
	echo "|                   OXO                  |"
	echo "=========================================="
	echo "|      C)CONFIGURACION                   |"
	echo "|      J)JUGAR                           |"
	echo "|      E)ESTADÍSTICAS                    |"
	echo "|      S)SALIR                           |"
	echo "=========================================="
}

#Prints how to use the program and the allowed arguments
# when the program is not used correctly
function argsError(){
	clear
	echo "[Uso] oxo.sh     -> juego 		    "
	echo "      oxo.sh -g  -> nombre del creador "
	exit 
}

#Slightly modified function from the real version (no personal data added)
function printGroupComponents(){
	clear
	echo "=============================================="
	echo "|                  CREADOR                   |"
	echo "=============================================="
	echo "|     David Cruz García                      |"
	echo "|        GitHub: https://github.com/dcross23 |"
	echo "=============================================="
}


#Checks for correct file permissions
# 1 arg: $1 -> file to check permissions
function checkPermissions(){
	#Check write permissions
	if test ! -w $1
	then 
		echo "El fichero $1 no tiene permisos suficientes"
		echo "[ERROR] faltan permisos de escritura (w)"
		exit

	elif test ! -r $1
	then
		echo "El fichero $1 no tiene permisos suficientes"
		echo "[ERROR] faltan permisos de lectura (r)"
		exit

	fi
	echo ""
}


#___________________________________________________________________________ LOAD CONFIG

#Checks if "oxo.cfg" config file exists and if it has the 
# necessary read/write permissions
function checkConfigFile(){
	if test ! -f oxo.cfg 
	then 
		echo "Fichero de configuración no encontrado"
		echo "[ERROR] Falta fichero oxo.cfg"
		exit
	
	else	
		   clear
		echo "Cargando fichero de configuracion [#-----]"
		sleep 1

		checkPermissions "oxo.cfg"

		   clear
		echo "Cargando fichero de configuracion [###---]"
		sleep 1
		   clear
		echo "Cargando fichero de configuracion [####--]"
		sleep 1
		   clear
		echo "Cargando fichero de configuracion [######]"
		sleep 1
	fi
}

#Loads config from "oxo.cfg" config file
loadConfig(){
	#While there is a new line with format:
	#    ATRIBUTE=VALUE (using IFS equal to "=" delimiter)
	#  checks new line and tries to load config
	while IFS== read ATRIBUTE VALUE
	do	
		if test "$ATRIBUTE" = "COMIENZO"
		then
			if test $VALUE -ne 1 -a $VALUE -ne 2 -a $VALUE -ne 3
			then
				echo "Error al cargar el fichero de configuracion"
				echo "[ERROR] Valor para COMIENZO inválido: $VALUE"
				exit
			fi
			COMIENZO=$VALUE

		elif test "$ATRIBUTE" = "FICHACENTRAL"
		then
			if test $VALUE -ne 1 -a $VALUE -ne 2
			then
				echo "Error al cargar el fichero de configuracion"
				echo "[ERROR] Valor para FICHACENTRAL inválido: $VALUE"
				exit
			fi
			FICHACENTRAL=$VALUE

		elif test "$ATRIBUTE" = "ESTADISTICAS"
		then
			#Checks for stats file and tries to load it
			if test ! -f $VALUE
			then 
				echo "Error al cargar el fichero de configuracion"
				echo "No se encontró el fichero de estadísticas"
				echo "[ERROR] Fichero de ESTADISTICAS inexistente: [nombre].log"
				ESTADISTICAS="___/_/fichero_inexistente\_\___.log"
			
			else
				ESTADISTICAS=$VALUE
				echo "Cargando fichero de estadísticas [#-----]"
				sleep 1

				checkPermissions "$ESTADISTICAS"

				   clear 
				echo "Cargando fichero de configuracion [######]"
				echo "Cargando fichero de estadísticas [###---]"
				sleep 1
				   clear
				echo "Cargando fichero de configuracion [######]"
				echo "Cargando fichero de estadísticas [####--]"
				sleep 1
				   clear
				echo "Cargando fichero de configuracion [######]"
				echo "Cargando fichero de estadísticas [######]"
				   sleep 1
				echo "Iniciando...."
				sleep 2
			fi

		else
				echo "No se puede cargar el fichero de configuracion"
				echo "[ERROR] Atributo inválido: '$ATRIBUTE'"
				exit 	
		fi

	done < oxo.cfg

  	#If config is correct but stats file doesnt exist, it gives the user
	# the option to create a new one
	if test ! -f $ESTADISTICAS
	then
		read -p "¿Quiere crear un nuevo fichero de estadísticas?[S para cambiar]: " SN
		if test $SN = "S" -o $SN = "s"
		then
			read -p "NOMBRE (sin extension)= " NAME
			touch $NAME.log
			ESTADISTICAS="$NAME.log"
			chmod 666 $ESTADISTICAS
		
		else
			exit 	
		fi
	fi
}




#============================================================================#
#				"MAIN PROGRAM"				     #
#============================================================================#

#Args check
if test $# -gt 1 
then
	echo "[ERROR] Numero inválido de argumentos"
	argsError

elif test $# -eq 1
then
	if test $1 = "-g"
	then
		printGroupComponents
		exit
	
	else
		echo "[ERROR] Argumento inválido"
		argsError
	fi
fi


#Check for config file and if it exists, loads it
checkConfigFile
loadConfig

#Prints menu and starts the game
while :
do
	menu
	read -p "Introduzca una opción >> " OPTION
	
	echo ""
	case $OPTION in
		"C" | "c") exit #config
		;;
		
		"J" | "j") exit #game
		;;
		
		"E" | "e") exit #stats
		;;
		
		"S" | "s") echo "Saliendo....."
			   exit
		;;

	 	*        ) echo "Opcion inválida"
			   read -p "Pulde INTRO para continuar"
		;;
	esac 
done





		