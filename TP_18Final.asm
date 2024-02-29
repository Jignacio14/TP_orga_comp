global main
extern puts
extern gets 
extern printf
extern sscanf

section .data

;===============================================
; Segmento mensajes a usuario
;===============================================

    MsjPresentacion db "Bienvenido al TP 18 de Jose Ignacio Castro, Padron: 106957", 0
    MsjOpciones db "Las opciones que tiene disponibles son: ", 0
    MsjOpcion1 db "(1) Queres trabajar con un numero empaquetado", 0
    MsjOpcion2 db "(2) Queres trabajar con BPF con signo", 0
    MsjOpcion3 db "Ingrese: (*) para cerrar el programa", 0
    ErrorOpciones db "Lamento informarte que la opcion escogida no es correcta, ingresa una de las opciones mostradas previamente", 0
    MsjIngresarOpcion db "Ingrese la opcion de conversion o la salida del programa", 0
    MsjSBOpcion1 db "(1) Configuracion binaria de un BPF c/S --> Numero almacenado en base 10", 0
    MsjSBOpcion2 db "(2) Numero en base 10 --> configuracion binaria de dicho numero almacenado como BPF c/s", 0
    MsjSBOpcion3 db "(3) Numero en base 10 --> configuracion en base 4 de dicho numero almacenado como BPF c/s", 0
    MsjSBOpcion4 db "(4) Numero en base 10 --> configuracion octal de dicho numero almacenado como BPF c/s", 0
    MsjSBCDpcion1 db "(1) Configuracion hexadecimal de un BCD --> Numero almacenado en base 10", 0
    MsjSBCDpcion2 db "(2) Numero en base 10 --> configuracion binaria de dicho numero almacenado como BCD de 4bits", 0
    MsjSBCDpcion3 db "(3) Numero en base 10 --> configuracion en base 4 de dicho numero almacenado como BCD de 4bits", 0
    MsjSBCDpcion4 db "(4) Numero en base 10 --> configuracion octal de dicho numero almacenado como BCD de 4bits", 0
    MsjErrorSubmenu db "Tu opcion ingresada no es valida, ingrese una vez mas una opcion valida", 0
    MsjNumeroTransformar db "Tomando en cuenta que quiere transformar, adelante, ingrese su numero, por favor:", 0
    MsjErrorBCD db "Su ingreso del BCD no es valido", 0
    MsjErrorIngreso db "Su ingreso decimal no es correcto", 0
    MsjErrorBinario db "Su ingreso del Binario no es valido", 0
    MsjResultado db "Su conversion resulto en: %li", 10, 0
    MsjCambioBase db "La configuracion en base %li de su numero ingresado es:", 10, 0

;===============================================
; Tablas de datos
;===============================================

    TablaNumeros db 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
    TablaCaracteres db "0123456789AB", 0
    TablaOpciones db "1234", 4
    VectorBases dq 10,2,4,8
    FormatoConversion db "%li", 0

;===============================================
; Segmento Datos de utilidad 
;===============================================

    CantCaracteres db 0
    Valido db 'N', 0
    EsNeg db 'N', 0
    CantMaxCaracteres db 0
    Indice db 0
    Resultado dq 0
    Signo dq 1
    Exponente db 0
    Pivote db 0
    Base dq 1
    CharAInt db 0
    IntAChar db 0
    UltimoCaracter db 'A', 0
    BinarioEn10 dq 0
    RutinaCorta db 'N', 0

;===============================================
; Validadores por Defecto
;===============================================


Section .bss

    InputOpcion resb 500
    OpcionMenu resb 1
    InputSubmenu resb 500
    InputNumerico resb 500
    VectorConfiguracion times 64 resb 1
    CadenaConfiguracion times 34 resb 1
    VectorResultado times 32 resb 1

Section .text

;===============================================
; Ejecucion principal
;===============================================

main:

    mov rdi, MsjPresentacion
    sub rsp, 8
    call puts
    add rsp, 8

