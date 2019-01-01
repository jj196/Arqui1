	Texto Macro
		mov ax,0003h    
		int 10h
		mov ax,@data
		mov ds,ax
	endm
	PALETA MACRO color      ;Permite definir la paleta
         MOV AH,0BH
         MOV BH,00H
         MOV BL,color
         INT 10H
    ENDM
	PUNTO MACRO x,y,color
		 MOV CX,x
         MOV AH,0CH
         MOV AL,color    ;Color 
         MOV BH,0            
         MOV DX,y
         INT 10H
	ENDM
	PintarRango macro x,y,yf,color
		local R1,fnPR
		xor cx,cx
		xor dx,dx
		mov cx,x
 		mov dx,y
		R1:
			cmp dx,yf
			jg fnPR
			PUNTO cx,dx,color
			add dx,1
			jmp R1
		fnPR:
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx
	endm
	PintarDino macro posY, color
		PintarRango 20,posY+11,posy+19,color
		PintarRango 21,posY+11,posY+19,color
		PintarRango 22,posY+14,posY+20,color
		PintarRango 23,posY+15,posY+21,color
		PintarRango 24,posY+16,posY+22,color
		PintarRango 25,posY+16,posY+23,color
		PintarRango 26,posY+16,posY+26,color
		PintarRango 27,posY+16,posY+30,color
		PintarRango 28,posY+16,posY+30,color
		PintarRango 29,posY+15,posY+26,color
		PintarRango 29,posY+29,posY+30,color
		PintarRango 30,posY+14,posY+25,color
		PintarRango 30,posY+29,posY+30,color
		PintarRango 31,posY+13,posY+23,color
		PintarRango 32,posY+12,posY+25,color
		PintarRango 33,posY+11,posY+25,color
		PintarRango 34,posY,posY+30,color
		PintarRango 35,posY,posY+30,color
		PintarRango 36,posY,posY+2,color
		PintarRango 36,posY+5,posY+22,color
		PintarRango 36,posY+29,posY+30,color
		PintarRango 37,posY+29,posY+30,color
		PintarRango 37,posY,posY+2,color
		PintarRango 37,posY+5,posY+21,color
		PintarRango 38,posY,posY+19,color
		PintarRango 39,posY,posY+10,color
		PintarRango 39,posY+15,posY+16,color
		PintarRango 40,posY+15,posY+16,color
		PintarRango 40,posY,posY+10,color
		PintarRango 41,posY,posY+6,color
 		PintarRango 41,posY+9,posY+10,color
		PintarRango 41,posY+15,posY+18,color
		PintarRango 42,posY,posY+6,color
	 	PintarRango 42,posY+9,posY+10,color
		PintarRango 42,posY+15,posY+18,color
		PintarRango 43,posY,posY+6,color
 		PintarRango 43,posY+9,posY+10,color
		PintarRango 44,posY,posY+6,color
	 	PintarRango 44,posY+9,posY+10,color
		PintarRango 45,posY,posY+6,color
	 	PintarRango 45,posY+9,posY+10,color
		PintarRango 46,posY,posY+6,color
	 	PintarRango 47,posY,posY+6,color
	 	PintarRango 48,posY+1,posY+6,color
	endm
	RETARDO macro TIEMP
		local RE0,RE1,RET2
	    MOV SI,TIEMP
	    RE0:
	      MOV DI, TIEMP
	    RE1:
	      DEC DI
	      JNZ RE1
	      DEC SI
	      JNZ RE0
	    RET2:
	    Info
	endm
	DinoAgachado macro color
		;x 30, y 160
		PintarRango 20,175,177,color
		PintarRango 21,176,178,color
		PintarRango 22,176,179,color
		PintarRango 23,177,180,color
		PintarRango 24,177,181,color
		PintarRango 25,177,182,color
		PintarRango 25,184,186,color
		PintarRango 26,176,183,color
		PintarRango 26,186,186,color
		PintarRango 27,176,183,color
		PintarRango 28,176,187,color
		PintarRango 29,176,185,color
		PintarRango 29,187,187,color
		PintarRango 30,176,184,color
		PintarRango 30,187,187,color
		PintarRango 31,176,183,color
		PintarRango 32,176,183,color
		PintarRango 33,176,183,color
		PintarRango 34,176,185,color
		PintarRango 35,178,183,color
		PintarRango 35,185,185,color
		PintarRango 36,178,182,color
		PintarRango 37,178,182,color
		PintarRango 38,177,183,color
		PintarRango 39,176,183,color
		PintarRango 40,176,177,color
		PintarRango 40,179,183,color
		PintarRango 41,176,183,color
		PintarRango 42,176,183,color
		PintarRango 43,176,181,color
		PintarRango 43,183,183,color
		PintarRango 44,176,181,color
		PintarRango 44,183,183,color
		PintarRango 45,176,181,color
		PintarRango 45,183,183,color
		PintarRango 46,176,181,color
		PintarRango 46,183,183,color
		PintarRango 47,177,181,color
		PintarRango 47,183,183,color
	endm
	PintarHorizontal macro  posx,posxf,posY,color
		local V1,fnV
		xor cx,cx
		xor dx,dx
 		mov cx,posX
 		mov dx,posY
		V1:
			cmp cx,posxf
			jg fnV
			PUNTO cx,dx,color
			add cx,1
			jmp V1
		fnV:
			xor ax,ax
			xor bx,bx
			xor cx,cx
			xor dx,dx
	endm
	ChocqueNormal macro lix,lsx,liy,lsy
		local PintarY,PintarX,FinFondo
		xor dx,dx
		mov dx,liy
		PintarY:
			xor cx,cx
			mov cx,lix
			cmp dx,lsy
			ja FinFondo
			inc dx
		PintarX:
			cmp cx,lsx
			ja PintarY
			mov ah,0dh
			mov bh,0
			int 10H
			inc cx
			cmp al,00H
			je PintarX
			cmp al,0fh
			je PintarX
			jmp Colision2 
		FinFondo:
	endm
	ColisionN macro arr
	 	local Choco,CompararP,Cmp2
		xor ax,ax
		mov cx,arr[0]
		mov dx,170
		CompararP:
			cmp cx,40
			je choco
			inc cx
			Cmp2:
			cmp dx,187
			jg CompararP
			mov ah,0dh
			mov bh,0
			int 10H
			inc dx
			cmp al,00H
			je Cmp2
			cmp al,0fh
			je Cmp2
			jmp Colision2
		Choco:
	endm
