#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
    Cuarta práctica de laboratorio. Introducción a C.
    Dafne Bonilla Reyes. No.Cta.: 319089660
    Sergio Medina Guzmán. No.Cta.: 314332428
*/

/*
Función que recibe dos chars, que pueden ser 1 o 0 y hace la operación AND
con ellos.
*/
char logical_and(char a, char b) {
    if (a == '1' && b == '1') {
        return '1';
    } else {
        return '0';
    }
}

/*
Función que recibe dos chars, que pueden ser 1 o 0 y hace la operación OR
con ellos.
*/
char logical_or(char a, char b) {
    if (a == '1' || b == '1') {
        return '1';
    } else {
        return '0';
    }
}

/*
Función que recibe dos cadenas de 0s y 1s, y hace la operación AND
con ellas, invocando la función logical_and con cada char de cada
cadena.
*/
char *string_and(char *a, char *b) {
    char *str = (char *) malloc(sizeof(char) * 33);
    for (int i = 0; i < 32 ; i++) {
        str[i] = logical_and(a[i], b[i]);
    }
    str[32] = '\0';
    return str;
}

/*
Función que recibe dos cadenas de 0s y 1s, y hace la operación OR
con ellas, invocando la función logical_and con cada char de cada
cadena.
*/
char *string_or(char *a, char *b) {
    char *str = (char *) malloc(sizeof(char) * 33);
    for (int i = 0; i < 32 ; i++) {
        str[i] = logical_or(a[i], b[i]);
    }
    str[32] = '\0';
    return str;
}

/*
Función que recibe dos cadenas de 0s y 1s, y hace una suma binaria
con ellas.
*/
char* add_binary(char* str1, char* str2) {
    int carry = 0;
    char* result = (char*)malloc(33 * sizeof(char));
    result[32] = '\0';

    for (int i = 31; i >= 0; i--) {
        int digit1 = str1[i] - '0';
        int digit2 = str2[i] - '0';
        int sum = digit1 + digit2 + carry;
        carry = sum / 2;
        int digit_sum = sum % 2;
        result[i] = digit_sum + '0';
    }

    return result;
}

/*
Función que recibe una cadena de 0s y 1s, devuelve el complemento
a dos correspondiente a dicha cadena.
*/
char* twos_comp(char* s) {
    char *str = (char *) malloc(sizeof(char) * 33);
    for (int i = 0; i < 32; i++) {
        if (s[i] == '0') {
            str[i] = '1';
        } else {
            str[i] = '0';
        }
    }
    return add_binary(str, "00000000000000000000000000000001");
}

/*
Función que recibe dos cadenas de 0s y 1s, y hace una resta con ellas, obteniendo
el complemento a dos de la segunda cadena y después sumando la primer cadena
con dicho complemento a 2 de la segunda cadena.
*/
char* subtract_binary(char* str1, char* str2) {
    int borrow = 0;
    char* result = (char*)malloc(33 * sizeof(char));
    result[32] = '\0';
    char* new_str2 = twos_comp(str2);
    result = add_binary(str1, new_str2);
    return result;
}

/*
Función que recibe dos cadenas de 0s y 1s, convierte dichas cadenas al número
en decimal que representan y después revisa si son iguales.
*/
char* igualdad(char* a, char* b) {
    long decimalNum1 = strtol(a, NULL, 2);
    long decimalNum2 = strtol(b, NULL, 2);
    if (decimalNum1 == decimalNum2) {
        return "00000000000000000000000000000001";
    } else {
        return "00000000000000000000000000000000";
    }
}

/*
Función que recibe dos cadenas de 0s y 1s, convierte dichas cadenas al número
en decimal que representan y después revisa si el número representado por la
primer cadena es menor al número represe por la segunda.
*/
char* menor_que(char* a, char* b) {
    long decimalNum1 = strtol(a, NULL, 2); // convert the binary string to a decimal number
    long decimalNum2 = strtol(b, NULL, 2); // convert the binary string to a decimal number
    if (decimalNum1 < decimalNum2) {
        return "00000000000000000000000000000001";
    } else {
        return "00000000000000000000000000000000";
    }
}

/*
Función que recibe dos cadenas de 0s y 1s de longitud 32 y una de longitud 3, y
dependiendo de qué cadena sea la de longitud 3, ejecuta con las cadenas de longitud
32 una de las operaciones implementadas en la ALU.
*/
char* alu(char* opA, char* opB, char* op) {
    if (op == "000") {
        return string_and(opA, opB);
    } else if (op == "001") {
        return string_or(opA, opB);
    } else if (op == "010") {
        return add_binary(opA, opB);
    } else if (op == "011") {
        return subtract_binary(opA, opB);
    } else if (op == "100") {
        return igualdad(opA, opB);
    } else if (op == "101") {
        return menor_que(opA, opB);
    } else {
        return "Opción inválida.";
    }

}

int main() {
    // Pruebas que se fueron haciendo con cada implementación de cada función.
    // printf("%c\n", logical_and('0','0'));
    // printf("%c\n", logical_and('0','1'));
    // printf("%c\n", logical_and('1','0'));
    // printf("%c\n", logical_and('1','1'));
    // char str[5];
    // str[0] = logical_and('0','0');
    // str[1] = logical_and('0','1');
    // str[2] = logical_and('1','0');
    // str[3] = logical_and('1','1');
    // str[4] = '\0';
    // printf("%s\n", str);
    // printf("%s\n", string_and("00000000000000000000000000000101", "11111111111111111111111111111011"));
    // printf("%s\n", string_and("10011010101100101100100101101101","01010101010101010101010101010101"));
    // printf("%s\n", string_or("00000000000000000000000000000101", "11111111111111111111111111111011"));
    // printf("%s\n", string_or("10011010101100101100100101101101","01010101010101010101010101010101"));
    // printf("%s\n", add_binary("00000000000000000000000000001100","00000000000000000000000000000001"));
    // printf("%s\n", subtract_binary("00000000000000000000000000001100","00000000000000000000000000000001"));
    // char* a = "00000000000000001110110101000000";
    // char* b = twos_comp(a);
    // printf("%s\n", b);
    // printf("%s\n", igualdad("00000000000000000000000000001100","00000000000000000000000000000001"));
    // printf("%s\n", igualdad("00000000000000000000000000001100","00000000000000000000000000001100"));
    // printf("%s\n", menor_que("00000000000000000000000000001100","00000000000000000000000000000001"));
    // printf("%s\n", menor_que("00000000000000000000000000000001","00000000000000000000000000001100"));

    // Se deja una prueba con distintos números de las operaciones que puede ejecutar la ALU, junto con
    // una última prueba que muestra que no ejecutará una función que no coincida con las cadenas de
    // longitud 3 que fueron programadas.
    printf("%s\n", alu("00000000000000000000000000000001","00000000000000000000000000001100", "000"));
    printf("%s\n", alu("00000000000000000000000000000001","00000000000000000000000000001100", "001"));
    printf("%s\n", alu("00000000000000000000000000000001","00000000000000000000000000001100", "010"));
    printf("%s\n", alu("00000000000000000000000000001100","00000000000000000000000000000001", "011"));
    printf("%s\n", alu("00000000000000000000000000000001","00000000000000000000000000001100", "100"));
    printf("%s\n", alu("00000000000000000000000000000001","00000000000000000000000000001100", "101"));
    printf("%s\n", alu("00000000000000000000000000000001","00000000000000000000000000001100", "111"));
    return 0;
}