PresentarMenu:

    sub rsp, 8
    call DesplegarMenu
    add rsp, 8

    cmp byte[InputOpcion], '*'
    je FinPrograma

PresentarSubmenu:

    sub rsp, 8
    call DesplegarSubMenu
    add rsp, 8

ProcesarDecision:

    sub rsp, 8
    call DerivarProceso
    add rsp, 8

    cmp byte[Valido], 'N'
    je PresentarMenu

InterpretarDato:

    sub rsp, 8
    call InterpretarInfo
    add rsp, 8

MostrarResultado:

    sub rsp, 8
    call MostrarResultadoArrojado
    add rsp, 8

FinPrograma:
ret

;===============================================
; Rutinas de interaccion con el usuario
;===============================================

DesplegarMenu:

    mov rdi, MsjOpcion1
    sub rsp, 8
    call puts
    add rsp, 8

    mov rdi, MsjOpcion2
    sub rsp, 8
    call puts
    add rsp, 8

    mov rdi, MsjOpcion3
    sub rsp, 8
    call puts
    add rsp, 8

    mov rdi, MsjIngresarOpcion
    sub rsp, 8
    call puts
    add rsp, 8

    sub rsp, 8
    call SolicitudMenu
    add rsp, 8

ret

SolicitudMenu:

    mov rdi, InputOpcion
    sub rsp, 8
    call gets
    add rsp, 8

ValidarSolicitudMenu:

    cmp byte[InputOpcion], '*'
    je OpcionValidada

    mov byte[OpcionMenu], '1'

    cmp byte[InputOpcion], '1'
    je OpcionValidada

    mov byte[OpcionMenu], '2'

    cmp byte[InputOpcion], '2'
    je OpcionValidada

PrintearMensajeError:

    mov rdi, ErrorOpciones
    sub rsp, 8
    call puts
    add rsp, 8

    jmp SolicitudMenu

OpcionValidada:
ret


DesplegarSubMenu:

    cmp byte[OpcionMenu], '1'
    jne ASubMenuBinario

    sub rsp, 8
    call DesplegarSubMenuBCD
    add rsp, 8

    jmp RealizarPeticionSubmenu

ASubMenuBinario:

    sub rsp, 8
    call DesplegarSubMenuBina
    add rsp, 8

RealizarPeticionSubmenu:

    sub rsp, 8
    call SolicitudSubmenu
    add rsp, 8

ret

DesplegarSubMenuBCD:

    mov rdi, MsjSBCDpcion1
    sub rsp, 8
    call puts
    add rsp, 8

    mov rdi, MsjSBCDpcion2
    sub rsp, 8
    call puts
    add rsp, 8

    mov rdi, MsjSBCDpcion3
    sub rsp, 8
    call puts
    add rsp, 8

    mov rdi, MsjSBCDpcion4
    sub rsp, 8
    call puts
    add rsp, 8

ret

DesplegarSubMenuBina:

    mov rdi, MsjSBOpcion1
    sub rsp, 8
    call puts
    add rsp, 8

    mov rdi, MsjSBOpcion2
    sub rsp, 8
    call puts
    add rsp, 8

    mov rdi, MsjSBOpcion3
    sub rsp, 8
    call puts
    add rsp, 8

    mov rdi, MsjSBOpcion4
    sub rsp, 8
    call puts
    add rsp, 8

ret

SolicitudSubmenu:
PedirDeNuevoSubMenu:

    mov rdi, InputSubmenu
    sub rsp, 8
    call gets
    add rsp, 8

ValidarSolicitudSubmenu:

    cmp byte[InputSubmenu], '1'
    jl MostrarMsjErrorSubM

    cmp byte[InputSubmenu], '4'
    jg MostrarMsjErrorSubM

    jmp FinalValidarSubmenu

MostrarMsjErrorSubM:

    mov rdi, MsjErrorSubmenu
    sub rsp, 8
    call puts
    add rsp, 8

    jmp PedirDeNuevoSubMenu

