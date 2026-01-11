INCLUDE Irvine32.inc

.data
	msg27 byte "=================================================", 0
	msg byte "       Welcome to CarSys Showroom Software",0
	msg0 byte "Main menu",0
	msg1 byte "1. Purchase Car",0
	msg2 byte "2. Sell Car",0
	msg3 byte "3. Display Car details",0
	msg4 byte "4. Profit/Loss report",0
	msg5 byte "5. Exit",0
	msg6 byte "Enter option(1-5): ",0
	msg7 byte "Enter id to sell: ", 0
	msg8 byte "Enter car condition (1-10): ",0
	msg9 byte "Enter car model: ",0
	msg10 byte "Enter car price: ",0
	msg11 byte "|Car ID:",0
	msg12 byte "|Car Model:",0
	msg13 byte "|Price:",0
	space byte "|",0
	msg14 byte "Condition of car below 6 is not acceptable!",0
	msg15 byte "Offer too high! Enter new price: ", 0
	msg16 byte "This offer is not accepted",0
	msg17 byte "The showroom is in LOSS of : ",0 
	msg18 byte "The showroom is in PROFIT of : ",0 
	msg19 byte "No Profit No Loss.",0 
	msg20 byte "Total Budget of Showroom : 10000000",0 
	msg21 byte "Budget After Purchases : ",0 
	msg22 byte "Enter a valid option!",0
	msg23 byte "Enter a valid car condition!",0
	msg24 byte "Enter a valid car model!",0
	msg25 byte "Cant purchase! Price out of budget.", 0
	msg26 byte "Car ID not found!",0
	msg28 byte "Car purchased successfully!", 0
	msg29 byte "Car sold successfully!", 0
	msg30 byte "No Cars to display!", 0
	msg31 byte "Enter a valid price!", 0

	carId Dword 10 DUP (0)
	carModel byte 10*20 DUP(?)
	carCondition dword 10 DUP(?)
	purchasePrice dword 10 DUP(?)
	salesPrice dword 10 DUP(?)
	bufferModel BYTE 20 DUP(0)

	NumCar dword ?
	condition dword ?
	carName dword ?
	purPrice dword ?
	index dword ?
	const_BUDGET EQU 10000000
	Budget DWORD 10000000
	hConsole HANDLE ?  
	display1 dword ?

.code

main PROC
	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov hConsole, eax

	INVOKE SetConsoleTextAttribute, hConsole, 11
	mov edx, OFFSET msg27
	call WriteString
	call crlf

	mov edx,OFFSET msg
	call WriteString
	call Crlf

	mov edx, OFFSET msg27
	call WriteString
	call crlf

mainMenu:
	call crlf
	
	INVOKE SetConsoleTextAttribute, hConsole, 11
	mov edx,OFFSET msg0
	call WriteString
	call Crlf

	INVOKE SetConsoleTextAttribute, hConsole, 15
	mov edx,OFFSET msg1
	call WriteString
	call Crlf

	mov edx,OFFSET msg2
	call WriteString
	call Crlf

	mov edx,OFFSET msg3
	call WriteString
	call Crlf

	mov edx,OFFSET msg4
	call WriteString
	call Crlf

	mov edx,OFFSET msg5
	call WriteString
	call Crlf

	INVOKE SetConsoleTextAttribute, hConsole, 14
	mov edx,OFFSET msg6
	call WriteString
	
	INVOKE SetConsoleTextAttribute, hConsole, 15
	call ReadInt

	cmp eax,1
	je purchase

	cmp eax,2
	je sell

	cmp eax,3
	je display

	cmp eax,4
	je profitLoss

	cmp eax,5
	je done

	INVOKE SetConsoleTextAttribute, hConsole, 12
	mov edx,OFFSET msg22
	call WriteString
	call Crlf

	INVOKE SetConsoleTextAttribute, hConsole, 15
	jmp mainMenu

purchase:
	INVOKE SetConsoleTextAttribute, hConsole, 15

conditionCheck:
	push OFFSET Budget
	
	INVOKE SetConsoleTextAttribute, hConsole, 14
	mov edx,OFFSET msg8
	call WriteString
	
	INVOKE SetConsoleTextAttribute, hConsole, 15
	call ReadInt
	
	cmp eax,10
	jg retry1

	cmp eax,0
	jl retry1

	cmp eax,5
	jle return1

	push eax
	jmp stringCheck

