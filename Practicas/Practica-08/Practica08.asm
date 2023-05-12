.data
solicitar_comando: .asciiz "Ingresa un comando (help si no sabes qué comandos hay): "
advertencia: .asciiz "Ingresa un argumento correcto."
advertencia_comando: .asciiz "Ingresa un comando válido.\n"
file_name1: .asciiz ""
file_name2: .asciiz ""
empty: .asciiz ""
c_exit: .asciiz "exit\n"
c_help_no_arg: .asciiz "help\n"
c_help_arg: .asciiz "help \n"
c_exit2: .asciiz "exit\n"
c_help_na_2: .asciiz "help\n"
c_joke: .asciiz "joke\n"
joke_ub: .word 5
chist_u: .asciiz "¿Sabes qué es más gracioso que 24? 25."
chist_d: .asciiz "Siempre me he preguntado qué significa 'estar en forma'... Si tuviera que elegir una, ¡sería el triángulo!"
chist_t: .asciiz "México"
chist_cu: .asciiz "https://www.youtube.com/shorts/_U_UytUgnDc"
chist_ci: .asciiz "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
c_song: .asciiz "song\n"
c_rev_no_arg: .asciiz "rev\n"
c_rev_arg: .asciiz "rev \n"
rev_prompt: .asciiz "Ingresa una cadena: "
rev_us_input_result: .asciiz "La reversa de la cadena que ingresaste es: "
rev_file_result: .asciiz "La reversa del texto del archivo es: "
c_cat: .asciiz "cat \n"
c_cati: .asciiz "cat\n"
no_2_file: .asciiz "Por favor asegúrate de ingresar el nombre de dos archivos separados por un espacio.\n"
inv_file: .asciiz "Parece que alguno de los archivos no existe o no es válido. Revisa la escritura de los nombres de los archivos e intenta de nuevo.\n"
res_cat: .asciiz "La cadena de los archivos concatenados es: "
c_dados: .asciiz "dados\n"
out_dados1: .asciiz "El dado 1 salió: "
out_dados2: .asciiz " - El dado 2 salió: "
dados_ub: .word 6
c_rps: .asciiz "rps\n"
rps_ub: .word 3
inst_rps: .asciiz "Escribe 1 (piedra), 2 (papel) o 3 (tijeras): "
error_rps: .asciiz "Ingresa un número válido."
cpu: .asciiz "La computadora eligió: "
cpu_ganador: .asciiz "Ganó la computadora."
us_ganador: .asciiz "Ganaste."
rps_empate: .asciiz "Empate."
info_help: .asciiz "help: Muestra la información de los comandos disponibles o del comando recibido como argumento."
info_joke: .asciiz "joke: Muestra un chiste al azar."
info_song: .asciiz "song: ¡Música de Zelda! (Bosque Korok, Breath of the Wild.)"
info_rev: .asciiz "rev: Muestra la reversa de una cadena del archivo pasado como argumento o de input si no hay argumento."
info_cat: .asciiz "cat: Concatena dos archivos de texto."
info_exit: .asciiz "exit: Sale del programa."
info_dados: .asciiz "dados: Se simula el tiro de dos dados."
info_rps: .asciiz "rps: Juega piedra papel o tijeras. Escribirás 1 (piedra), 2 (papel) o 3 (tijeras) al elegir tu movimiento."
new_line: .asciiz "\n"
buffer: .space 256
file_buffer: .space 256
file_buffer2: .space 256

.text
.globl main

