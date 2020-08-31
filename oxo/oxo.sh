#!/bin/bash

#==================================================================================================================================================#
#							 									    FUNCTIONS	   #
#==================================================================================================================================================#

#______________________________________________________________________________________________________________ MENU, ARGUMENTS, PERMISSIONS

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
	echo "[Uso] oxo.sh     -> juego 	     "
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


#______________________________________________________________________________________________________________ CONFIGURATION

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
function loadConfig(){
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


#Prints a new menu for configuration option
# It prints what values can the varibles get and their meanings
function menuConfig(){
	clear
	echo "=========================================="
	echo "|            CONFIGURACION               |"
	echo "=========================================="
	echo "-----------------------------------------------------------"
	echo "|    COMIENZO = 1 -> comienza el humano                   |"
	echo "|               2 -> comienza la maquina                  |"
	echo "|               3 -> comienzo aleatorio                   |"
	echo "-----------------------------------------------------------"
	echo "|FICHACENTRAL = 1 -> ficha central no se puede mover      |"
	echo "|               2 -> ficha central se puede mover         |"
	echo "-----------------------------------------------------------"
	echo "|ESTADISTICAS = nombre_fichero_estadisticas               |"
	echo "-----------------------------------------------------------"
}


#Configuration option
function configuration(){
	clear
	echo "=========================================="
	echo "|            CONFIGURACION               |"
	echo "=========================================="
		
	echo "Configuración actual:"
	echo "-----------------------"
	while IFS== read ATRIBUTO VALOR
	do
		echo "$ATRIBUTO = $VALOR"
				
	done < oxo.cfg
	echo "-----------------------"
	echo ""

	read -p "¿Quiere cambiar la configuración actual?[S para cambiar]: " SN
	if test "$SN" = "S" -o "$SN" = "s"
	then
		sleep 1
		menuConfig
		
		echo "Introduzca los nuevos valores:"
	
		COMIENZO=0 
		until test $COMIENZO -eq 1 -o $COMIENZO -eq 2 -o $COMIENZO -eq 3
		do
			read -p "COMIENZO = " COMIENZO 
		done	
		
		FICHACENTRAL=0
		until test $FICHACENTRAL -eq 1 -o $FICHACENTRAL -eq 2
		do
			read -p "FICHACENTRAL = " FICHACENTRAL 
		done
		
		AUX=".log"
		while test $AUX = ".log"
		do                            
			read -p "ESTADISTICAS (nombre sin extensión) = " AUX 
			AUX="$AUX.log"
		done

		#If the new name is different to the old name and there is not 
		#  a file with the new name, it just ranames it
		if test $AUX != $ESTADISTICAS -a ! -f $AUX
		then 
			mv $ESTADISTICAS $AUX	
		fi

		ESTADISTICAS=$AUX
		echo "COMIENZO=$COMIENZO" > oxo.cfg
		echo "FICHACENTRAL=$FICHACENTRAL" >> oxo.cfg
		echo "ESTADISTICAS=$ESTADISTICAS" >> oxo.cfg
	fi
}

#______________________________________________________________________________________________________________ STATS



#______________________________________________________________________________________________________________ GAME

#Prints the game board and some more info as the current turn
function printBoard(){
	clear
        echo "        -------------         TURNO Nº $TURN                                   "
        echo "        | ${B[0]} | ${B[1]} | ${B[2]} |       MOVIMIENTOS: $MOVEMENTS          "
        echo "        -------------       HORA INICIO: $START_HOUR                           "  
        echo "        | ${B[3]} | ${B[4]} | ${B[5]} |                                        "
        echo "        -------------       FICHAS |     JUGADOR ${PHT[2]} ${PHT[1]} ${PHT[0]} "
        echo "        | ${B[6]} | ${B[7]} | ${B[8]} |         EN   |                         "
        echo "        -------------        MANO  |  COMPUTADOR ${CHT[2]} ${CHT[1]} ${CHT[0]} "
	echo ""
}


#Inits the game variables and starts the game
function game(){
	B=("_" "_" "_" "_" "_" "_" "_" "_" "_") #Game board
	PID=$$					#Game number (PID)
	START_DATE=$(date +%d-%m-%Y)		#Start date
	START_HOUR=$(date +"%T") 		#Start hour
	NPLAYER_TOKENS=0			#Number of player tokens
        NPC_TOKENS=0				#Number of pc tokens	
        MOVEMENTS=0				#Counter of the number of movemens
	TURN=0					#Player/pc turn

	startGame
}


#Game function
function startGame(){
	START=$COMIENZO
	EXIT_IF_WIN=0
	INIT_TIME=$SECONDS
	
	#If COMIENZO is equal to 3(random start), it takes a random number
	#  to select who starts. If not, it just says who starts
	if test $COMIENZO -eq 3
	then
		START=$((($RANDOM)%2+1))
	else
		START=$COMIENZO
	fi


	if test $START -eq 1 
	then
		PLAYER_TOKEN="X"
		PC_TOKEN="O"
		PLAYER_NUM=1
		PC_NUM=2
	
		#This is just for visual purposes (each player hand)
		PHT=("$PLAYER_TOKEN" "$PLAYER_TOKEN" "$PLAYER_TOKEN") #Player Hand Tokens 
		CHT=("$PC_TOKEN" "$PC_TOKEN" "$PC_TOKEN") 	      #Computer Hand Tokens
              
		echo "COMIENZA EL JUGADOR"
		while test $EXIT_IF_WIN -eq 0
                do
		    TURN=$(($TURN+1))
		    printBoard

                    playerTurn
		    checkIfWin 
		    
                    pcTurn
		    checkIfWin 
                done

	elif test $START -eq 2 
	then
		PLAYER_TOKEN="O"
		PC_TOKEN="X"
		PLAYER_NUM=2
		PC_NUM=1

		PHT=("$PLAYER_TOKEN" "$PLAYER_TOKEN" "$PLAYER_TOKEN") #Player Hand Tokens 
		CHT=("$PC_TOKEN" "$PC_TOKEN" "$PC_TOKEN") 	      #Computer Hand Tokens

                echo "COMIENZA EL COMPUTADOR"
                while test $EXIT_IF_WIN -eq 0
                do
		     TURN=$(($TURN+1))
		     printBoard

		     pcTurn
		     checkIfWin 

                     playerTurn
		     checkIfWin 			
               done
        fi
}


function playerTurn(){
	if test $EXIT_IF_WIN -eq 0 
     	then
		P_FROM_BOX=0 #Player origen box
		P_TO_BOX=0   #Player destination box
		echo "TURNO DEL JUGADOR [ $PLAYER_TOKEN ]"
		echo ""
		
		#If the player still has some tokens in his hand...
		if test $NPLAYER_TOKENS -lt 3
		then
			while test $P_TO_BOX -eq 0 -o ${B[$(($P_TO_BOX-1))]} != "_"
			do
			      read -p "INTRODUZA UNA FICHA (1-9): " P_TO_BOX

			      if test "$P_TO_BOX" != "1" -a "$P_TO_BOX" != "2" -a "$P_TO_BOX" != "3" -a "$P_TO_BOX" != "4" -a "$P_TO_BOX" != "5" -a "$P_TO_BOX" != "6" -a "$P_TO_BOX" != "7" -a "$P_TO_BOX" != "8" -a "$P_TO_BOX" != "9"
			      then 
					P_TO_BOX=0
			      fi
			done
			B[$(($P_TO_BOX-1))]="$PLAYER_TOKEN"

			if test -f play.txt 
			then
				echo ":$PLAYER_NUM.$P_FROM_BOX.$P_TO_BOX" >> play.txt
			else
				echo "$PLAYER_NUM.$P_FROM_BOX.$P_TO_BOX" > play.txt
			fi 	
			PHT[$NPLAYER_TOKENS]="_"			
			

		#If the player has already put all tokens in the board
		else
			while test $P_FROM_BOX -eq 0 -o ${B[$(($P_FROM_BOX-1))]} != "$PLAYER_TOKEN"
		        do
		              read -p "MOVER FICHA (1-9): " P_FROM_BOX

			      if test "$P_FROM_BOX" != "1" -a "$P_FROM_BOX" != "2" -a "$P_FROM_BOX" != "3" -a "$P_FROM_BOX" != "4" -a "$P_FROM_BOX" != "5" -a "$P_FROM_BOX" != "6" -a "$P_FROM_BOX" != "7" -a "$P_FROM_BOX" != "8" -a "$P_FROM_BOX" != "9" 
			      then
					P_FROM_BOX=0
			      fi					

				#If the game does not permit to move the central box, 
				#  it refuses the move
				if test $FICHACENTRAL -eq 1 -a $P_FROM_BOX -eq 5
				then  
					P_FROM_BOX=0
				fi
		        done
		
			while test $P_TO_BOX -eq 0 -o ${B[$(($P_TO_BOX-1))]} != "_" -o $P_FROM_BOX -eq $P_TO_BOX
		        do
		              read -p "A CASILLA VACIA (1-9):" P_TO_BOX
			      if test "$P_TO_BOX" != "1" -a "$P_TO_BOX" != "2" -a "$P_TO_BOX" != "3" -a "$P_TO_BOX" != "4" -a "$P_TO_BOX" != "5" -a "$P_TO_BOX" != "6" -a "$P_TO_BOX" != "7" -a "$P_TO_BOX" != "8" -a "$P_TO_BOX" != "9"
			      then 
					P_TO_BOX=0
			      fi
		        done

			B[$(($P_FROM_BOX-1))]="_"
			B[$(($P_TO_BOX-1))]="$PLAYER_TOKEN"
			echo ":$PLAYER_NUM.$P_FROM_BOX.$P_TO_BOX" >> play.txt
		fi

		MOVEMENTS=$(($MOVEMENTS+1))
		NPLAYER_TOKENS=$(($NPLAYER_TOKENS+1))
		printBoard	
		sleep 1
	fi
}

#----------------------------------------------------------
function pcTurn(){
	if test $EXIT_IF_WIN -eq 0 
	then
		C_TO_BOX=0   #Pc Destination Box
		C_FROM_BOX=0 #Pc Origin Box
		echo "TURNO DEL COMPUTADOR [ $PC_TOKEN ]"
		sleep 1

		if test $NPC_TOKENS -lt 3
		then
		
			while test $C_TO_BOX -lt 1 -o ${B[$(($C_TO_BOX-1))]} != "_"
			do
				C_TO_BOX=$(($RANDOM%9+1))
			done
			B[$(($C_TO_BOX-1))]="$PC_TOKEN"
			
			if test -f play.txt 
			then
				echo ":$PC_NUM.$C_FROM_BOX.$C_TO_BOX" >> play.txt
			else
				echo "$PC_NUM.$C_FROM_BOX.$C_TO_BOX" > play.txt
			fi 
			CHT[$NPC_TOKENS]="_"

		else
			while test $C_FROM_BOX -lt 1 -o ${B[$(($C_FROM_BOX-1))]} != $PC_TOKEN
		        do
		                C_FROM_BOX=$((($RANDOM)%9+1))

				#If the game does not permit to move the central box, 
				#  it refuses the move
				if test $FICHACENTRAL -eq 1 -a $C_FROM_BOX -eq 5
				then  
					C_FROM_BOX=0
				fi
		        done
		
			while test $C_TO_BOX -lt 1 -o ${B[$(($C_TO_BOX-1))]} != "_" -o $C_FROM_BOX -eq $C_TO_BOX
		        do
		               C_TO_BOX=$((($RANDOM)%9+1))
		        done

			B[$(($C_FROM_BOX-1))]="_"
			B[$(($C_TO_BOX-1))]="$PC_TOKEN"
			echo ":$PC_NUM.$C_FROM_BOX.$C_TO_BOX" >> play.txt
		fi

		MOVEMENTS=$(($MOVEMENTS+1))
		NPC_TOKENS=$(($NPC_TOKENS+1))
		printBoard			
		sleep 1
	fi
}


function checkIfWin(){
	if test $EXIT_IF_WIN -eq 0 
	then
		if test   ${B[1]} = ${B[0]} -a ${B[2]} = ${B[0]}     #0-1-2(board) -> 1-2-3
		then 
			if test ${B[0]} = $PLAYER_TOKEN
			then
				playerVictory
			elif test ${B[0]} = $PC_TOKEN
			then
				pcVictory	
			fi

		elif test ${B[3]} = ${B[0]} -a ${B[6]} = ${B[0]}     #0-3-6(board) -> 1-4-7
		then
			if test ${B[0]} = $PLAYER_TOKEN
			then
				playerVictory
			elif test ${B[0]} = $PC_TOKEN
			then
				pcVictory	
			fi
		
		elif test ${B[0]} = ${B[4]} -a ${B[8]} = ${B[4]}     #0-4-8(board) -> 1-5-9
		then 
			if test ${B[0]} = $PLAYER_TOKEN
			then
				playerVictory
			elif test ${B[0]} = $PC_TOKEN
			then
				pcVictory	
			fi
	
		elif test ${B[3]} = ${B[4]} -a ${B[5]} = ${B[4]}     #3-4-5(board) -> 4-5-6
		then 
			if test ${B[3]} = $PLAYER_TOKEN
			then
				playerVictory
			elif test ${B[3]} = $PC_TOKEN
			then
				pcVictory	
			fi

		elif test ${B[1]} = ${B[4]} -a ${B[7]} = ${B[4]}     #1-4-7(board) -> 2-5-8
		then 
			if test ${B[1]} = $PLAYER_TOKEN
			then
				playerVictory
			elif test ${B[1]} = $PC_TOKEN
			then
				pcVictory	
			fi

		elif test ${B[2]} = ${B[4]} -a ${B[6]} = ${B[4]}     #2-4-6(board) -> 3-5-7
		then 
			if test ${B[2]} = $PLAYER_TOKEN
			then
				playerVictory
			elif test ${B[2]} = $PC_TOKEN
			then
				pcVictory	
			fi
	
		elif test ${B[2]} = ${B[8]} -a ${B[5]} = ${B[8]}     #2-5-8(board) -> 3-6-9
		then 
			if test ${B[2]} = $PLAYER_TOKEN
			then
				playerVictory
			elif test ${B[2]} = $PC_TOKEN
			then
				pcVictory	
			fi
		
		elif test ${B[6]} = ${B[8]} -a ${B[7]} = ${B[8]}     #6-7-8(board) -> 7-8-9
		then 
			if test ${B[6]} = $PLAYER_TOKEN
			then
				playerVictory
			elif test ${B[6]} = $PC_TOKEN
			then
				pcVictory	
			fi
		fi 
		
	fi
}


function playerVictory(){
	FINAL_TIME=$SECONDS
	GAME_TIME=$(($FINAL_TIME-$INIT_TIME))
	EXIT_IF_WIN=1	
	WINNER=1
	clear 
	echo "==============================================================================="
	echo " |===== |\    | |    | |====| |===| |===| |===|  |   | |===== |\    | |===|  | "
	echo " |      | \   | |    | |    | |   | |   | |    | |   | |      | \   | |   |  | "
	echo " |===   |  \  | |====| |    | |===| |   | |===|  |   | |===   |  \  | |   |  | "
	echo " |      |   \ | |    | |    | |  \  |===| |    | |   | |      |   \ | |===|    "
	echo " |===== |    \| |    | |====| |   \ |   | |===|  |===| |===== |    \| |   |  0 "
	echo "==============================================================================="
	echo "                                HAS GANADO!!!!                                 "
	echo "==============================================================================="	 
	#menuEstadisticasVictoria
	sleep 2
}

function pcVictory(){
	FINAL_TIME=$SECONDS
	GAME_TIME=$(($FINAL_TIME-$INIT_TIME))
	EXIT_IF_WIN=1	
	WINNER=2
	clear 
	echo "==============================================================================="
	echo "         |===     |=====    |===|   |===|   |====|  |=====|  |===|             "
	echo "         |   \    |         |   |   |   |   |    |     |     |   |             "
	echo "         |    |   |===      |===|   |===|   |    |     |     |   |             "
	echo "         |   /    |         |  \    |  \    |    |     |     |===|             "
	echo "         |===     |=====    |   \   |   \   |====|     |     |   |             "
	echo "==============================================================================="
	echo "|                              HAS PERDIDO!!!!                                |"
	echo "==============================================================================="	
	#menuEstadisticasVictoria
	sleep 2
}
#==================================================================================================================================================#
#							 									  MAIN PROGRAM	   #
#==================================================================================================================================================#

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
		"C" | "c") configuration
		;;
		
		"J" | "j") game
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





		