retry1:
	INVOKE SetConsoleTextAttribute, hConsole, 12
	mov edx,OFFSET msg23
	call WriteString
	call crlf

	INVOKE SetConsoleTextAttribute, hConsole, 15
	jmp conditionCheck

stringCheck:
validateModel:
	INVOKE SetConsoleTextAttribute, hConsole, 14
    mov edx,OFFSET msg9
    call WriteString

	INVOKE SetConsoleTextAttribute, hConsole, 15
    mov edx, OFFSET bufferModel
    mov ecx, 20
    call ReadString       

    cmp eax,0              
    je invalidModel

    mov esi, OFFSET bufferModel
    mov ecx, eax

checkSpaces:
    mov bl,[esi]
    cmp bl,' '             
    jne checkDigitStart

    inc esi
    loop checkSpaces

    jmp invalidModel     

checkDigitStart:
    mov esi, OFFSET bufferModel
    mov ecx, eax
    mov edi,0              

checkDigits:
    mov bl,[esi]
    cmp bl,'0'
    jl notDigit

    cmp bl,'9'
    jg notDigit

    inc edi     
	
notDigit:
    inc esi
    loop checkDigits

    cmp edi, eax           
    je invalidModel       

    push OFFSET bufferModel
    push eax
    jmp priceCheck

invalidModel:
	INVOKE SetConsoleTextAttribute, hConsole, 12
    mov edx,OFFSET msg24   
    call WriteString
    call Crlf

	INVOKE SetConsoleTextAttribute, hConsole, 15
    jmp validateModel

priceCheck:
	INVOKE SetConsoleTextAttribute, hConsole, 14
	mov edx,OFFSET msg10
	call WriteString

	INVOKE SetConsoleTextAttribute, hConsole, 15
	call ReadInt

	cmp eax, 0
	jle negativePrice

	cmp eax, Budget
	jg outOfBudget

	mov purPrice,eax
	push eax

	call purchaseCar
	jmp mainMenu

negativePrice:
    INVOKE SetConsoleTextAttribute, hConsole, 12
	mov edx, OFFSET msg31
	call WriteString
	call crlf

    INVOKE SetConsoleTextAttribute, hConsole, 15
    jmp priceCheck

outOfBudget:
	INVOKE SetConsoleTextAttribute, hConsole, 12
	mov edx, OFFSET msg25
	call WriteString
	call crlf

	INVOKE SetConsoleTextAttribute, hConsole, 15
	jmp mainMenu

return1:
	INVOKE SetConsoleTextAttribute, hConsole, 14
	mov edx,OFFSET msg14
	call WriteString
	call Crlf

	INVOKE SetConsoleTextAttribute, hConsole, 15
	jmp mainMenu

sell:
	INVOKE SetConsoleTextAttribute, hConsole, 14
	mov edx,OFFSET msg7
	Call WriteString
	
	INVOKE SetConsoleTextAttribute, hConsole, 15
	Call ReadInt
	Push eax
	call sellCar
	jmp mainMenu

display:
	mov display1, 0
	call displayCar
	jmp mainMenu

profitLoss:
	call profitLossReport
	jmp mainMenu

done:
	INVOKE SetConsoleTextAttribute, hConsole, 15
	exit
main ENDP


purchaseCar PROC
    Enter 0,0

    mov esi, 0

findSlot:
    cmp esi, 10          
    jge purchaseEnd  
	
    mov eax, [carId + esi*TYPE carId]
    cmp eax, 0
    je slotFound

    inc esi
    jmp findSlot

slotFound:
    mov index, esi           
   
    mov eax, [ebp+20]
	cmp eax,10
	jl callBargain

acceptVehicle:
    mov [carCondition + esi*4], eax
	
    mov edi, OFFSET carModel
    mov ebx, esi
    imul ebx, 20             
    add edi, ebx             

    mov esi, OFFSET bufferModel 
    mov ecx, 20              
    rep movsb

    mov byte ptr [edi], 0    

	mov eax, [ebp+8]        
	mov ebx, index
	imul ebx, 4               
	mov [purchasePrice + ebx], eax  
	
	mov eax, [purchasePrice + ebx]
	add eax, 10000
	mov [salesPrice + ebx], eax

	mov eax, Budget
    sub eax, [purchasePrice + ebx]
    mov Budget, eax

    mov eax, index
    add eax, 100
    mov [carId + ebx], eax

	INVOKE SetConsoleTextAttribute, hConsole, 10
	mov edx, OFFSET msg28
	call WriteString 
	call crlf

	INVOKE SetConsoleTextAttribute, hConsole, 15
	jmp purchaseEnd