main:
	li $v0, 4
	la $a0, solicitar_comando
	syscall
	
	# Vaciamos el buffer del usuario
    li $t0, 0   # Indice de inicio del buffer
	li $t1, 256   # Tamaño del buffer

	empty_buffer:
    	sb $zero, buffer($t0)   # Guardamos 0 en la dirección actual del buffer
    	addi $t0, $t0, 1   # Incrementamos en la dirección del buffer
    	addi $t1, $t1, -1   # Hacemos decremento del buffer
    	bnez $t1, empty_buffer   # Repetimos el loop hasta que el tamaño sea 0
	
	li $v0, 8
	la $a0, buffer
	la $a1, 256
	syscall
	
	move $s0, $a0
		
	# Loop para quit
	li $t0, 0
	la $s1, c_exit2
	
	es_exit:
		lb $t1, ($s0)
        lb $t2, ($s1)  
        
        # Comparamos caracteres para ver si son iguales
        bne $t1, $t2, no_es_exit
        
        # Se incrementa el contador
        addi $t0, $t0, 1
        
        # Se revisa si se alcanzó el final de la cadena, esto ocurre si han sido iguales las cadenas hasta este punto.
        beqz $t1, exit
        
        # Avanzamos en las direcciones de las cadenas al siguiente char
        addi $s0, $s0, 1
        addi $s1, $s1, 1
        
        # Repetimos el loop
        j es_exit

	no_es_exit:
	
	# Loop para help
	li $t0, 0
	li $t3, 0
	la $s1, c_help_na_2
	
	es_help_no_arg:
		lb $t1, ($s0)
        lb $t2, ($s1)
        
        # Comparamos caracteres para ver si son iguales
        bne $t1, $t2, no_es_help_no_arg
        
        # increment loop counter
        addi $t0, $t0, 1
        
        # Se revisa si se alcanzó el final de la cadena, esto ocurre si han sido iguales las cadenas hasta este punto.
        beqz $t1, help_no_arg
        
        # Avanzamos en las direcciones de las cadenas al siguiente char
        addi $s0, $s0, 1
        addi $t3, $t3, 1
        addi $s1, $s1, 1
        
        # Repetimos el loop
        j es_help_no_arg
    
    no_es_help_no_arg:
    li $t0, 0
    sub $s0, $s0, $t3 # Regresamos al inicio de la cadena ingresada por el usuario
	la $s1, c_help_arg
	li $t3, 0
	
    es_help_arg:
    	lb $t1, ($s0)
        lb $t2, ($s1)
        
        # Comparamos caracteres para ver si son iguales
        bne $t1, $t2, no_es_help
        
        # Se incrementa el contador
        addi $t0, $t0, 1
        
        # Si el contador es 5 y han sido iguales, entonces el usuario escribio "help " al inicio de su entrada, se revisará si ingresó argumentos válidos
        beq $t0, 5, help_arg
        
        # Avanzamos en las direcciones de las cadenas al siguiente char
        addi $s0, $s0, 1
		addi $t3, $t3, 1
        addi $s1, $s1, 1
        
        # Repetimos el loop
        j es_help_arg

	no_es_help:
	li $t0, 0
    sub $s0, $s0, $t3
	la $s1, c_joke
	li $t3, 0
	
    es_joke:
    	lb $t1, ($s0)
        lb $t2, ($s1)
        
        # Comparamos caracteres para ver si son iguales
        bne $t1, $t2, no_es_joke
        
        # Se incrementa el contador
        addi $t0, $t0, 1

        # Se revisa si se alcanzó el final de la cadena, esto ocurre si han sido iguales las cadenas hasta este punto.
        beqz $t1, joke
        
        # Avanzamos en las direcciones de las cadenas al siguiente char
        addi $s0, $s0, 1
		addi $t3, $t3, 1
        addi $s1, $s1, 1
        
        # Repetimos el loop
        j es_joke
	
	no_es_joke:
	li $t0, 0
    sub $s0, $s0, $t3
	la $s1, c_song
	li $t3, 0
	
    es_song:
    	lb $t1, ($s0)
        lb $t2, ($s1) 
        
        # Comparamos caracteres para ver si son iguales
        bne $t1, $t2, no_es_song
        
        # Se incrementa el contador
        addi $t0, $t0, 1
        
        # Se revisa si se alcanzó el final de la cadena, esto ocurre si han sido iguales las cadenas hasta este punto.
        beqz $t1, song
        
        # Avanzamos en las direcciones de las cadenas al siguiente char
        addi $s0, $s0, 1
		addi $t3, $t3, 1
        addi $s1, $s1, 1
        
        # Repetimos el loop
        j es_song
        
    no_es_song:
	li $t0, 0
    sub $s0, $s0, $t3
	la $s1, c_dados
	li $t3, 0
	
    es_dados:
    	lb $t1, ($s0)
        lb $t2, ($s1) 
        
        # Comparamos caracteres para ver si son iguales
        bne $t1, $t2, no_es_dados
        
        # Se incrementa el contador
        addi $t0, $t0, 1
        
        # Se revisa si se alcanzó el final de la cadena, esto ocurre si han sido iguales las cadenas hasta este punto.
        beqz $t1, dados
        
        # Avanzamos en las direcciones de las cadenas al siguiente char
        addi $s0, $s0, 1
		addi $t3, $t3, 1
        addi $s1, $s1, 1
        
        # repeat loop
        j es_dados
        
    no_es_dados:
    li $t0, 0
    sub $s0, $s0, $t3
	la $s1, c_rps
	li $t3, 0
	
    es_rps:
    	lb $t1, ($s0)
        lb $t2, ($s1) 
        
        # Comparamos caracteres para ver si son iguales
        bne $t1, $t2, no_es_rps
        
        # Se incrementa el contador
        addi $t0, $t0, 1
        
        # Se revisa si se alcanzó el final de la cadena, esto ocurre si han sido iguales las cadenas hasta este punto.
        beqz $t1, rps
        
        # Avanzamos en las direcciones de las cadenas al siguiente char
        addi $s0, $s0, 1
		addi $t3, $t3, 1
        addi $s1, $s1, 1
        
        # Repetimos el loop
        j es_rps
    no_es_rps:
    li $t0, 0
    sub $s0, $s0, $t3
	la $s1, c_rev_no_arg
	li $t3, 0
	
    es_rev_no_arg:
    	lb $t1, ($s0)
        lb $t2, ($s1)
        
        # Comparamos caracteres para ver si son iguales
        bne $t1, $t2, no_es_rev_no_arg
        
        # Se incrementa el contador
        addi $t0, $t0, 1
        
        # Se revisa si se alcanzó el final de la cadena, esto ocurre si han sido iguales las cadenas hasta este punto.
        beqz $t1, rev_no_arg
        
        # Avanzamos en las direcciones de las cadenas al siguiente char
        addi $s0, $s0, 1
		addi $t3, $t3, 1
        addi $s1, $s1, 1
        
        # Repetimos el loop
        j es_rev_no_arg

    no_es_rev_no_arg:
    li $t0, 0
    sub $s0, $s0, $t3
	la $s1, c_rev_arg
	li $t3, 0
	
    es_rev_arg:
    	lb $t1, ($s0)
        lb $t2, ($s1) 
        
        # Comparamos caracteres para ver si son iguales
        bne $t1, $t2, no_es_rev_arg
        
        # Se incrementa el contador
        addi $t0, $t0, 1
        
		# Si el contador es 4 y han sido iguales, entonces el usuario escribio "rev " al inicio de su entrada, lo que sigue es el nombre del archivo.
        beq $t0, 4, rev_arg
        
        # Avanzamos en las direcciones de las cadenas al siguiente char
        addi $s0, $s0, 1
		addi $t3, $t3, 1
        addi $s1, $s1, 1
        
        # Repetimos el loop
        j es_rev_arg
    no_es_rev_arg:
    li $t0, 0
    sub $s0, $s0, $t3
	la $s1, c_cat
	li $t3, 0
	
    es_cat:
    	lb $t1, ($s0)
        lb $t2, ($s1) 
        
        # Comparamos caracteres para ver si son iguales
        bne $t1, $t2, no_es_cat
        
        # Se incrementa el contador
        addi $t0, $t0, 1
        
		# Si el contador es 4 y han sido iguales, entonces el usuario escribio "cat " al inicio de su entrada, lo que sigue son los nombres de los archivos.
        beq $t0, 4, cat
        
        # Avanzamos en las direcciones de las cadenas al siguiente char
        addi $s0, $s0, 1
		addi $t3, $t3, 1
        addi $s1, $s1, 1
        
        # Repetimos el loop
        j es_cat
    no_es_cat:
    sub $s0, $s0, $t3
    li $v0, 4
    la $a0, advertencia_comando
    syscall
	j main
	
