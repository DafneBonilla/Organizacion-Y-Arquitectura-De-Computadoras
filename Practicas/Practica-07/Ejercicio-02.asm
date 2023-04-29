.data
bienvenida: .asciiz "Calcularemos el coeficiente binomial. De n, elige k.\n"
preguntan:  .asciiz "Ingresa un entero positivo para n: "
preguntak:  .asciiz "Ingresa un entero positivo para k: "
resultado:  .asciiz "El resultado es: "

.text
.globl main

main:

	# Imprimimos bienvenida:
	li $v0, 4
	la $a0, bienvenida
	syscall
	
	# Solicitamos el valor de n:
	li $v0, 4
	la $a0, preguntan
	syscall
	li $v0, 5
	syscall
	
	# Almacenamos en $a1 el valor de n:
	move $a1, $v0
	
	# Solicitamos el valor de k:
	li $v0, 4
	la $a0, preguntak
	syscall
	li $v0, 5
	syscall
	
	# Almacenamos en $a0 el valor de k:
	move $a0, $v0
	
	beqz $a1, check1 # Se revisar� si n == 0, en este caso se revisar� en check1 si k > 0, pues el resultado ser� 0.
	continuar:
	# Saltamos a la ejecuci�n de coef. En registro tenemos $a0 = k(segundo input), $v0 = k (segundo input) $a1 = n(primer input)
	jal coef
	
	# Se ha terminado la ejecuci�n recursiva, se devolver� el resultado almacenado en $v1, se imprime y se termina el programa.
	li $v0, 4
	la $a0, resultado
	syscall
	li $v0, 1
	move $a0, $v1
	syscall	
	
	li $v0, 10
	syscall
	
coef:

	# Pre�mbulo
	addi $sp, $sp, -16 # Reservamos 4 palabras.
	sw $ra, 0($sp) # Guardar el contenido de $ra en la primera palabra del stack
	sw $a0, 4($sp) # Guardar el contenido de $a0 (k) en la segunda palabra
	sw $a1, 8($sp) # Guardar el contenido de $a1 (n) en la tercera palabra
	sw $s0, 12($sp) # Guardar la direccion de reg, en la cuarta palabra
	
	# Casos base:
	beq $a0, $zero, coef_regreso # Si k == 0, se sumar� 1 a $v1
	beq $a0, $a1, coef_regreso   # Si k == n, se sumar� 1 a $v1
	# Cuando se llega al final de esta subrutina, se entra a coef_regreso, en estos
	# casos, se verificar� si la entrada a coef_regreso fue por la invocaci�n desde las
	# l�neas 63 o 64 (casos base) y no porque es el siguiente bloque por ejecutar. En
	# caso de que sea lo primero, se sumar� 1 a $v1, pues es lo que se hace en los casos
	# base. De lo contrario, la entrada a coef_regreso significa �nicamente que regresaremos
	# a la llamada recursiva anterior a la ejecuci�n de coef que justo termin�; en este caso
	# no se sumar� 1 a $v1, ya que no entramos a coef_regreso por los casos base.
	
	# Ejecuci�n del coeficiente binomial
	addi $sp, $sp, -8 # Reservamos espacio para dos nuevas palabras, aunque s�lo usaremos el valor de n-1
	sub $a1, $a1, 1
	
	jal coef # Se calcula el coef binomial de n-1 y k
	
	addi $sp, $sp, 8 # Borramos las palabras que creamos
	lw $s0, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	
	addi $sp, $sp, -8 # Reservamos espacio para dos nuevas palabras, los valores de k-1 y n-1
	sub $a0, $a0, 1
	sub $a1, $a1, 1
	
	jal coef # Se calcula el coef binomial de n-1 y k-1
	
	addi $sp, $sp, 8 # Borramos las palabras que creamos
	lw $s0, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	
coef_regreso:
	# Conclusion
	lw $s0, 12($sp)
	lw $a1, 8($sp)
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	# A continuaci�n se comprueba que la entrada a coef_regreso es debido a los casos bases y no a la ejecuci�n despu�s
	# de las l�neas finales de coef (las l�neas 90-93), en caso de entrar debido a los casos bases, se comprueba a
	# continuaci�n y se sumar� uno a $v1, en caso contrario, simplemente se eliminar� el marco con addi y 16 y luego
	# se regresar� a la subrutina invocadora con jr $ra.
	beq $a0, $zero, suma_uno # Se comprueba que se debe sumar 1 a $v1
	beq $a0, $a1, suma_uno   # Se comprueba que se debe sumar 1 a $v1
	k_going: # Se salta aqu� desde suma_uno
	addi $sp, $sp, 16
	
	jr $ra

check1: # n == 0, entonces se revisa si k > 0, en este caso, se terminar� el programa y se devolver� 0 como resultado.
	bgtz $a0, end
	j continuar # Si n == 0 pero k == 0, se continuar�. Se ejecutar� coef con n == 0 y k == 0, lo que devolver� 1 como resultado.

end: # Se imprimir� 0 como resultado y se terminar� el programa.
	li $v0, 4
	la $a0, resultado
	syscall
	li $v0, 1
	move $a0, $zero
	syscall	
	
	li $v0, 10
	syscall

suma_uno: # Se suma 1 al resultado y se regresa a coef_regreso, para despu�s retornar a la llamada de la rutina invocadora con jr $ra
	addi $v1, $v1, 1
	j k_going