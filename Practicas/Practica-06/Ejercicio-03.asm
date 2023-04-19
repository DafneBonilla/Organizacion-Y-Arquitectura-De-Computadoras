# Ejercicio 3: Comparar 2 n�meros enteros e imprimir un mensaje que nos diga
# si son iguales o no.

# Definici�n de variables globales:
.data
    message_1: .asciiz "Ingrese el primer n�mero: "   # Mensaje para ingresar el primer n�mero
    message_2: .asciiz "Ingrese el segundo n�mero: "  # Mensaje para ingresar el segundo n�mero
    equal:   .asciiz "Los n�meros son iguales"        # Mensaje para n�meros iguales
    not_equal: .asciiz "Los n�meros son diferentes"   # Mensaje para n�meros diferentes

# Instrucciones para la entrada de datos:
.text
    li $v0, 4             # Carga el valor 4 en $v0 (syscall para imprimir cadena)
    la $a0, message_1     # Imprime el mensaje para ingresar el primer n�mero
    syscall
    
    li $v0, 5             # Carga el valor 5 en $v0 (syscall para leer entero)
    syscall
    move $s0, $v0         # Guarda el primer n�mero ingresado en $s0
    
    li $v0, 4             # Carga el valor 4 en $v0 (syscall para imprimir cadena)
    la $a0, message_2     # Imprime el mensaje para ingresar el segundo n�mero
    syscall
    
    li $v0, 5             # Carga el valor 5 en $v0 (syscall para leer entero)
    syscall
    move $s1, $v0         # Guarda el segundo n�mero ingresado en $s1
    
    beq $s0, $s1, same    # Compara los n�meros para ver si son iguales
    la $a0, not_equal     # Si no son iguales, carga el mensaje not_equal en $a0
    j end

same:
    la $a0, equal        # Si son iguales, carga el mensaje equal en $a0

end:
    li $v0, 4            # Imprime el mensaje equal o not_equal
    syscall
    li $v0, 10           # Carga el valor 10 en $v0 (syscall para salir del programa)
    syscall