exit:
	li $v0, 10
	syscall
	
# Help sin argumentos. carga la instrucción de syscall para imprimir una cadena, carga saltos de líneas
# y la información de cada comando y las va imprimiendo.
help_no_arg:
	li $v0, 4
	la $a0, new_line
	syscall
	la $a0, info_help
	syscall
	la $a0, new_line
	syscall
	la $a0, info_joke
	syscall
	la $a0, new_line
	syscall
	la $a0, info_song
	syscall
	la $a0, new_line
	syscall
	la $a0, info_rev
	syscall
	la $a0, new_line
	syscall
	la $a0, info_cat
	syscall
	la $a0, new_line
	syscall
	la $a0, info_exit
	syscall
	la $a0, new_line
	syscall
	la $a0, info_dados
	syscall
	la $a0, new_line
	syscall
	la $a0, info_rps
	syscall
	la $a0, new_line
	syscall
	syscall
	j main

# Help con argumentos. Revisa si el argumento después de help es el nombre de algún comando. De ser así
# invoca una subrutina que imprime la información de dicho comando, si no es igual a ninguno, manda un
# error.
help_arg:
    addi $s0, $s0, 1 # Nos saltamos el espacio después de help.
    addi $s1, $s1, 1
	la $s1, c_help_na_2 # Cargamos "help" para ver si eso fue lo que escribió el usuario como argumento.
	li $t3, 0
	inf_help:
		lb $t1, ($s0)
		lb $t2, ($s1)
		bne $t1, $t2, no_info_help
        beqz $t1, print_inf_help
        addi $s0, $s0, 1
        addi $t3, $t3, 1
        addi $s1, $s1, 1
        j inf_help
    no_info_help:
    sub $s0, $s0, $t3 # Regresamos al inicio del argumento.
    la $s1, c_joke # Cargamos "joke" paraver si eso fue lo que escribió el usuario como argumento.
    li $t3, 0
    inf_joke:
		lb $t1, ($s0)
		lb $t2, ($s1)
		bne $t1, $t2, no_info_joke
        beqz $t1, print_inf_joke
        addi $s0, $s0, 1
        addi $t3, $t3, 1
        addi $s1, $s1, 1
        j inf_joke
    no_info_joke:
    sub $s0, $s0, $t3
    la $s1, c_song
    li $t3, 0
    inf_song:
		lb $t1, ($s0)
		lb $t2, ($s1)
		bne $t1, $t2, no_info_song
        beqz $t1, print_inf_song
        addi $s0, $s0, 1
        addi $t3, $t3, 1
        addi $s1, $s1, 1
        j inf_song
    no_info_song:
    sub $s0, $s0, $t3
    la $s1, c_rev_no_arg
    li $t3, 0
    inf_rev:
		lb $t1, ($s0)
		lb $t2, ($s1)
		bne $t1, $t2, no_info_rev
        beqz $t1, print_inf_rev
        addi $s0, $s0, 1
        addi $t3, $t3, 1
        addi $s1, $s1, 1
        j inf_rev
    no_info_rev:
    sub $s0, $s0, $t3
    la $s1, c_cati
    li $t3, 0
    inf_cat:
		lb $t1, ($s0)
		lb $t2, ($s1)
		bne $t1, $t2, no_info_cat
        beqz $t1, print_inf_cat
        addi $s0, $s0, 1
        addi $t3, $t3, 1
        addi $s1, $s1, 1
        j inf_cat
    no_info_cat:
    sub $s0, $s0, $t3
    la $s1, c_dados
    li $t3, 0
    inf_dados:
		lb $t1, ($s0)
		lb $t2, ($s1)
		bne $t1, $t2, no_info_dados
        beqz $t1, print_inf_dados
        addi $s0, $s0, 1
        addi $t3, $t3, 1
        addi $s1, $s1, 1
        j inf_dados
    no_info_dados:
    sub $s0, $s0, $t3
    la $s1, c_rps
    li $t3, 0
    inf_rps:
		lb $t1, ($s0)
		lb $t2, ($s1)
		bne $t1, $t2, no_info_rps
        beqz $t1, print_inf_rps
        addi $s0, $s0, 1
        addi $t3, $t3, 1
        addi $s1, $s1, 1
        j inf_rps
    no_info_rps:
    sub $s0, $s0, $t3
    la $s1, c_exit2
    li $t3, 0
    inf_exit:
		lb $t1, ($s0)
		lb $t2, ($s1)
		bne $t1, $t2, no_info_exit
        beqz $t1, print_inf_exit
        addi $s0, $s0, 1
        addi $t3, $t3, 1
        addi $s1, $s1, 1
        j inf_exit
    no_info_exit:
    li $v0, 4
    la $a0, advertencia
    syscall
    li $v0, 4
	la $a0, new_line
	syscall
    j main