FinalValidarSubmenu:
ret

;===============================================
; Rutinas logicas 
;===============================================

DerivarProceso:

    mov rdi, MsjNumeroTransformar
    sub rsp, 8
    call puts
    add rsp, 8

    mov rdi, InputNumerico
    sub rsp, 8
    call gets
    add rsp, 8

    cmp byte[InputOpcion], '1'
    jne TratarComoBinario

TratarComoBCD:

    sub rsp, 8
    call RutinaEmpaquetado
    add rsp, 8
    jmp FinTratadoDelDato

TratarComoBinario:
    
    sub rsp, 8
    call RutinaBinario
    add rsp, 8

FinTratadoDelDato:
ret


RutinaEmpaquetado:
    cmp byte[InputSubmenu], '1'
    jne ConvertirBase10ABCD

    sub rsp, 8
    call MostrarContenidoBase10deBCD
    add rsp, 8

    jmp FinalRutinaEmpaquetado

ConvertirBase10ABCD:

    sub rsp, 8
    call DeB10aBCD
    add rsp, 8

FinalRutinaEmpaquetado:
ret

RutinaBinario:

    cmp byte[InputSubmenu], '1'
    jne ValidarIngresoBase10

    sub rsp, 8
    call MostrarContenidoBase10Bpfcs
    add rsp, 8 

    jmp FinalRutinaBinario

ValidarIngresoBase10:

    sub rsp, 8
    call DecABi
    add rsp, 8

FinalRutinaBinario:
ret

InterpretarInfo:

    cmp byte[RutinaCorta], 'S'
    je SoloCambioBase

    sub rsp, 8
    call Interpretar
    add rsp, 8

    mov rdi, MsjResultado
    mov rsi, [Resultado]
    sub rsp, 8
    call printf
    add rsp, 8

    cmp byte[InputSubmenu], '1'
    je FinalInterpretarInfo

SoloCambioBase:

    sub rsp, 8
    call CambioDeBase
    add rsp, 8


FinalInterpretarInfo:
ret

;===============================================
; Rutinas para el BDC
;===============================================


MostrarContenidoBase10deBCD:

    sub rsp, 8
    call ContarCaracteres
    add rsp, 8

    sub rsp, 8
    call ValidarIngresoBCD
    add rsp, 8

    cmp byte[Valido], 'N'
    je BCDNoValido

    sub rsp, 8
    call GenerarFormatoBCD
    add rsp, 8

    jmp FinalMostrarContenidoBCD

BCDNoValido:

    mov rdi, MsjErrorBCD
    sub rsp, 8
    call puts
    add rsp, 8

FinalMostrarContenidoBCD:
ret

ValidarIngresoBCD:

    cmp byte[CantCaracteres], 8
    jg FinalValidarBCD

    cmp byte[CantCaracteres], 2
    jl FinalValidarBCD

    mov rbx, 0
    mov rcx, 0
    mov cl, [CantCaracteres]
    dec rcx

RecorrerBCD:

    mov r10b, [InputNumerico + rbx]

    cmp r10b, '0'
    jl FinalValidarBCD

    cmp r10b, '9'
    jg FinalValidarBCD

    inc rbx
    loop RecorrerBCD

ValidarCaracter:

    mov r10b, [InputNumerico + rbx]

    cmp r10b, 'A'
    jl FinalValidarBCD

    cmp r10b, 'F'
    jg FinalValidarBCD

ValidarFinLinea:

    mov r10b, [InputNumerico + rbx + 1]
    cmp r10b, 0
    jne FinalValidarBCD

    mov byte[Valido], 'S'

FinalValidarBCD:
ret

GenerarFormatoBCD:

    mov byte[CantMaxCaracteres], 8

    sub rsp, 8
    call CompletarCadena
    add rsp, 8

    sub rsp, 8
    call AgregarElementos
    add rsp, 8

    cmp byte[VectorConfiguracion + 7], 'B'
    je BCDnegativo

    cmp byte[VectorConfiguracion + 7], 'D'
    je BCDnegativo

    jmp PrepararValoresBCD

