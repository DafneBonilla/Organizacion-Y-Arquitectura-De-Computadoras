# Ejercicio 2: Calcular el m�ximo com�n divisor de 2 n�meros 

# Definici�n de variables globales:
.data
number_1: .word 0                                # Primer n�mero ingresado por el usuario
number_2: .word 0                                # Segundo n�mero ingresado por el usuario
message_1: .asciiz "Ingrese el primer n�mero: "  # Mensaje para ingresar el primer n�mero
message_2: .asciiz "Ingrese el segundo n�mero: " # Mensaje para ingresar el segundo n�mero
result: .asciiz "El MCD es: "                    # Mensaje con el resultado final 

# Instrucciones para la entrada de datos:
.text
la $a0, message_1   # Imprime el mensaje para ingresar el primer n�mero
li $v0, 4           # Carga el valor 4 en $v0 (syscall para imprimir cadena)
syscall

li $v0, 5           # Carga el valor 5 en $v0 (syscall para leer entero)
syscall
sw $v0, number_1    # Guarda el primer n�mero ingresado en la variable numero_1

la $a0, message_2   # Imprime el mensaje para ingresar el segundo n�mero
li $v0, 4           # Carga el valor 4 en $v0 (syscall para imprimir cadena)
syscall

li $v0, 5           # Carga el valor 5 en $v0 (syscall para leer entero)
syscall
sw $v0, number_2    # Guarda el segundo n�mero ingresado en la variable numero_2

# Instrucciones para cargar los n�meros en registros temporales:
.text
la $t0, number_1    # Carga el primer n�mero en $t0
lw $t0, 0($t0)      # Obtiene el valor de numero_1

la $t1, number_2    # Carga el segundo n�mero en $t1
lw $t1, 0($t1)      # Obtiene el valor de numero_2

# Instrucciones para el c�lculo del MCD usando el algoritmo de Euclides
loop:
bne $t0, $t1, not_equal   # Si t0 != t1, saltar a la etiqueta not_equal
j end_loop                # Si t0 = t1, saltar a la etiqueta end_loop

not_equal:
bgt $t0, $t1, substract   # Si t0 > t1, saltar a la etiqueta t0_gt_t1
sub $t1, $t1, $t0         # Si t0 < t1, restar t0 de t1

j loop                    # Saltar al inicio del loop

substract:
sub $t0, $t0, $t1         # Restar t1 de t0

j loop                    # Saltar al inicio del loop

end_loop:
la $a0, result            # Imprime el mensaje de resultado
li $v0, 4
syscall
move $a0, $t0             # Carga el resultado en $a0
li $v0, 1                 # Carga el valor 1 en $v0 (syscall para imprimir entero)
syscall

# Fin del programa:
li $v0, 10                # Carga el valor 10 en $v0 (syscall para salir del programa)
syscall