# Los siguientes prints muestran en pantalla la información del comando en cuestión.
print_inf_help:
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, info_help
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	j main
	
print_inf_exit:
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, info_exit
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	j main
	
print_inf_joke:
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, info_joke
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	j main

print_inf_song:
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, info_song
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	j main

print_inf_rev:
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, info_rev
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	j main
	
print_inf_cat:
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, info_cat
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	j main
	
print_inf_dados:
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, info_dados
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	j main

print_inf_rps:
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, info_rps
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	j main
	
# joke genera un número aleatorio y devuelve un chiste según el número
joke:
	li $v0, 4
	la $a0, new_line 
	syscall # salto de línea
	li $v0, 42
	li $a0, 28
	lw $a1, joke_ub #joke_ub es un .word con valor de 5, es la cota superior del rango del número aleatorio, no inclusivo.
	syscall # generación de un número aleatorio del 0 al 4
	beq $a0, 0, chiste_u
	beq $a0, 1, chiste_d
	beq $a0, 2, chiste_t
	beq $a0, 3, chiste_cu
	beq $a0, 4, chiste_ci
	# se imprime el chiste en cuestión y se salta los demás
	chiste_u:
	li $v0, 4
	la $a0, chist_u
	syscall
	j chiste_listo
	chiste_d:
	li $v0, 4
	la $a0, chist_d
	syscall
	j chiste_listo
	chiste_t:
	li $v0, 4
	la $a0, chist_t
	syscall
	j chiste_listo
	chiste_cu:
	li $v0, 4
	la $a0, chist_cu
	syscall
	j chiste_listo
	chiste_ci:
	li $v0, 4
	la $a0, chist_ci
	syscall
	j chiste_listo
	# ya se imprimió el chiste
	chiste_listo:
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	j main