BCDnegativo:

    mov qword[Signo], -1

PrepararValoresBCD:
    
    mov al, [CantMaxCaracteres]
    sub al, 2
    mov byte[Exponente], al
    mov qword[Base], 10

FinGenerarFormatoBCD:
ret

DeB10aBCD:

    sub rsp, 8
    call ValidarEntradaNumerica
    add rsp, 8

    cmp byte[CantCaracteres], 1
    jl ErrorIngresoDecimalABCD

    cmp byte[CantCaracteres], 7
    jg ErrorIngresoDecimalABCD

    cmp byte[Valido], 'N'
    je ErrorIngresoDecimalABCD 

    mov byte[Exponente], 7
    mov byte[CantMaxCaracteres], 7

    sub rsp, 8
    call GenerarBCD
    add rsp, 8

    jmp FinalGenerarBCD

ErrorIngresoDecimalABCD:

    mov rdi, MsjErrorIngreso
    sub rsp, 8
    call puts 
    add rsp, 8

FinalGenerarBCD:
ret


GenerarBCD:

    sub rsp, 8
    call CompletarCadena
    add rsp, 8

    sub rsp, 8
    call AgregarElementos
    add rsp, 8

    sub rsp, 8
    call AgregarAlFinal
    add rsp, 8

    mov qword[Base], 16
    mov byte[CantMaxCaracteres], 8

ret

AgregarAlFinal:

    mov r10b, [UltimoCaracter]
    mov byte[VectorConfiguracion + 7], r10b

ret


;===============================================
; Rutinas para el binario punto fijo con signo
;===============================================

MostrarContenidoBase10Bpfcs:

    sub rsp, 8
    call ContarCaracteres
    add rsp, 8  

    sub rsp, 8
    call ValidarIngresoBinario
    add rsp, 8

    cmp byte[Valido], 'S'
    jne FinalMostrarContenidoBin

    sub rsp, 8
    call GenerarFormatoBinario
    add rsp, 8

FinalMostrarContenidoBin:
ret

ValidarIngresoBinario:

    cmp byte[CantCaracteres], 1
    jl NoEsValidoBinario

    cmp byte[CantCaracteres], 32
    jg NoEsValidoBinario

    mov rcx, 0
    mov cl, [CantCaracteres]
    mov rbx, 0

RecorrerBinario:

    mov r10b, [InputNumerico + rbx]

    cmp r10b, '0'
    jl NoEsValidoBinario

    cmp r10b, '1'
    jg NoEsValidoBinario

    inc rbx
    loop RecorrerBinario

    mov byte[Valido], 'S'

    jmp FinalValidarBinario

NoEsValidoBinario:

    mov rdi, MsjErrorBinario
    sub rsp, 8
    call puts
    add rsp, 8

FinalValidarBinario:
ret

GenerarFormatoBinario:
    mov byte[CantMaxCaracteres], 32

    sub rsp, 8
    call CompletarCadena
    add rsp, 8

    sub rsp, 8
    call AgregarElementos
    add rsp, 8

    cmp byte[VectorConfiguracion], '1'
    jne PrepararValoresBinario

    sub rsp, 8
    call NotMasUno
    add rsp, 8

PrepararValoresBinario:
    mov al, [CantMaxCaracteres]
    dec al
    mov byte[Exponente], al
    mov qword[Base], 2

ret


NotMasUno:

    mov rcx, 32
    mov rbx, 0
    mov qword[Signo], -1
    mov r10b, '0'
    mov r11b, '1'

Conmutar:

    cmp byte[VectorConfiguracion + rbx], '1'
    jne Conmutar1

    mov byte[VectorConfiguracion + rbx], '0'
    jmp ActualizarInfoLoop

Conmutar1:

    mov byte[VectorConfiguracion + rbx], '1'

