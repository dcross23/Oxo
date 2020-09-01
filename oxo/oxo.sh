#!/bin/bash

#==================================================================================================================================================#
#							 									    FUNCTIONS	   #
#==================================================================================================================================================#

#______________________________________________________________________________________________________________ MENU, ARGUMENTS, PERMISSIONS

#Prints the game menu
function menu(){
	clear
	echo -e "\e[1;36m===========================================\e[0m"
	echo -e "\e[1;36m|                   OXO                   |\e[0m"
	echo -e "\e[1;36m===========================================\e[0m"
	echo -e "\e[1;36m|\e[0m      C)CONFIGURACION                    \e[1;36m|\e[0m"
	echo -e "\e[1;36m|\e[0m      J)JUGAR                            \e[1;36m|\e[0m"
	echo -e "\e[1;36m|\e[0m      E)ESTADÍSTICAS                     \e[1;36m|\e[0m"
	echo -e "\e[1;36m|\e[0m      S)SALIR                            \e[1;36m|\e[0m"
	echo -e "\e[1;36m===========================================\e[0m"
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
		echo -e "Cargando fichero de configuracion \e[0;35m[#-----]\e[0m"
		sleep 1

		checkPermissions "oxo.cfg"

		   clear
		echo -e "Cargando fichero de configuracion \e[0;35m[###---]\e[0m"
		sleep 1
		   clear
		echo -e "Cargando fichero de configuracion \e[0;35m[####--]\e[0m"
		sleep 1
		   clear
		echo -e "Cargando fichero de configuracion \e[0;35m[######]\e[0m"
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
				echo -e "Cargando fichero de estadísticas \e[0;35m[#-----]\e[0m"
				sleep 1

				checkPermissions "$ESTADISTICAS"

				   clear 
				echo -e "Cargando fichero de configuracion \e[0;35m[######]\e[0m"
				echo -e "Cargando fichero de estadísticas \e[0;35m[###---]\e[0m"
				sleep 1
				   clear
				echo -e "Cargando fichero de configuracion \e[0;35m[######]\e[0m"
				echo -e "Cargando fichero de estadísticas \e[0;35m[####--]\e[0m"
				sleep 1
				   clear
				echo -e "Cargando fichero de configuracion \e[0;35m[######]\e[0m"
				echo -e "Cargando fichero de estadísticas \e[0;35m[######]\e[0m"
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
	echo -e "\e[1;36m==========================================\e[0m"
	echo -e "\e[1;36m|            CONFIGURACION               |\e[0m"
	echo -e "\e[1;36m==========================================\e[0m"
	echo -e "\e[1;36m-----------------------------------------------------------\e[0m"
	echo -e "\e[1;36m|\e[1;33m    COMIENZO = 1 -> comienza el humano                   \e[1;36m|\e[0m"
	echo -e "\e[1;36m|\e[1;33m               2 -> comienza la maquina                  \e[1;36m|\e[0m"
	echo -e "\e[1;36m|\e[1;33m               3 -> comienzo aleatorio                   \e[1;36m|\e[0m"
	echo -e "\e[1;36m-----------------------------------------------------------\e[0m"
	echo -e "\e[1;36m|\e[1;33mFICHACENTRAL = 1 -> ficha central no se puede mover      \e[1;36m|\e[0m"
	echo -e "\e[1;36m|\e[1;33m               2 -> ficha central se puede mover         \e[1;36m|\e[0m"
	echo -e "\e[1;36m-----------------------------------------------------------\e[0m"
	echo -e "\e[1;36m|\e[1;33mESTADISTICAS = nombre_fichero_estadisticas               \e[1;36m|\e[0m"
	echo -e "\e[1;36m-----------------------------------------------------------\e[0m"
}


