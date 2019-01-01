include mp4.asm
include m4p4.asm
include m3p4.asm
.model huge 
.stack
.data
	limxIN dw 20
	limxSN dw 40
	limyIN dw 157
	limySN dw 187

	limyIP dw 130
	limySP dw 160

	limxIA dw 25
	limxSA dw 47
	limyIA dw 170
	limySA dw 187

	posOb1 dw 0
	DinoN dw 0
	DinoA dw 0
	contObs dw 0
	punteo dw 0
	MsgUsuario db 13,10,'Usuario: ','$'
	MsgPuntos db 'Puntos: ','$'
	msgEspacio db ' ','$'
	MsgCreado db 13,10,'Usuario Creado con exito...!!!','$'
	MsgPass db 13,10,'Pass: ','$'
 	MenuP db 13,10, '    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
				 	'    %%%%%%% MENU PRINCIPAL %%%%%%%',13,10,
				 	'    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
				 	'    %%%% 1. Ingresar          %%%%',13,10,
				 	'    %%%% 2. Registrar         %%%%',13,10,
				 	'    %%%% 3. Salir             %%%%    ',13,10,
				 	'    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,'$'
	MenuAdmin db 13,10,
 	 '    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
 	 '    %%%%%%%%%%%% MENU Tops %%%%%%%%%%%%%%',13,10,
 	 '    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,
 	 '    %%%% 1. Top 10,Puntos           %%%%%',13,10,
 	 '    %%%% 2. Usuarios Registrados    %%%%%',13,10,
 	 '    %%%% 3. Salir                   %%%%%',13,10,
 	 '    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',13,10,'$'
	 MenuOp db 13,10, 'Elija una Opcion: ','$'
	 Usuario db 10 dup('$')
 	 Pass db 10 dup('$')
 	 Admin db 'admin'
 	 PassAdmin db '1234'
 	 msgPassErroneo db 'Contrasena Incorrecta vuelva a intentarlo','$'
 	 msgErrorFichero  db 13,10, 'Error el archivo que intenta abrir no existe, compruebe la ruta','$'
 	 RutaArchivo db "USUARIOS.TXT",00h
 	 RutaRepo db "TOPS.TXT",00h
 	 Contenido db 1000 dup(' '),'$'
	 PyC db ';'
	 Salto db 13,10
	 HReporte dw ?
	 Coma db ','
	 MsgError db 13,10,'Se produjo un error vuelva a intentarlo.','$'
	 tamano dw ?
	 puntos db 3 dup(30h),'$'
	 MsgInicio db 13,10, 'Usuario aceptado','$'
	 msgUsuErr db 13,10, 'Usuario no encontrado', '$'
	 msgWinLvl1 db 'Win Level 1','$'
	 msgWinLvl2 db 'Win Level 2','$'
	 msgWinLvl3 db 'Win Level 3','$'
	 msgGameOver db 'Game Over','$'