ActualizarInfoLoop:

    inc rbx
    loop Conmutar
    dec rbx

MasUno:
    cmp byte[VectorConfiguracion + rbx], '0'
    je FinalNotMasUno
    
    mov byte[VectorConfiguracion + rbx], '0'
    dec rbx
    jmp MasUno

FinalNotMasUno:
    mov byte[VectorConfiguracion + rbx], "1"
ret

DecABi:

    sub rsp, 8
    call ValidarEntradaNumerica
    add rsp, 8

    cmp byte[Valido], 'N'
    je PrintearErrorBinario

    mov rdi, InputNumerico
    mov rsi, FormatoConversion
    mov rdx, BinarioEn10
    sub rsp, 8
    call sscanf
    add rsp, 8

    mov byte[Valido], 'N'

    mov rax, [BinarioEn10]

    cmp rax, 2147483647
    jg PrintearErrorBinario

    cmp rax, -2147483648
    jl PrintearErrorBinario

    mov byte[Valido], 'S'

    mov byte[RutinaCorta], 'S'

    mov rax, [BinarioEn10]
    mov qword[Resultado], rax

    jmp FinGenerarBinario

PrintearErrorBinario:

    mov rdi, MsjErrorIngreso
    add rsp, 8
    call puts
    add rsp, 8

FinGenerarBinario:
ret

;===============================================
; Rutinas de conversion de base
;===============================================]

Interpretar:

    mov rbx, 0
    mov r14, 0
    mov r11, 0
    mov r13, [Base]

RecorrerVector:

    mov r10b, [VectorConfiguracion + rbx]
    mov byte[Pivote], r10b

    sub rsp, 8
    call ConvertirCaracter
    add rsp, 8

    mov r9, 1

    mov al, [Exponente]
    cmp al, 0
    je SaltarPotencia 

Potencia:

    imul r9, r13
    dec al
    cmp al, 0
    jg Potencia

SaltarPotencia:

    mov r11b, [CharAInt]
    imul r9, r11
    add r14, r9

    dec byte[Exponente]
    inc rbx

    cmp byte[Exponente], 0
    jge RecorrerVector
    
    mov r13, [Signo]
    imul r14, r13
    mov qword[Resultado], r14

ret

;===============================================
; Rutinas Generales
;===============================================]

ContarCaracteres:
    mov rbx, 0
    mov r10, 0
Contar:
    mov r10b, [InputNumerico + rbx]
    inc rbx

    cmp r10b, 0
    jne Contar
    
    dec rbx
    mov byte[CantCaracteres], bl ; Se elimina del conteo el salto el fin de linea
ret

CompletarCadena:

    mov rcx, 0
    mov rbx, 0

    mov cl, [CantMaxCaracteres]
    sub cl, [CantCaracteres]

    cmp cl, 0 
    je NoNecesitaCompletarse

Completar:
    mov byte[VectorConfiguracion + rbx], '0'
    inc rbx
    loop Completar
    mov byte[Indice], bl

NoNecesitaCompletarse:
ret

AgregarElementos:

    mov rbx, 0
    mov rax, 0
    mov bl, [Indice]

    cmp byte[EsNeg], 'S'
    jne RecorrerYagregar

    inc rax

RecorrerYagregar:

    mov r10b, [InputNumerico + rax]
    mov [VectorConfiguracion + rbx], r10b

    inc rax
    inc rbx

    cmp r10b, 0
    jne RecorrerYagregar

ret

ConvertirCaracter:

    mov rax, 0
ConvertirSiguiente:

    mov r10b, [TablaCaracteres + rax]
    cmp byte[Pivote], r10b
    je CaracterEncontrado

    inc rax
    jmp ConvertirSiguiente

CaracterEncontrado:
    mov r10b, [TablaNumeros + rax]
    mov byte[CharAInt], r10b

ret

ConversorNumerico:

    mov rbx, 0

