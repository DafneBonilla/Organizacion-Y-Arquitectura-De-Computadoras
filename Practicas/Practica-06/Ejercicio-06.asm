# Ejercicio 6: Obtener el resultado de evaluar la serie de Madhava-Leibniz.

# Definición de variables globales:
.data
prompt1: .asciiz "Introduce m: "
result1: .asciiz "El resultado es: "
count: .word 0
n: .float 0.0
zero: .float 0.0
one: .float 1.0
two: .float 2.0
four: .float 4.0
result: .float 0.0

# Instrucciones para la entrada de datos:

.text
.globl main
main:
	
	# Pide al usuario el valor de m
	li $v0, 4 # Se carga la instrucción para imprimir la cadena
	la $a0, prompt1 # Se carga en la dirección $a0 la cadena
	syscall # Se imprime la cadena
	li $v0, 5 # Se carga la instrucción de leer el entero ingresado por el usuario (m)
	syscall
	move $s0, $v0 # Se mueve a $s0 el valor de m
	addi $s0, $s0, 1 # Se suma 1 a m para que el loop funcione como conocemos un for in range
	lwc1 $f0, result # Se inicializa en 0.0 el resultado
	
	# Se cargan las constantes
	lwc1 $f10, zero
	lwc1 $f1, one
	lwc1 $f2, two
	lwc1 $f4, four
	
	# Se carga n (a partir de donde comenzamos a operar la serie, es decir, 0.0) en $f3
	lwc1 $f3, n
	
loop:
	# Si $f3 es 0.0 (esto ocurre siempre, ya que comenzamos con n=0.0), se salta a la etiqueta add_first
	# para agregar el primer sumando de la serie (1.0) al resultado.
	c.eq.s $f3, $f10
	bc1t add_first
	
	j mod_two # Si $f3 no es 0.0, (n no es 0), se evalua el modulo de n (la iteración actual)
	
	# Se suma la constante 1.1 que está en $f1 al resultado en $f0, luego se suma a $f3 la constante 1, pues
	# para el siguiente término se operará con n=1.
	# Se hace un salto a done, para verificar si ya terminamos de hacer las sumas.
	add_first:
		add.s $f0, $f0, $f1
		add.s $f3, $f3, $f1
		j done
	
	# La serie alterna entre términos positivos y negativos, sumaremos entonces positivos o negativos.
	
	add_neg:
		mul.s $f9, $f2, $f3 # 2*n
		add.s $f9, $f9, $f1 # sumamos 1
		div.s $f9, $f1, $f9 # dividimos 1 entre el denominador de la serie
		sub.s $f0, $f0, $f9 # al resultado en $f0, le restamos lo que tenemos en $f9, que equivale a (1**n)/((2*n)+1)
		add.s $f3, $f3, $f1 # Sumamos 1 a n
		j done # Verificamos si ya terminamos
	
	add_pos:
		mul.s $f9, $f2, $f3 # 2*n
		add.s $f9, $f9, $f1 # sumamos 1
		div.s $f9, $f1, $f9 # dividimos 1 entre el denominador de la serie
		add.s $f0, $f0, $f9 # al resultado en $f0, le sumamos lo que tenemos en $f9, que equivale a (1**n)/((2*n)+1)
		add.s $f3, $f3, $f1 # Sumamos 1 a n
		j done # Verificamos si ya terminamos
		
    # Comprobar si se ha alcanzado el número de términos deseado
    done:
	    lw $t1, count # cargamos el valor de count en $t1
	    addi $t2, $t1, 1 # sumamos 1 a este valor
	    sw $t2, count # guardamos el valor obtenido en count
	    bne $t2, $s0, loop # Si no hemos terminado de sumar en la serie, repetimos el loop
	    beq $t2, $s0, mult_four # Si terminamos de sumar en la serie, saltamos a mult_four

    # Multiplicar por 4
    mult_four:
    	lwc1 $f2, four
	    mul.s $f0, $f0, $f2

    # Mostrar el resultado por pantalla
    li $v0, 4 # Instrucción para imprimir cadena
    la $a0, result1 # Se carga en la dirección $a0 la cadena
    syscall # Se imprime la cadena
    li $v0, 2 # Instrucción para imprimir float
    mov.s $f12, $f0 # En $f12 se encuentra lo que syscall imprime con $v0 2
    syscall
    li $v0, 10 # Se finaliza el programa
    syscall
   
	# Se evalua el n%2. Esto nos ayudará a saber si sumaremos un término positivo o negativo (pues tenemos en la serie
	# un -1 elevado a la n, si n%2 == 1, entonces esto evaluará a -1, por lo que se sumará un término negativo, mientras
	# que si n%2 == 0, -1 elevado a la n será 1, por lo que se sumará un término positivo.
	# Usamos como base el ejercicio 4. Es una variación del mismo donde no nos interesa el cociente.
	mod_two:
		lw $s7, count
		# Comienza el bucle de la división
		div_loop:
		# Resta el divisor a $s0 y comprueba si el resultado es negativo
			subi $s7, $s7, 2
			bltz $s7, div_end
	
		# Salta al principio del bucle
			j div_loop
	
		# Termina la división
		div_end:
		# Calcula el residuo sumando el divisor al dividendo
			addi $s6, $s7, 2
		
		# Si el módulo da 0 o 1, sumaremos un término positivo o uno negativo, respectivamente.
		beq $s6, 1, add_neg
		beq $s6, 0, add_pos 
