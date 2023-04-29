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
	
	beqz $a1, check1 # Se revisará si n == 0, en este caso se revisará en check1 si k > 0, pues el resultado será 0.
	continuar:
	# Saltamos a la ejecución de coef. En registro tenemos $a0 = k(segundo input), $v0 = k (segundo input) $a1 = n(primer input)
	jal coef
	
	# Se ha terminado la ejecución recursiva, se devolverá el resultado almacenado en $v1, se imprime y se termina el programa.
	li $v0, 4
	la $a0, resultado
	syscall
	li $v0, 1
	move $a0, $v1
	syscall	
	
	li $v0, 10
	syscall
	
coef:

	# Preámbulo
	addi $sp, $sp, -16 # Reservamos 4 palabras.
	sw $ra, 0($sp) # Guardar el contenido de $ra en la primera palabra del stack
	sw $a0, 4($sp) # Guardar el contenido de $a0 (k) en la segunda palabra
	sw $a1, 8($sp) # Guardar el contenido de $a1 (n) en la tercera palabra
	sw $s0, 12($sp) # Guardar la direccion de reg, en la cuarta palabra
	
	# Casos base:
	beq $a0, $zero, coef_regreso # Si k == 0, se sumará 1 a $v1
	beq $a0, $a1, coef_regreso   # Si k == n, se sumará 1 a $v1
	# Cuando se llega al final de esta subrutina, se entra a coef_regreso, en estos
	# casos, se verificará si la entrada a coef_regreso fue por la invocación desde las
	# líneas 63 o 64 (casos base) y no porque es el siguiente bloque por ejecutar. En
	# caso de que sea lo primero, se sumará 1 a $v1, pues es lo que se hace en los casos
	# base. De lo contrario, la entrada a coef_regreso significa únicamente que regresaremos
	# a la llamada recursiva anterior a la ejecución de coef que justo terminó; en este caso
	# no se sumará 1 a $v1, ya que no entramos a coef_regreso por los casos base.
	
	# Ejecución del coeficiente binomial
	addi $sp, $sp, -8 # Reservamos espacio para dos nuevas palabras, aunque sólo usaremos el valor de n-1
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
	# A continuación se comprueba que la entrada a coef_regreso es debido a los casos bases y no a la ejecución después
	# de las líneas finales de coef (las líneas 90-93), en caso de entrar debido a los casos bases, se comprueba a
	# continuación y se sumará uno a $v1, en caso contrario, simplemente se eliminará el marco con addi y 16 y luego
	# se regresará a la subrutina invocadora con jr $ra.
	beq $a0, $zero, suma_uno # Se comprueba que se debe sumar 1 a $v1
	beq $a0, $a1, suma_uno   # Se comprueba que se debe sumar 1 a $v1
	k_going: # Se salta aquí desde suma_uno
	addi $sp, $sp, 16
	
	jr $ra

check1: # n == 0, entonces se revisa si k > 0, en este caso, se terminará el programa y se devolverá 0 como resultado.
	bgtz $a0, end
	j continuar # Si n == 0 pero k == 0, se continuará. Se ejecutará coef con n == 0 y k == 0, lo que devolverá 1 como resultado.

end: # Se imprimirá 0 como resultado y se terminará el programa.
	li $v0, 4
	la $a0, resultado
	syscall
	li $v0, 1
	move $a0, $zero
	syscall	
	
	li $v0, 10
	syscall

suma_uno: # Se suma 1 al resultado y se regresa a coef_regreso, para después retornar a la llamada de la rutina invocadora con jr $ra
	addi $v1, $v1, 1
	j k_going