song:
	li $v0, 31 # Salida MIDI 
	li $a2, 68 # Instrumento de caña
	li $a3, 72 # Volumen
	
	# Primera nota
	li $a0, 61 # Do sostenido central
	li $a1, 400 # Corchea a 75bpm
	syscall
	li $v0, 32 # Sleep para que la siguiente nota no suene sino hasta que la previa haya terminado (la instrucción 33 no nos convenció, fue  mejor usar 31 y un sleep con 32)
	li $a0, 400
	syscall
	# Segunda nota
	li $v0, 31
	li $a0, 66 # Fa sostenido
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	# Mäs notas...
	li $v0, 31
	li $a0, 73
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	
	li $v0, 31
	li $a0, 73
	li $a1, 1600
	syscall
	li $v0, 32
	li $a0, 1600
	syscall
	li $a0, 800 # Silencio de negra
	syscall
	
	# Segundo motivo
	li $v0, 31
	li $a0, 71
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	
	li $v0, 31
	li $a0, 69 
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	
	li $v0, 31
	li $a0, 71
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	
	li $v0, 31
	li $a0, 64
	li $a1, 1200
	syscall
	li $v0, 32
	li $a0, 1200
	syscall
	li $a0, 800
	syscall
	
	# Tercer motivo
	li $v0, 31
	li $a0, 62
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	
	li $v0, 31
	li $a0, 61
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	
	li $v0, 31
	li $a0, 62
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	
	li $v0, 31
	li $a0, 69
	li $a1, 1200
	syscall
	li $v0, 32
	li $a0, 1200
	syscall
	li $a0, 800
	syscall
	
	# Cuarto motivo
	li $v0, 31
	li $a0, 68
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	
	li $v0, 31
	li $a0, 66
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	
	li $v0, 31
	li $a0, 68
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	
	li $v0, 31
	li $a0, 61
	li $a1, 1200
	syscall
	li $v0, 32
	li $a0, 1200
	syscall
	li $a0, 800
	syscall
	
	# Preparación para la escala
	
	li $v0, 31
	li $a0, 66
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	li $v0, 31
	li $a0, 73
	li $a1, 2000
	syscall
	li $v0, 32
	li $a0, 2000
	syscall
	li $a0, 800
	syscall
	
	li $v0, 31
	li $a0, 78
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	li $v0, 31
	li $a0, 76
	li $a1, 1200
	syscall
	li $v0, 32
	li $a0, 1200
	syscall
	li $a0, 400
	syscall
	
	# Llegando a la escala
	li $v0, 31
	li $a0, 71
	li $a1, 800
	syscall
	li $a0, 64
	li $a1, 680
	syscall
	li $v0, 32
	li $a0, 800
	syscall
	li $v0, 31
	li $a0, 64
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	
	# Escala
	li $v0, 31
	li $a0, 69
	li $a1, 200
	syscall
	li $v0, 32
	li $a0, 200
	syscall
	li $v0, 31
	li $a0, 71
	li $a1, 200
	syscall
	li $v0, 32
	li $a0, 200
	syscall
	li $v0, 31
	li $a0, 72
	li $a1, 200
	syscall
	li $v0, 32
	li $a0, 200
	syscall
	li $v0, 31
	li $a0, 74
	li $a1, 200
	syscall
	li $v0, 32
	li $a0, 200
	syscall
	li $v0, 31
	li $a0, 76
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	
	# Descenso escala
	li $v0, 31
	li $a0, 74	
	li $a1, 200
	syscall
	li $v0, 32
	li $a0, 200
	syscall
	li $v0, 31
	li $a0, 72
	li $a1, 200
	syscall
	li $v0, 32
	li $a0, 200
	syscall
	li $v0, 31
	li $a0, 71
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	li $v0, 31
	li $a0, 69
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	li $v0, 31
	li $a0, 67
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	li $v0, 31
	li $a0, 69
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	li $v0, 31
	li $a0, 66
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	li $v0, 31
	li $a0, 62
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	
	#Final
	li $v0, 31
	li $a0, 64
	li $a1, 800
	syscall
	li $v0, 32
	li $a0, 800
	syscall
	li $v0, 31
	li $a0, 76
	li $a1, 800
	syscall
	li $v0, 32
	li $a0, 800
	syscall
	li $v0, 31
	li $a0, 73
	li $a1, 800
	syscall
	li $v0, 32
	li $a0, 800
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	li $v0, 31
	li $a0, 78
	li $a1, 2000
	syscall
	li $v0, 32
	li $a0, 2000
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	li $v0, 31
	li $a0, 80
	li $a1, 400
	syscall
	li $v0, 32
	li $a0, 400
	syscall
	li $v0, 31
	li $a0, 73
	li $a1, 2000
	syscall
	li $v0, 32
	li $a1, 2000
	syscall
	
	j main