.code
	main proc
		Menu:
			Texto  					;Modo Video desactivado
			Imprimir MenuP 			;Se imprime Menu de inicio
			Imprimir MenuOp  		;Se imprime la solicitud de un caracter
			ObtenerCaracter  		;Macro usado para no esperar un caracter 
			cmp al,31h 				;Oprime 1
			je IngUsuario
			cmp al,32h   			;Oprime 2
			je RegUsuario
			cmp al,33h 				;Oprime 3
			je Salir
			jmp Menu
		IngUsuario:
			LimpiarCadena Usuario 			; Se limpia la cadena
	 		LimpiarCadena Pass
			Imprimir MsgUsuario
			LeerUsuario Usuario 			;Se verifica si el usuario es admin de lo contrario solo se agrega a usuario
			Imprimir MsgPass
			LeerTeclado pass  				;Se almacena el pass
			AbrirArchivo RutaArchivo,HReporte 		;Se abre el archivo
			LeerArchivo SIZEOF Contenido,Contenido,HReporte  ;Se llee el archivo
			cerrar HReporte 				;Se cierra el reporte
			GetSize Contenido,tamano
			Comparar Contenido,Usuario,Pass,tamano,puntos,1  	;Se compara si el usuario es valido
			ObtenerCaracter
			jmp Menu
		RegUsuario:
			LimpiarCadena Usuario
	 		LimpiarCadena Pass
			Imprimir MsgUsuario
			LeerTeclado Usuario
			Imprimir MsgPass
			LeerTeclado Pass
			AbrirArchivo RutaArchivo,HReporte
		    LeerArchivo SIZEOF Contenido, Contenido, HReporte
		    GetSize  Usuario,tamano
		    EscribirFichero2 Usuario,HReporte		;Escribo el nombre del usuario
		    EscribirFichero SIZEOF Coma,Coma,HReporte			; Escribo una coma
		    EscribirFichero2 Pass,HReporte			;Escribo la contrase;a ingresada
		    EscribirFichero SIZEOF Coma,Coma,HReporte			; Escribo una coma
		   	EscribirFichero2 puntos,HReporte			;Escribo el punteo del jugador
		    EscribirFichero SIZEOF PyC,PyC,HReporte				;Escribo punto y coma
		    GetSize Salto,tamano
		    EscribirFichero  SIZEOF Salto,Salto,HReporte			;Escribo un salto de linea
		    cerrar HReporte
		    Imprimir MsgCreado
		    ObtenerCaracter
		    jmp Menu
		ValidarPassAdm:
			Imprimir MsgPass
	 		LeerPass Pass	
	 		jmp ValidarPassAdm

	 	EtiquetaReportes:
	 		Imprimir MenuAdmin
	 		Imprimir MenuOp
	 		ObtenerCaracter
	 		cmp al,31h
	 		je Top10
	 		cmp al,32h
	 		je LogUsuarios
	 		cmp al,33h
	 		je Menu
	 		jmp EtiquetaReportes
	 	Prejuego:
	 		GRAPH				;320 Eje X , 200 Ejey
	 		Rdcl:
	 		PALETA 0fh  
	 		PALETA 00h
	 		PintarDino 157,0fh  	;Se pinta el dinosaurio inicial
	 		ObtenerCaracter
	 		mov punteo,0
	 		Info 
	 		mov DinoN,1  			;Se utiliza para saber la posicion del dinosaurio
	 		mov DinoA,1 			;Se usa para saber la posicion anterior del dinosaurio
	 		mov posOb1,300 			;posicion 300 del objeto
	 		mov contObs,0  			;contador de obstaculos
	 		Nivel1:
	 			xor si,si
		 		MoverObs:
		 			cmp posOb1,0
		 			je ColocOb2
		 			inc posOb1
		 			Obstaculo posOb1,00h  ;Se borra el objeto anterior
		 			dec posOb1
		 			Obstaculo posOb1,02h 	;Se pinta el objeto nuevo
		 			dec posOb1
		 			leerTecla 				;Se lee el teclado 
		 			RETARDO 100  			;delay
		 			jmp MoverObs
		 		MoverNube:
		 			cmp posOb1,0
		 			je ColocOb2
		 			inc posOb1
		 			Nube posOb1,00h  		;Se borra la nube anterior
		 			dec posOb1
		 			Nube posOb1,09h 		;Se pinta la nube nueva
		 			dec posOb1
		 			leerTecla
		 			RETARDO 100
		 			jmp MoverNube
		 		ColocOb2:
		 			add punteo,10
		 			inc posOb1
		 			Obstaculo posOb1,00h
		 			Nube posOb1,00h
		 			mov posOb1,300
		 			inc contObs
		 			cmp contObs,1
		 			je MoverNube
		 			cmp contObs,3
		 			je MoverNube
		 			cmp contObs,5
		 			je WinLevel1
		 			jmp MoverObs
		WinLevel1:
			Imprimir msgWinLvl1
			jmp Colision2
		WinLevel2:
			Imprimir msgWinLvl2
			jmp Colision2
		WinLevel3:
			Imprimir msgWinLvl3
			jmp Colision2
		 Colision2:
		 	Info
		 	Comparar Contenido,Usuario,Pass,tamano,puntos,0
		 	AbrirArchivo RutaArchivo,HReporte
		    EscribirFichero2 Contenido,HReporte		;Escribo el nombre del usuario
		    cerrar HReporte
		    ObtenerCaracter
		 	jmp Menu
			


	 	Top10:
	 		jmp salir
	 	LogUsuarios:
	 		AbrirArchivo RutaArchivo,HReporte
			LeerArchivo SIZEOF Contenido,Contenido,HReporte
			cerrar HReporte
	 		Reporte1 Contenido,usuario
	 		ObtenerCaracter
	 		jmp Menu

	 	ErrorNoExiste:
			Imprimir msgErrorFichero
			ObtenerCaracter
			jmp menu

		Salir:
			CerrarP

	main endp
	end main