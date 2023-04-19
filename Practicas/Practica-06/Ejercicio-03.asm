# Ejercicio 3: Comparar 2 números enteros e imprimir un mensaje que nos diga
# si son iguales o no.

# Definición de variables globales:
.data
    message_1: .asciiz "Ingrese el primer número: "   # Mensaje para ingresar el primer número
    message_2: .asciiz "Ingrese el segundo número: "  # Mensaje para ingresar el segundo número
    equal:   .asciiz "Los números son iguales"        # Mensaje para números iguales
    not_equal: .asciiz "Los números son diferentes"   # Mensaje para números diferentes

# Instrucciones para la entrada de datos:
.text
    li $v0, 4             # Carga el valor 4 en $v0 (syscall para imprimir cadena)
    la $a0, message_1     # Imprime el mensaje para ingresar el primer número
    syscall
    
    li $v0, 5             # Carga el valor 5 en $v0 (syscall para leer entero)
    syscall
    move $s0, $v0         # Guarda el primer número ingresado en $s0
    
    li $v0, 4             # Carga el valor 4 en $v0 (syscall para imprimir cadena)
    la $a0, message_2     # Imprime el mensaje para ingresar el segundo número
    syscall
    
    li $v0, 5             # Carga el valor 5 en $v0 (syscall para leer entero)
    syscall
    move $s1, $v0         # Guarda el segundo número ingresado en $s1
    
    beq $s0, $s1, same    # Compara los números para ver si son iguales
    la $a0, not_equal     # Si no son iguales, carga el mensaje not_equal en $a0
    j end

same:
    la $a0, equal        # Si son iguales, carga el mensaje equal en $a0

end:
    li $v0, 4            # Imprime el mensaje equal o not_equal
    syscall
    li $v0, 10           # Carga el valor 10 en $v0 (syscall para salir del programa)
    syscall