dados:
	# Imprimimos una nueva linea para tener formato bonito
	li $v0, 4
	la $a0, new_line
	syscall
	# Generamos un número aleatorio entre 0 y 5, dados_ub es el límite superior (6) del rango de números aleatorios
	li $v0, 42
	li $a0, 28
	lw $a1, dados_ub
	syscall
	# Guardamos el número generado en un temporal, le sumamos 1 para que sea un número del 1 al 6
	move $t4, $a0
	addi $t4, $t4, 1
	# Preparamos imprimir y mostrar el resultado del primer dado
	li $v0, 4
	la $a0, out_dados1
	syscall
	# Imprimimos el resultado del primer dado
	li $v0, 1
	move $a0, $t4
	syscall
	# Repetimos el proceso para el segundo dado
	li $v0, 42
	li $a0, 28
	lw $a1, dados_ub
	syscall
	li $v0, 4
	move $t4, $a0
	addi $t4, $t4, 1
	la $a0, out_dados2
	syscall
	li $v0, 1
	move $a0, $t4
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	j main
	
rps:
	li $v0, 4
	la $a0, inst_rps
	syscall
	li $v0, 5
	syscall
	move $t5, $v0
	# Generamos un número aleatorio entre 0 y 2.
	li $v0, 42
	li $a0, 28
	lw $a1, rps_ub
	syscall
	move $t6, $a0
	addi $t6, $t6, 1
	li $v0, 4
	la $a0, cpu
	syscall
	li $v0, 1
	move $a0, $t6
	syscall
	li $v0, 4
	la $a0, new_line
	syscall
	beq $t5, $t6, empate # Si la computadora y el usuario eligieron la misma opcion, hay empate.
	# Si son distintos, se hace branch dependiendo de la elección del usuario
	beq $t5, 1, rps_1
	beq $t5, 2, rps_2
	beq $t5, 3, rps_3
	li $v0, 4
	la $a0, new_line
	syscall
	la $a0, error_rps
	syscall
	la $a0, new_line
	syscall
	la $a0, new_line
	syscall
	j main
	
rps_1:
	beq $t6, 2, derrota
	beq $t6, 3, victoria
	
rps_2:
	beq $t6, 1, victoria
	beq $t6, 3, derrota
	
rps_3:
	beq $t6, 1, derrota
	beq $t6, 2, victoria
	
empate:
	li $v0, 4
	la $a0, rps_empate
	syscall
	la $a0, new_line
	syscall
	la $a0, new_line
	syscall
	j main

derrota:
	li $v0, 4
	la $a0, cpu_ganador
	syscall
	la $a0, new_line
	syscall
	la $a0, new_line
	syscall
	j main
	
victoria:
	li $v0, 4
	la $a0, us_ganador
	syscall
	la $a0, new_line
	syscall
	la $a0, new_line
	syscall
	j main
	