callBargain:
	Call bargainPrice
	cmp eax,0
	je notAccepted

	mov [ebp+8],eax
	jmp acceptVehicle

notAccepted:
	INVOKE SetConsoleTextAttribute, hConsole, 14
	mov edx,OFFSET msg16
	call WriteString
	call Crlf

	INVOKE SetConsoleTextAttribute, hConsole, 15

purchaseEnd:
    leave
    ret 12
purchaseCar ENDP


sellCar PROC
	Enter 0,0

	Mov eax,[ebp+8]
	Mov esi,0
	Mov ecx,10

l3:
	Cmp eax,[carId+esi*TYPE carId]
	Je saleCar

	Inc esi
	Loop l3

	INVOKE SetConsoleTextAttribute, hConsole, 12
	mov edx,OFFSET msg26 
	call WriteString
	call Crlf
	INVOKE SetConsoleTextAttribute, hConsole, 15

	jmp endSell

SaleCar:
	Mov Dword ptr [carId+esi*TYPE carId],0
	Mov eax,[salesPrice+esi*TYPE salesPrice]
	add Budget,eax

	INVOKE SetConsoleTextAttribute, hConsole, 10
	mov edx, OFFSET msg29
	call WriteString 
	call crlf

	INVOKE SetConsoleTextAttribute, hConsole, 15

endSell:
	leave
	ret 4
sellCar ENDP


displayCar PROC
	INVOKE SetConsoleTextAttribute, hConsole, 11
    mov esi,0  
	
displayLoop:
    cmp esi,10           
    jge displayEnd

    mov eax,[carId+esi*TYPE carId]
    cmp eax,0
    je skipDisplay
	
	mov eax, display1
	inc eax
	mov display1, eax

    mov edx,OFFSET msg11
    call WriteString

    mov eax,[carId+esi*TYPE carId]
    call WriteDec

    mov edx,OFFSET msg12
    call WriteString

    mov ebx, esi
    imul ebx, 20

    mov edx, OFFSET carModel
    add edx, ebx
    call WriteString

    mov edx,OFFSET msg13
    call WriteString

    mov eax,[salesPrice+esi*TYPE salesPrice]
    call WriteDec

    mov edx,OFFSET space
    call WriteString
    call Crlf

skipDisplay:
    inc esi
    jmp displayLoop

displayEnd:
	mov eax, display1
	cmp eax, 0
	jnz carFound

	INVOKE SetConsoleTextAttribute, hConsole, 12
	mov edx, OFFSET msg30
	call WriteString
	call crlf

carFound:

	INVOKE SetConsoleTextAttribute, hConsole, 15
    ret 4
displayCar ENDP


profitLossReport PROC
	INVOKE SetConsoleTextAttribute, hConsole, 11
	mov edx, OFFSET msg20
	Call WriteString
	call Crlf

	mov edx,OFFSET msg21
	Call WriteString 

	mov eax,Budget
	call WriteDec
	call Crlf

	mov eax,const_BUDGET
	sub eax,Budget
	mov ebx,eax

	cmp ebx,0
	jg l5
	jl l4

	INVOKE SetConsoleTextAttribute, hConsole, 15
	mov edx, OFFset msg19
	Call WriteString
	call Crlf

	jmp endReport
	
l4:
	INVOKE SetConsoleTextAttribute, hConsole, 10
    mov edx, OFFset msg18
	Call WriteString

	mov eax,ebx
	neg eax
	call WriteDec
	call Crlf

	jmp endReport

l5:
	INVOKE SetConsoleTextAttribute, hConsole, 12
	mov edx, OFFset msg17
	Call WriteString

	mov eax,ebx
	call WriteDec
	call Crlf

endReport:
	INVOKE SetConsoleTextAttribute, hConsole, 15
	ret
profitLossReport ENDP

bargainPrice PROC
	INVOKE SetConsoleTextAttribute, hConsole, 14
	mov edx,OFFSET msg15
	call WriteString

	INVOKE SetConsoleTextAttribute, hConsole, 15
	call ReadInt
	mov ebx, eax

	mov eax,purPrice
	imul eax, 80
	xor edx, edx        
	mov ecx, 100        
	div ecx

	cmp ebx,eax
	jg unaccept

	mov eax,ebx
	jmp endBargain

unaccept:
	mov eax,0 

endBargain:
	ret
bargainPrice ENDP

End main
