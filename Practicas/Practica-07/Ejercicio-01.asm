	.data
a:		.word	5			# Argumento preestablecido a con int de 5
b:		.word	4			# Argumento preestablecido b con int de 4
resultado: 	.asciiz "El resultado es: " 	# Mensaje con el resultado del programa
	.text
	.globl main
main:	
    	## Invocaci�n de mist_1
	lw	$a0, a			# 1. Cargamos desde la memoria el valor de "a" en $a0
	lw 	$a1, b			# 2. Cargamos desde la memoria el valor de "b" en $a1
	jal	mist_1			# 3. Invocaci�n de mist_1 	
    	## Retorno de mist_1
    	move   	$a1, $v0		# 2. Guardamos el argumento en $a1 para que no afecte el resultado
	## Conclusi�n main
	li 	$v0, 4			# 1. Cargamos el int 4 en $v0 para imprimir un <int>
	la 	$a0, resultado		# 2. Cargamos el mensaje de resultado en el argumento de syscall
	syscall				# 3. Llamamos a syscall
    	li  	$v0, 1      		# 4. Cargamos el int 1 en $v0 para imprimir un <int>
    	move 	$a0, $a1		# 5. Copiamos el resultado del programa en el argumento de syscall
    	syscall         		# 6. Llamamos a syscall e imprimimos
    	li  	$v0, 10     		# 7. Cargamos el int 10 en $v0 para salir del programa
    	syscall				# 8. Llamos a syscall
# mist_1 recibe como argumentos $a0 y $a1
mist_1:	
	## Pre�mbulo mist_1
	addi	$sp, $sp, -8		# 1. Reservamos espacio en la pila 
	sw	$ra, 0($sp)     	# 2. Guardamos la direcci�n de $ra en la pila 
	sw	$s0, 4($sp)     	# 3. Guardamos la direcci�n de $s0 en la pila
	move	$s0, $a0		# 4. Guardamos el primer argumento en $s0
	move	$t0, $a1		# 5. Guardamos el segundo argumento en $t0
	li	$t1, 1			# 6. Cargamos el int 1 en $t1	
loop_1:	
	beqz	$s0, end_1
#	beqz 	$t0, end_1  		# Esta l�nea se podr�a agregar si se genera un bucle cuando b es cero
	## Invocaci�n de mist_0
	move	$a0, $t0		# 1. Se pasa el argumento $a0
	move	$a1, $t1		# 2. Se pasa el argumento $a1
	jal	mist_0			# 3. Invocaci�n de mist_0
	## Retorno de mist_0
	move	$t1, $v0		# 1. Guardamos el resultado de $v0 en $t1
	subi	$s0, $s0, 1		# 2. Restamos 1 a $s0
	j	loop_1			# 3. Invocaci�n de loop_1
end_1:	
	## Conclusi�n mist_1
	move	$v0, $t1		# 1. Se retorna el resultado en $v0
	lw	$ra, 0($sp)		# 2. Cargamos la direcci�n de $ra en la pila
	lw	$s0, 4($sp) 		# 3. Cargamos la direcci�n $s0 en la pila
	addi	$sp, $sp, 8 		# 4. Liberamos espacio de la pila
	jr	$ra			# 5. Fin de la subrutina
# mist_0 recibe como arguementos $a0 y $a1
mist_0:	
	## Pre�mbulo mist_0
	mult	$a0, $a1		# 1. Multiplicamos los argumentos $a0 y $a1 
	## Conclusi�n mist_0
	mflo	$v0			# 2. Se retorna el resultado en $v0
	jr $ra				# 3. Retornamos el control
