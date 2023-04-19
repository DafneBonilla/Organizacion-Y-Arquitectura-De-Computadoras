# Ejercicio 1: Copiar el contenido de un registro a otro

# Opción 1:
sll $t1, $t0, 0   # Desplaza $t0 0 bits a la izquierda 
srl $t1, $t1, 0   # Desplaza $t1 0 bits a la derecha

# Opción 2:
xor $t1, $t0, $t0   # XOR de $t0 consigo mismo, el resultado es $t0