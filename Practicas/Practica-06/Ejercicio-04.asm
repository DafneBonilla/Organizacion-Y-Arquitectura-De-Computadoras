# Ejercicio 4: Obtener el cociente y residuo de una división.

# Definición de variables globales:
.data
prompt1: .asciiz "Introduce el dividendo: "
prompt2: .asciiz "Introduce el divisor: "
result1: .asciiz "El cociente es: "
result2: .asciiz "El residuo es: "
newline: .asciiz "\n"
div_cero: .asciiz "¡No puedes dividir entre cero!"
# Instrucciones para la entrada de datos:
.text
.globl main

main:
# Pide al usuario el dividendo y lo guarda en $s0
	li $v0, 4
	la $a0, prompt1
	syscall
	li $v0, 5
	syscall
	move $s0, $v0

# Pide al usuario el divisor y lo guarda en $s1
	li $v0, 4
	la $a0, prompt2
	syscall
	li $v0, 5
	syscall
	move $s1, $v0

# Inicializa los registros $v0 y $v1 a 0
	li $v0, 0
	li $v1, 0
	
	subi $t0, $s1, 1
	bltz $t0, divi_cero
	# Comienza el bucle de la división
	div_loop:
	# Resta el divisor a $s0 y comprueba si el resultado es negativo
		sub $s0, $s0, $s1
		bltz $s0, div_end

	# Incrementa el cociente en 1
		addi $v0, $v0, 1

	# Salta al principio del bucle
		j div_loop

	# Termina la división
	div_end:
	# Calcula el residuo sumando el divisor al dividendo
		add $s0, $s0, $s1

	# Guarda el residuo en $v1
		move $v1, $s0

# Muestra el resultado por pantalla
	move $t0, $v0 #  Movemos al registro $t0 el cociente, ya que en $v0 necesitamos las instrucciones que syscall ejecutará
	li $v0, 4
	la $a0, result1
	syscall
	li $v0, 1
	move $a0, $t0
	syscall
	li $v0, 4
	la $a0, newline
	syscall
	li $v0, 4
	la $a0, result2
	syscall
	li $v0, 1
	move $a0, $v1
	syscall

# Termina el programa
	li $v0, 10
	syscall
	
	divi_cero:
		li $v0, 4
		la $a0, div_cero
		syscall
		li $v0, 10
		syscall
		

