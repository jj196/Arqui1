;---------------Macros--------------------------------
	Imprimir macro cadena
		mov ax,@data
		mov ds,ax
		mov ah,09
		mov dx,offset cadena 				;inicializa en dx la posicion donde comienza la cadena
		int 21h
	endm
	AbrirArchivo macro Path,manejador
		lea dx,Path
		mov ah,3dh 
		mov al, 02h 
		int 21h 
		mov manejador,ax 
		jc ErrorNoExiste
	endm 
	CerrarP macro
		mov ah, 4Ch                               ;función 4Ch, Imprimir en pantalla
	    mov al,00h
	    int 21h  
	endm
	Convertir macro resultado,buffer
	  local segDiv2,segDiv11,FinCR2
	  xor si,si
	  xor cx,cx
	  xor ax,ax
	  xor dx,dx
	  xor bx,bx
	  mov ax,resultado
	  mov bx,10
	  jmp segDiv2
	  segDiv11:
	  xor ah,ah
	  segDiv2:
	  div bx
	  inc cx
	  push dx
	  cmp ax,00h ;si ya dio 0 en el cociente dejar de dividir
	  je FinCR2
	  jmp segDiv11
	  FinCR2:
	  pop ax
	  add al,30h
	  mov buffer[si],al
	  inc si
	  loop FinCR2
	  mov ah,24h ;ascii del $
	  mov buffer[si],ah
	  inc si
	endm
	ObtenerCaracter macro
     mov ah,0dh
     int 21h
     mov ah,01h
     int 21h
	endm
	GetSize macro buffer,tam
	  mov tam,0
	  mov tam,SIZEOF buffer
	  dec tam
	endm
	cerrar macro handle
		mov ah,3eh 
		mov bx,handle 
		int 21h
		jc salir
	endm 
	LeerArchivo macro numbytes,databuffer,handle 
		mov ah,3fh 
		mov bx,handle
		mov cx,numbytes
		lea dx,databuffer
		int 21h
		jc salir
	endm 
	EscribirFichero macro numbytes,databuffer,handle 
	  mov ah,40h 
	  mov bx,handle 
	  mov cx,numbytes 
	  lea dx,databuffer 
	  int 21h
	  jc salir
	endm 
	EscribirFichero2 macro databuffer,handle
		local AAA,fichero
		xor si,si
		xor ax,ax
		AAA:
		mov al,databuffer[si]
		cmp al,36
		je fichero
		inc si
		jmp AAA
		fichero:
		EscribirFichero si,databuffer,handle
	endm
	Comparar macro Contenido,Usuario,Pass,TamCont,score,bandera
		local VerificarUsuario,VerificarUsuario1,M,Min,EsBasura,VerificarPass,VerificarP2,EsBasura2,Aceptado,NoEsIgual,NoEsIgual2,FinContenido,Fn
		xor si,si
		xor di,di 
		mov cx,0
		VerificarUsuario:
			cmp cx, 1000
			je FinContenido
			mov al, Contenido[si]
			cmp al,Usuario[di]
			jne NoEsIgual
			inc si
			inc di
			inc cx
			cmp Contenido[si],44			; Es una coma 
			je VerificarPass
			cmp Contenido[si],24h			; es un $
			je EsBasura
			jmp VerificarUsuario

		VerificarUsuario1:
			cmp cx, 1000
			je FinContenido
			inc si
			inc cx
			mov al,Contenido[si]
			cmp al,65
			ja M
			jmp VerificarUsuario1
			M:
			cmp al,91
			jb VerificarUsuario
			cmp al,97
			ja Min
			jmp VerificarUsuario1
			Min:
			cmp al,123
			jb VerificarUsuario
			jmp VerificarUsuario1
		EsBasura:
			cmp cx, 1000
			je FinContenido
			inc si
			inc cx
			mov al, Contenido[si]
			cmp al,24h				;Es un $
			je EsBasura
			cmp al, 2ch				; Es una coma
			je VerificarPass
			cmp al,3Bh				; Es un punto y coma
			je NoEsIgual             ; cambiar a buscar otro usuario 
		VerificarPass:
			cmp cx, 1000
			je FinContenido
			xor di,di
			inc si
			inc cx
		VerificarP2:
			cmp cx, 1000
			je FinContenido
			mov al, Contenido[si]
			cmp al,Pass[di]
			jne NoEsIgual2
			inc si 
			inc cx
			inc di
			mov al,Contenido[si]
			cmp al,44			; Es una Coma
			je Aceptado
			cmp al,24h				;  Es una $
			je EsBasura2
			jmp VerificarP2
		EsBasura2:	
			inc si
			inc cx
			mov al, Contenido[si]
			cmp al,24h
			je EsBasura2
			cmp al,3bh				; Es un punto y coma
			je Aceptado
		Aceptado:
			xor di,di
			inc si
			mov al,score[di]
			mov Contenido[si],al
			inc si
			inc di
			mov al,score[di]
			mov Contenido[si],al
			inc si
			inc di
			mov al,score[di]
			mov Contenido[si],al
			mov ax,bandera
			cmp ax,0
			je Fn
			jmp Prejuego
		NoEsIgual2:
			Imprimir MsgPassErroneo
			xor si,si
			xor di,di
			jmp FN
		NoEsIgual:
			xor di,di
			cmp cx, 1000
			je FinContenido
			inc si
			inc cx
			mov al, Contenido[si]
			cmp al, 3Bh				;Es un punto y coma
			je VerificarUsuario1
			jmp NoEsIgual
		FinContenido:
			Imprimir msgUsuErr
			xor si,si
			xor di,di
		Fn:
	endm
	LeerUsuario macro cadena
		local TECLA,Fin,EsA,EsD,EsM, EsII, EsN
		mov ah,01h                     ;lee un caracter del dispositivo de entrada
	    int 21h
	    cmp al,61h				;---------------a
	    je EsA
	    cmp al,0dh          ;ascii del \n
	    je Fin
	    mov cadena[si],al
	    inc si
	    jmp TECLA
		TECLA:
			mov ah,01h                     ;lee un caracter del dispositivo de entrada
	    	int 21h
		    cmp al,0dh          ;ascii del \n
		    je Fin
		    mov cadena[si],al
		    inc si
		    jmp TECLA
	    EsA:
	    	mov cadena[si],al
		    inc si
	    	mov ah,01h                     ;lee un caracter del dispositivo de entrada
		    int 21h
		    cmp al,64h				;---------------d
		    je EsD
		    cmp al,0dh          ;ascii del \n
		    je Fin
		    mov cadena[si],al
		    inc si
		    jmp TECLA
		EsD:
			mov cadena[si],al
		    inc si
	    	mov ah,01h                     ;lee un caracter del dispositivo de entrada
		    int 21h
		    cmp al,6Dh				;---------------m
		    je EsM
		    cmp al,0dh          ;ascii del \n
		    je Fin
		    mov cadena[si],al
		    inc si
		    jmp TECLA
		EsM:
			mov cadena[si],al
		    inc si
	    	mov ah,01h                     ;lee un caracter del dispositivo de entrada
		    int 21h
		    cmp al,69h				;---------------i
		    je EsII
		    cmp al,0dh          ;ascii del \n
		    je Fin
		    mov cadena[si],al
		    inc si
		    jmp TECLA
		EsII:
			mov cadena[si],al
		    inc si
	    	mov ah,01h                     ;lee un caracter del dispositivo de entrada
		    int 21h
		    cmp al,6Eh				;---------------n
		    je EsN
		    cmp al,0dh          ;ascii del \n
		    je Fin
		    mov cadena[si],al
		    inc si
		    jmp TECLA
		EsN:
			mov cadena[si],al
		    inc si
	    	mov ah,01h                     ;lee un caracter del dispositivo de entrada
		    int 21h
		    cmp al,0dh          ;ascii del \n
		    je ValidarPassAdm
		    mov cadena[si],al
		    inc si
		    jmp TECLA
		Fin:
		    xor si,si
	endm
	LeerPass macro cadena
		local ,TECLA,Es1,es2,Es3,es4,Fin
		mov ah,01h                     ;lee un caracter del dispositivo de entrada
	    int 21h
	    cmp al,31h				;---------------a
	    je Es1
	    cmp al,0dh          ;ascii del \n
	    je Fin
	    mov cadena[si],al
	    inc si
	    jmp TECLA
		TECLA:
			mov ah,01h                     ;lee un caracter del dispositivo de entrada
	    	int 21h
		    cmp al,0dh          ;ascii del \n
		    je Fin
		    mov cadena[si],al
		    inc si
		    jmp TECLA
	    Es1:
	    	mov cadena[si],al
		    inc si
	    	mov ah,01h                     ;lee un caracter del dispositivo de entrada
		    int 21h
		    cmp al,32h				;---------------d
		    je Es2
		    cmp al,0dh          ;ascii del \n
		    je Fin
		    mov cadena[si],al
		    inc si
		    jmp TECLA
		Es2:
			mov cadena[si],al
		    inc si
	    	mov ah,01h                     ;lee un caracter del dispositivo de entrada
		    int 21h
		    cmp al,33h				;---------------m
		    je Es3
		    cmp al,0dh          ;ascii del \n
		    je Fin
		    mov cadena[si],al
		    inc si
		    jmp TECLA
		Es3:
			mov cadena[si],al
		    inc si
	    	mov ah,01h                     ;lee un caracter del dispositivo de entrada
		    int 21h
		    cmp al,34h				;---------------i
		    je Es4
		    cmp al,0dh          ;ascii del \n
		    je Fin
		    mov cadena[si],al
		    inc si
		    jmp TECLA
		Es4:
			mov cadena[si],al
		    inc si
	    	mov ah,01h                     ;lee un caracter del dispositivo de entrada
		    int 21h
		    cmp al,0dh          ;ascii del \n
		    je EtiquetaReportes
		    mov cadena[si],al
		    inc si
		    jmp TECLA
		Fin:
		    xor si,si
	endm
	leerTeclado macro cadena
		local TECLA,Fin
		TECLA:
			mov ah,01h                     ;lee un caracter del dispositivo de entrada
	    	int 21h
		    cmp al,0dh          ;ascii del \n
		    je Fin
		    mov cadena[si],al
		    inc si
		    jmp TECLA

		Fin:
		    xor si,si
	endm
	LimpiarCadena macro cadena
		local Seguir,FinL
		xor si,si
		mov cx,0
		Seguir:
			cmp cx,10
			je FinL
			mov cadena[si],24h
			inc si
			inc cx
			jmp Seguir
		FinL:
			xor si,si
	endm
	GRAPH MACRO             ;iniciamos modo gráfico
         MOV AH,00H
         MOV AL,13H
         INT 10H
	ENDM
	leerTecla macro 
		local TECLA,FinTeclado,Arriba,Abajo,FinTecla,din,din3,PintA,d1,d2,PintB,da1,db1,pintC,sal,cmpArriba,cmpAbajo,CmpNormal
		TECLA:
			mov ah,01h			;  obtenemos el el del teclado. 
			int 16h										
			jz FinTecla		;No se ha pulsado niguna tecla.
			mov ah,0           
			int 16h				 
			cmp al,0 
			jne FinTecla	
			cmp ah,48h  		;Compara con flecha arriba. 
			je Arriba 
			cmp ah,50h			;Compara con flecha abajo. 
			je Abajo 
			cmp ah,4dh			;Compara con flecha derecha. 
			je Menu 
		;dino posiciones 1=normal, 2=Arriba,3 = abajo
		Arriba:
	 		cmp DinoN,3
	 		je FinTeclado
	 		cmp DinoA,1
	 		je din
	 		cmp DinoA,3
	 		je din3
		 	PintA:
		 		ChocqueNormal limxIN,limxSN,limyIP,limySP
		 		PintarDino 130,0fh		; pinto dino a partir del pixel 20
		 		mov DinoA,2
		 		mov dinoN,2
		 		jmp Sal
			 	din:
			 		PintarDino 157,00h
			 		jmp PintA
			 	din3:
			 		DinoAgachado 00h
			 		jmp PintA
	 	Abajo:
	 		cmp dinoN,2
	 		je FinTeclado  
	 		cmp DinoA,1
	 		je d1
	 		cmp DinoA,2
	 		je d2
	 		PintB:
	 			ChocqueNormal limxIA,limxSA,limyIA,limySA
		 		DinoAgachado 0fh
		 		mov DinoA,3
		 		mov dinoN,3
		 		jmp Sal
		 		d1:
			 		PintarDino 157,00h
			 		jmp PintB
			 	d2:
			 		PintarDino 130,00h
			 		jmp PintB
		FinTeclado:
			ChocqueNormal limxIN,limxSN,limyIN,limySN
		 	cmp DinoA,2
		 	je da1
		 	cmp DinoA,3
		 	je db1
		 	PintC:
 			PintarDino 157,0fh
 			mov DinoA,1
 			mov dinoN,1
 			jmp Sal
 			da1:
 				PintarDino 130,00h
 				jmp pintC
 			db1:
 				DinoAgachado 00h
 				jmp pintC
 		FinTecla:  
 			cmp dinoN,1
 			je CmpNormal
 			cmp dinoN,2
 			je cmpArriba
 			cmp dinoN,3
 			je cmpAbajo
 		CmpNormal:
 			ChocqueNormal limxIN,limxSN,limyIN,limySN
 			jmp Sal
 		cmpArriba:
 			ChocqueNormal limxIN,limxSN,limyIP,limySP
 			jmp Sal
 		cmpAbajo:
 			ChocqueNormal limxIA,limxSA,limyIA,limySA
 			jmp Sal
 		Sal:  
	endm
	Info macro
		Convertir punteo,puntos
		mov ah,01h
		mov ch,0
		mov cl,0
		int 10h
		mov ah,02h			
		mov bh,0				
		mov dl,1	
		mov dh,1	
		mov bl,07h
		int 10h
		Imprimir MsgUsuario
		Imprimir Usuario
		Imprimir msgEspacio
		Imprimir msgEspacio
		Imprimir msgEspacio
		Imprimir MsgPuntos
		Imprimir puntos	
		Imprimir msgEspacio
		Imprimir msgEspacio
	endm
	Reporte1 macro buffer,Res
		LimpiarCadena Res
		xor si,si
		xor di,di
		loopRepo1:
			mov al,buffer[di]
			cmp al,24h
			je FnRepo1
			cmp al,2ch
			je Pass2
			mov Res[si],al
			inc si
			inc di
			jmp loopRepo1
		Pass2:
			Imprimir MsgUsuario
			Imprimir Res
			LimpiarCadena Res
			inc di
			LoopPasR1:
				mov al,buffer[di]
				cmp al,24h
				je FnRepo1
				cmp al,2ch
				je Descartar
				mov Res[si],al
				inc si
				inc di
				jmp LoopPasR1
			Descartar:
				Imprimir MsgPass
				Imprimir Res
				LimpiarCadena Res
				inc di
				D2:
					mov al,buffer[di]
					cmp al,24h
					je FnRepo1
					cmp al,3bh
					je loopRepo12
					inc di
					jmp D2
			loopRepo12:
				inc di
				inc di
				inc di
				jmp loopRepo1



		FnRepo1:
	endm