#Configuration option
function configuration(){
	clear
	echo -e "\e[1;36m==========================================\e[0m"
	echo -e "\e[1;36m|            CONFIGURACION               |\e[0m"
	echo -e "\e[1;36m==========================================\e[0m"
		
	echo -e "\e[1;36mConfiguración actual:\e[0m"
	echo -e "\e[1;36m-----------------------\e[0m"
	while IFS== read ATRIBUTO VALOR
	do
		echo -e "\e[1;33m $ATRIBUTO = $VALOR\e[0m"
				
	done < oxo.cfg
	echo -e "\e[1;36m-----------------------\e[0m"
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

#Save the stats of the last game played when it finishes
function saveGameStats(){
	echo "$PID|$START_DATE|$START|$FICHACENTRAL|$WINNER|$GAME_TIME|$MOVEMENTS" >> auxplay.txt
	
	#deletes all '\n' from play.txt and put it at the end of auxplay2.txt
	tr -d '\n' < play.txt >> auxplay2.txt  

	#paste the plays with the other stats using "|" delimiter and adds it to the stats file
	paste -d "|" auxplay.txt auxplay2.txt >> $ESTADISTICAS  

	rm play.txt
	rm auxplay.txt
	rm auxplay2.txt
}



#Calculates the necessary stats from the plays in the stats file
#  (min/max play time, min/max play movements, ...)
function statsCalculations(){
        #GENERAL STATS
        #-----------------------------------------------------

        IFS="|" read PID_E START_DATE_E START_E CENTRAL_E WINNER_E TIME_E MOVEMENTS_E PLAYS_E < $ESTADISTICAS
        TIME_MIN=$TIME_E
        TIME_MAX=$TIME_E
        MOV_MIN=$MOVEMENTS_E
        MOV_MAX=$MOVEMENTS_E

        NUM_PLAYS=0
        TOTAL_MOVEMENTS=0
        TOTAL_TIME=0
        
        while IFS="|" read PID_E START_DATE_E START_E CENTRAL_E WINNER_E TIME_E MOVEMENTS_E PLAYS_E
        do
                NUM_PLAYS=$(($NUM_PLAYS+1))
                TOTAL_MOVEMENTS=$(($TOTAL_MOVEMENTS+$MOVEMENTS_E))
                TOTAL_TIME=$(($TOTAL_TIME+$TIME_E))
                
                #"ESPECIAL" PLAYS
                #----------------------------------------

                if test $TIME_E -lt $TIME_MIN
                then
                        TIME_MIN=$TIME_E
                fi
                
                if test $TIME_E -gt $TIME_MAX
                then
                        TIME_MAX=$TIME_E
                fi
                
                if test $MOVEMENTS_E -lt $MOV_MIN
                then
                        MOV_MIN=$MOVEMENTS_E
                fi
                
                if test $MOVEMENTS_E -gt $MOV_MAX
                then
                        MOV_MAX=$MOVEMENTS_E
                fi

        done < $ESTADISTICAS
        
        MEDIA_LENGTH_MOV=$(($TOTAL_MOVEMENTS/$NUM_PLAYS))
        MEDIA_TIMES=$(($TOTAL_TIME/$NUM_PLAYS))        
}



#Stats option. It prints a menu showing general stats and special plays
function stats(){
        clear
	echo -e "\e[1;36m==========================================\e[0m"
	echo -e "\e[1;36m|             ESTADISTICAS               |\e[0m"
	echo -e "\e[1;36m==========================================\e[0m"
	
	NUM_LINES=$(cat $ESTADISTICAS | wc -l)
	if test $NUM_LINES -gt 0
	then
		echo ""
		statsCalculations
		echo -e "\e[1;36m----------------------------------------------------------------\e[0m"
		echo -e "\e[1;36m                       GENERALES                                \e[0m"
		echo -e "\e[1;36m----------------------------------------------------------------\e[0m"
		echo " Numero total de partidas jugadas..............:$NUM_PLAYS"
		echo " Media de la cantidad de movimientos...........:$MEDIA_LENGTH_MOV"
		echo " Media de los tiempos de partida...............:$MEDIA_TIMES segundos"
		echo " Tiempo total invertido en todas las partidas..:$TOTAL_TIME segundos"
		echo ""
		echo ""
		echo -e "\e[1;36m----------------------------------------------------------------\e[0m"
		echo -e "\e[1;36m                    JUGADAS ESPECIALES                          \e[0m"
		echo -e "\e[1;36m----------------------------------------------------------------\e[0m"
		echo " Datos de la(s) jugada(s) más corta(s) en tiempo"
		while IFS="|" read PID_E START_DATE_E START_E CENTRAL_E WINNER_E TIME_E MOVEMENTS_E PLAYS_E
		do
		        if test $TIME_E -eq $TIME_MIN
			then
		                echo -e "\e[1;33m    $PID_E|$START_DATE_E|$START_E|$CENTRAL_E|$WINNER_E|$TIME_E|$MOVEMENTS_E|$PLAYS_E\e[0m"
		        fi
		done < $ESTADISTICAS
		

		echo ""
		echo " Datos de la(s) jugada(s) más larga(s) en tiempo"
		while IFS="|" read PID_E START_DATE_E START_E CENTRAL_E WINNER_E TIME_E MOVEMENTS_E PLAYS_E
		do
		        if test $TIME_E -eq $TIME_MAX
			then
		                echo -e "\e[1;33m    $PID_E|$START_DATE_E|$START_E|$CENTRAL_E|$WINNER_E|$TIME_E|$MOVEMENTS_E|$PLAYS_E\e[0m"
		        fi
		done < $ESTADISTICAS
		

		echo ""
		echo " Datos de la(s) jugada(s) de menos movimientos"
		while IFS="|" read PID_E START_DATE_E START_E CENTRAL_E WINNER_E TIME_E MOVEMENTS_E PLAYS_E
		do
		        if test $MOVEMENTS_E -eq $MOV_MIN
		        then
		                echo -e "\e[1;33m    $PID_E|$START_DATE_E|$START_E|$CENTRAL_E|$WINNER_E|$TIME_E|$MOVEMENTS_E|$PLAYS_E\e[0m"
				echo "$PID_E|$PLAYS_E" >> lessMovPlays.txt
		        fi
		done < $ESTADISTICAS
		

		echo ""
		echo " Datos de la(s) jugada(s) de más movimientos"
		while IFS="|" read PID_E START_DATE_E START_E CENTRAL_E WINNER_E TIME_E MOVEMENTS_E PLAYS_E
		do
		        if test $MOVEMENTS_E -eq $MOV_MAX
		        then
		                echo -e "\e[1;33m    $PID_E|$START_DATE_E|$START_E|$CENTRAL_E|$WINNER_E|$TIME_E|$MOVEMENTS_E|$PLAYS_E\e[0m"
		        fi
		done < $ESTADISTICAS

		
		echo ""
		echo " Nº de veces que ha estado ocupada la posición central en la jugada de menos movimientos respecto al total"
		while IFS="|" read PID_E PLAYS_E
		do
			echo "$PLAYS_E" > p.txt

			#Changes ":" delimiters for "\n" delimiters (thats why the command sed is in 2 lines, for the "\n")
			sed -e "s/:/\\
/g" p.txt > lessMovPlays2.txt  #cambiar delimitadores ":" por "\n"(por eso está en dos lineas, por el INTRO) para separar por filas

			CENTRAL_BUSY=0
			COUNT=false
			NUM_MOV=0
			while IFS="." read PLAYER_LMP ORIGEN_LMP DESTINATION_LPM  #LPM : Less Moves Play
			do
				if test $DESTINATION_LPM -eq 5 
				then
					COUNT=true
				fi	

				if test $ORIGEN_LMP -eq 5 
				then
					COUNT=false
				fi

				if $COUNT 
				then
					CENTRAL_BUSY=$(($CENTRAL_BUSY+1))
				fi
				NUM_MOV=$(($NUM_MOV+1))
			done < lessMovPlays2.txt

			echo -e "\e[1;33m    Juego $PID_E: $CENTRAL_BUSY veces de $NUM_MOV movimientos\e[0m"
				
			rm p.txt
			rm lessMovPlays2.txt
		done < lessMovPlays.txt
		
		echo ""
		rm lessMovPlays.txt
	
	else
		echo " No hay jugadas registradas"
	fi
}



#Menu that shows game stats when it finishes.
function winningMenuStats(){
	sleep 1
	echo " Fecha y hora de inicio de partida.: $START_DATE , $START_HOUR"
	echo " Tiempo de juego...................: $GAME_TIME segundos"
	echo " Nº de movimientos.................: $MOVEMENTS"
	echo " Partida numero....................: $PID"

	if test $WINNER -eq 1
	then
		echo " Ganador...........................: Jugador ($WINNER)"
	else
		echo " Ganador...........................: Computador ($WINNER)"
	fi

	echo " Configuracion partida elegida.....:"
	if test $COMIENZO -eq 1 
	then
		echo "           COMIENZO=$COMIENZO (Jugador)"

	elif test $COMIENZO -eq 2 
	then
		echo "           COMIENZO=$COMIENZO (Computador)"

	else 
		echo "           COMIENZO=$COMIENZO (Aleatorio)"
	fi


	if test $FICHACENTRAL -eq 1
	then
		echo "           FICHACENTRAL=$FICHACENTRAL (No se puede mover la ficha central)"
	else
		echo "           FICHACENTRAL=$FICHACENTRAL (Se puede mover la ficha central)"		
	fi 

	echo "           ESTADISTICAS=$ESTADISTICAS (Donde se guardará la partida)"	
}



#______________________________________________________________________________________________________________ GAME

#Prints the game board and some more info as the current turn
function printBoard(){
	clear
        echo -e "        -------------         \e[1;36mTURNO Nº \e[1;33m$TURN                                   \e[0m"
        echo -e "        | ${B[0]} | ${B[1]} | ${B[2]} |       \e[1;36mMOVIMIENTOS: \e[1;33m$MOVEMENTS          \e[0m"
        echo -e "        -------------       \e[1;36mHORA INICIO: \e[1;33m$START_HOUR                           \e[0m"  
        echo -e "        | ${B[3]} | ${B[4]} | ${B[5]} |                                        	     "
        echo -e "        -------------       \e[1;36mFICHAS |     \e[1;32mJUGADOR\e[0m ${PHT[2]} ${PHT[1]} ${PHT[0]}"
        echo -e "        | ${B[6]} | ${B[7]} | ${B[8]} |         \e[1;36mEN   |                         \e[0m"
        echo -e "        -------------        \e[1;36mMANO  |  \e[1;31mCOMPUTADOR\e[0m ${CHT[2]} ${CHT[1]} ${CHT[0]}"
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
	saveGameStats	
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


#Player turn function (put/move tokens by the user)
function playerTurn(){
	if test $EXIT_IF_WIN -eq 0 
     	then
		P_FROM_BOX=0 #Player origen box
		P_TO_BOX=0   #Player destination box
		echo -e "\e[1;32mTURNO DEL JUGADOR [\e[0m $PLAYER_TOKEN \e[1;32m]\e[0m"
		echo ""
		
		#If the player still has some tokens in his hand...
		if test $NPLAYER_TOKENS -lt 3
		then
			while test $P_TO_BOX -eq 0 -o ${B[$(($P_TO_BOX-1))]} != "_"
			do
			      read -p "INTRODUZA UNA FICHA (1-9): " P_TO_BOX

			      if test "$P_TO_BOX" != "1" -a "$P_TO_BOX" != "2" -a "$P_TO_BOX" != "3"
			      then 
					if test "$P_TO_BOX" != "4" -a "$P_TO_BOX" != "5" -a "$P_TO_BOX" != "6"
					then
						if test "$P_TO_BOX" != "7" -a "$P_TO_BOX" != "8" -a "$P_TO_BOX" != "9"
						then 
							P_TO_BOX=0
						fi
					fi
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

				if test "$P_FROM_BOX" != "1" -a "$P_FROM_BOX" != "2" -a "$P_FROM_BOX" != "3"
				then
					if test "$P_FROM_BOX" != "4" -a "$P_FROM_BOX" != "5" -a "$P_FROM_BOX" != "6"
					then
						if test "$P_FROM_BOX" != "7" -a "$P_FROM_BOX" != "8" -a "$P_FROM_BOX" != "9"
						then
							P_FROM_BOX=0
						fi
					fi
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
				if test "$P_TO_BOX" != "1" -a "$P_TO_BOX" != "2" -a "$P_TO_BOX" != "3"
				then 
					if test "$P_TO_BOX" != "4" -a "$P_TO_BOX" != "5" -a "$P_TO_BOX" != "6"
					then
						if test "$P_TO_BOX" != "7" -a "$P_TO_BOX" != "8" -a "$P_TO_BOX" != "9"
						then
							P_TO_BOX=0
						fi
					fi
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



#PC turn function (put/move tokens randomly)
function pcTurn(){
	if test $EXIT_IF_WIN -eq 0 
	then
		C_TO_BOX=0   #Pc Destination Box
		C_FROM_BOX=0 #Pc Origin Box
		echo -e "\e[1;31mTURNO DEL COMPUTADOR [\e[0m $PC_TOKEN \e[1;31m]\e[0m"
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



#Checks if there is a winner and who is him
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


#Prints a winning menu to the player and some stats
function playerVictory(){
	FINAL_TIME=$SECONDS
	GAME_TIME=$(($FINAL_TIME-$INIT_TIME))
	EXIT_IF_WIN=1	
	WINNER=1
	clear 
	echo -e "\e[1;32m===============================================================================\e[0m"
	echo -e "\e[1;32m |===== |\    | |    | |====| |===| |===| |===|  |   | |===== |\    | |===|  | \e[0m"
	echo -e "\e[1;32m |      | \   | |    | |    | |   | |   | |    | |   | |      | \   | |   |  | \e[0m"
	echo -e "\e[1;32m |===   |  \  | |====| |    | |===| |   | |===|  |   | |===   |  \  | |   |  | \e[0m"
	echo -e "\e[1;32m |      |   \ | |    | |    | |  \  |===| |    | |   | |      |   \ | |===|    \e[0m"
	echo -e "\e[1;32m |===== |    \| |    | |====| |   \ |   | |===|  |===| |===== |    \| |   |  0 \e[0m"
	echo -e "\e[1;32m===============================================================================\e[0m"
	echo -e "\e[1;32m|                              HAS GANADO!!!!🏆                               |\e[0m"
	echo -e "\e[1;32m===============================================================================\e[0m"	 
	winningMenuStats
	echo -e "\e[1;32m===============================================================================\e[0m"	 
}

#Prints a losing menu to the player and some stats
function pcVictory(){
	FINAL_TIME=$SECONDS
	GAME_TIME=$(($FINAL_TIME-$INIT_TIME))
	EXIT_IF_WIN=1	
	WINNER=2
	clear 
	echo -e "\e[1;31m===============================================================================\e[0m"
	echo -e "\e[1;31m         |===     |=====    |===|   |===|   |====|  |=====|  |===|             \e[0m"
	echo -e "\e[1;31m         |   \    |         |   |   |   |   |    |     |     |   |             \e[0m"
	echo -e "\e[1;31m         |    |   |===      |===|   |===|   |    |     |     |   |             \e[0m"
	echo -e "\e[1;31m         |   /    |         |  \    |  \    |    |     |     |===|             \e[0m"
	echo -e "\e[1;31m         |===     |=====    |   \   |   \   |====|     |     |   |             \e[0m"
	echo -e "\e[1;31m===============================================================================\e[0m"
	echo -e "\e[1;31m|                            HAS PERDIDO!!!!👾️                                |\e[0m"
	echo -e "\e[1;31m===============================================================================\e[0m"	
	winningMenuStats
	echo -e "\e[1;31m===============================================================================\e[0m"
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
	read -p "Introduzca una opción >>" OPTION
	
	echo -e "\e[0m"
	case $OPTION in
		"C" | "c") configuration
		           echo -e "\e[1;36mPulse INTRO para volver al menu\e[0m"
		           read -p ""
		;;
		
		"J" | "j") game
		     	   echo -e "\e[1;36mPulse INTRO para volver al menu\e[0m"
		           read -p ""
		;;
		
		"E" | "e") stats
		          echo -e "\e[1;36mPulse INTRO para volver al menu\e[0m"
		           read -p ""
		;;
		
		"S" | "s") echo "Saliendo....."
			   exit
		;;

	 	*        ) echo -e "\e[1;36mOpcion inválida\e[0m"
			   echo -e "\e[1;36mPulse INTRO para volver al menu\e[0m"
		           read -p ""
		;;
	esac 
done

		