BuscarNumero:
    mov r10b, [TablaNumeros + rbx]
    cmp byte[Pivote], r10b 
    je NumeroEncontrado

    inc rbx
    jmp BuscarNumero

NumeroEncontrado:

    mov r10b, [TablaCaracteres + rbx]
    mov byte[Pivote], r10b

ret

MostrarResultadoArrojado:

    cmp byte[InputSubmenu], '1'
    jne MostrarCadenaCambioBase

    cmp byte[RutinaCorta], 'S'
    je MostrarCadenaCambioBase

    mov rdi, MsjResultado
    mov rsi, [Resultado]
    sub rsp, 8
    call printf
    add rsp, 8

    jmp FinalPrint  

MostrarCadenaCambioBase:

    mov rdi, MsjCambioBase
    mov rsi, [Base]
    sub rsp, 8
    call printf
    add rsp, 8

    mov rdi, CadenaConfiguracion
    sub rsp, 8
    call puts
    add rsp, 8

FinalPrint:
ret

ValidarEntradaNumerica:

    mov rbx, 0

    sub rsp, 8
    call VerificarSigno
    add rsp, 8

    sub rsp, 8
    call RecorrerCadena
    add rsp, 8

    cmp byte[EsNeg], 'S'
    jne FinalValidarEntrada

    dec byte[CantCaracteres]
    
FinalValidarEntrada:
ret

VerificarSigno:

    cmp byte[InputNumerico + 0], '-'
    jne EsPositivo
    mov rbx, 1
    mov byte[UltimoCaracter], 'B'
    mov byte[EsNeg], 'S'
    
EsPositivo:
ret

RecorrerCadena:

Repetir:
    mov r10b, [InputNumerico + rbx]

    cmp r10b, 0
    je FinalRecorrerCaracter 

    cmp r10b, '0'
    jl Error

    cmp r10b, '9'
    jg Error

    inc rbx

    jmp Repetir

FinalRecorrerCaracter:

    mov byte[CantCaracteres], bl
    mov byte[Valido], "S"

Error:
ret


CambioDeBase:

    sub rsp, 8
    call GenerarBaseDestino
    add rsp, 8

    mov byte[Indice], 0

    sub rsp, 8
    call PasajeDeBase
    add rsp, 8

    sub rsp, 8 
    call InvertirCadena
    add rsp, 8

ret


GenerarBaseDestino:

    mov rbx, 0
    mov r10b, [InputSubmenu]

BuscarBase:

    mov r11b, [TablaOpciones + rbx]
    cmp r11b, r10b 
    je BaseEncontrada

    inc rbx

    jmp BuscarBase

BaseEncontrada:

    imul rbx, 8
    mov r10, [VectorBases + rbx]
    mov qword[Base], r10
ret

PasajeDeBase:

    mov rax, [Resultado]
    mov r11, [Base]

DivisionesSucesivas:
    
    mov rdx, 0
    idiv r11d

    mov byte[Pivote], dl

    sub rsp, 8
    call ConversorNumerico
    add rsp, 8

    sub rsp, 8
    call AgregarElemento
    add rsp, 8

    cmp rax, qword[Base]
    jge DivisionesSucesivas

    mov byte[Pivote], al

    sub rsp, 8
    call ConversorNumerico
    add rsp, 8

    sub rsp, 8
    call AgregarElemento
    add rsp, 8

ret

AgregarElemento:

    mov rbx, 0
    mov bl, [Indice]

    mov r10b, [Pivote]
    mov [VectorResultado + rbx], r10b
    inc byte[Indice]

ret

InvertirCadena:

    mov rbx, 0
    mov rcx, 0
    mov bl, [Indice]
    dec bl

ResultadoFinal:

    mov r11b, [VectorResultado + rbx]
    mov byte[CadenaConfiguracion + rcx], r11b 

    inc rcx
    dec rbx

    cmp rbx, 0
    jge ResultadoFinal

    mov byte[CadenaConfiguracion + rcx + 1], 0

ret