rev_no_arg:
	li $v0, 4
	la  $a0, rev_prompt
	syscall
	li $v0, 8
	la $a0, buffer
	la $a1, 256
	syscall
	move $s0, $a0
	li $t0, 0
	# Avanzamos al final de la cadena para imprimir en reversa.
	ir_al_final:
		lb $t1, ($s0)
        
        # Se revisa si se alcanzó el final de la cadena
        beqz $t1, result_prompt
        
        # Avanzamos en las direcciones de la cadena al siguiente char
        addi $s0, $s0, 1
        addi $t0, $t0, 1
        
        # Repetimos el loop
        j ir_al_final
    # Se imprimirá "La cadena invertida es..."
    result_prompt:
    li $v0, 4
    la $a0, rev_us_input_result
    syscall
    # Se imprimen los caracteres de la cadena en orden inverso a su lectura.
	start_printing:
		addi $s0, $s0, -1
		addi $t0, $t0, -1
		lb $t1, ($s0)
		li $v0, 11
		move $a0, $t1
		syscall
		beqz $t0, final_rev_no_arg # si $t0 es 0, se imprimió el primer caracter de la cadena
		j start_printing
	final_rev_no_arg:
	li $v0, 4
	la $a0, new_line
	syscall
	syscall
	j main

rev_arg:
	addi $s0, $s0, 1
	la $t2, file_name1
	# Estamos apuntando al inicio del nombre del archivo por leer.
	copy_file_name:
		lb $t1, ($s0) # Cargamos el primer char del nombre
		beq $t1, 10, copy_end
        sb $t1, ($t2) # Lo guardamos en $t2, modificando así file_name1

        addi $s0, $s0, 1
        addi $t2, $t2, 1
        j copy_file_name
    copy_end:
    sb $zero, ($t2) # Hacemos que la cadena sea null-terminated
    # Abrimos el archivo
    li $v0, 13
    la $a0, file_name1
    li $a1, 0
    li $a2, 0
    syscall
    move $s0, $v0 # Movemos el descriptor a $s0
    # Leemos el archivo
    li $v0, 14
    move $a0, $s0
    la $a1, file_buffer
    li $a2, 256
    syscall
    move $s2, $a1
    # Nos dirigimos al final del archivo
    li $t0, 0
	ir_al_fin:
		lb $t1, ($s2)
        
        # Se revisa si se alcanzó el final de la cadena
        beqz $t1, resultado
        
        # Avanzamos en las direcciones de la cadena al siguiente char
        addi $s2, $s2, 1
        addi $t0, $t0, 1
        
        # Repetimos el loop
        j ir_al_fin
    resultado:
    li $v0, 4
    la $a0, rev_file_result
    syscall
    imprimir:
		addi $s2, $s2, -1
		addi $t0, $t0, -1
		lb $t1, ($s2)
		li $v0, 11
		move $a0, $t1
		syscall
		beqz $t0, final_rev
		j imprimir
    final_rev:
    
    li $v0, 4
    la $a0, new_line
    syscall
    syscall
    
    # Cerramos el archivo
    li $v0, 16
    move $a0, $s0
    syscall
    # Reiniciamos la cadena del nombre del archivo
    la $t0, empty
    sw $t2, file_name1
    
    # Vaciamos el buffer del archivo
    li $t0, 0   # Indice de inicio del buffer
	li $t1, 256   # Tamaño del buffer

	empty_file_buffer:
    	sb $zero, file_buffer($t0)   # Guardamos 0 en la dirección actual del buffer
    	addi $t0, $t0, 1   # Incrementamos en la dirección del buffer
    	addi $t1, $t1, -1   # Hacemos decremento del buffer
    	bnez $t1, empty_file_buffer   # Repetimos el loop hasta que el tamaño sea 0
    	
	j main

cat:
	addi $s0, $s0, 1
	la $t2, file_name1
	la $t3, file_name2
	# Estamos apuntando al inicio del nombre del primer archivo por leer.
	copy_file_name1:
		lb $t1, ($s0) # Cargamos los chars del nombre
		beq $t1, 10, no_second_file
		beq $t1, 32, copy_end1
        sb $t1, ($t2) # Los guardamos en $t2, modificando así file_name1

        addi $s0, $s0, 1
        addi $t2, $t2, 1
        j copy_file_name1
    copy_end1:
    sb $zero, ($t2) # Hacemos que la cadena sea null-terminated
    # Abrimos el archivo
    li $v0, 13
    la $a0, file_name1
    li $a1, 0
    li $a2, 0
    syscall
    bltz $v0, invalid_file # Si $v0 es negativo, el archivo no se leyó correctamente; hubo un error.
    move $s4, $v0 # Movemos el descriptor a $s4
    # Leemos el archivo
    li $v0, 14
    move $a0, $s4
    la $a1, file_buffer
    li $a2, 256
    syscall
    move $s5, $a1
   	addi $s0, $s0, 1
    # Estamos apuntando al inicio del nombre del segundo archivo por leer.
	copy_file_name2:
		lb $t1, ($s0) # Cargamos los chars del nombre
		
		beq $t1, 10, copy_end2
        sb $t1, ($t3) # Los guardamos en $t3, modificando así file_name2

        addi $s0, $s0, 1
        addi $t3, $t3, 1
        j copy_file_name2
    copy_end2:
    sb $zero, ($t3) # Hacemos que la cadena sea null-terminated
    # Abrimos el archivo
    li $v0, 13
    la $a0, file_name2
    li $a1, 0
    li $a2, 0
    syscall
    bltz $v0, invalid_file # Si $v0 es negativo, el archivo no se leyó correctamente; hubo un error.
    move $s6, $v0 # Movemos el descriptor a $s6
    # Leemos el archivo
    li $v0, 14
    move $a0, $s6
    la $a1, file_buffer2
    li $a2, 256
    syscall
    move $s7, $a1
    # Nos movemos al final de la cadena del primer archivo:
	ir_al_finarch:
		lb $t1, ($s5)
        # Se revisa si se alcanzó el final de la cadena
        beqz $t1, salir
        
        # Avanzamos en las direcciones de la cadena al siguiente char
        addi $s5, $s5, 1
        addi $t7, $t7, 1 # Contamos cuánto hemos avanzado en la primer cadena, para después regresar al comienzo.
        
        # Repetimos el loop
        j ir_al_finarch
    salir:
    concat_loop:
    	lb $t1, ($s7)
    	sb $t1, ($s5)
        # Se revisa si se alcanzó el final de la cadena
        beqz $t1, salir_concat
        # Avanzamos en las direcciones de las cadenas al siguiente char
        addi $s5, $s5, 1
        addi $s7, $s7, 1
        addi $t7, $t7, 1 # Seguimos contando cuánto hemos avanzado en la primer cadena, para regresar.
        j concat_loop
    salir_concat:
    sb $zero, ($s5) # Agregamos el null terminator a la cadena
    sub $s5, $s5, $t7 # Regresamos el apuntador al inicio de la cadena
    li $t7, 0
    li $v0, 4
    la $a0, res_cat # Mandaremos el mensaje de el resultado de la concatenación
    syscall
    li $v0, 4
    move $a0, $s5 # Imprimimos la cadena concatenada
    syscall
    la $a0, new_line
    syscall
    syscall
    
    # Cerramos el archivo 1
    li $v0, 16
    move $a0, $s4
    syscall
    # Cerramos el archivo 2
    li $v0, 16
    move $a0, $s6
    syscall
    
    # Vaciamos el buffer del archivo
    li $t0, 0   # Indice de inicio del buffer
	li $t1, 256   # Tamaño del buffer

	empty_file_buffer1:
    	sb $zero, file_buffer($t0)   # Guardamos 0 en la dirección actual del buffer
    	addi $t0, $t0, 1   # Incrementamos en la dirección del buffer
    	addi $t1, $t1, -1   # Hacemos decremento del buffer
    	bnez $t1, empty_file_buffer1   # Repetimos el loop hasta que el tamaño sea 0
    
	# Vaciamos el buffer del archivo
    li $t0, 0   # Indice de inicio del buffer
	li $t1, 256   # Tamaño del buffer

	empty_file_buffer2:
    	sb $zero, file_buffer2($t0)   # Guardamos 0 en la dirección actual del buffer
    	addi $t0, $t0, 1   # Incrementamos en la dirección del buffer
    	addi $t1, $t1, -1   # Hacemos decremento del buffer
    	bnez $t1, empty_file_buffer2   # Repetimos el loop hasta que el tamaño sea 0
    
    j main

# Si no se ingresa un segundo archivo se devuelve un error
no_second_file:
	li $v0, 4
	la $a0, no_2_file
	syscall
	j main
	
# Si alguno de los dos archivos no abre correctamente se devuelve un error.
invalid_file:
	li $v0, 4
	la $a0, inv_file
	syscall
	j main
