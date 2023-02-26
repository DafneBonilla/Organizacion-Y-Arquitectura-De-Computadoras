
#include <stdio.h> 
#include <stdlib.h>


float media_aritmetica(float datos[], int n) {  
    float suma = 0;
    for (int i = 1; i < n; i++) {
        suma += datos[i];
    }
    float total;
    total = (float)n-1;
    float resultado = suma/total;
    return resultado;
}


/*
float media_armonica(float datos[], int n) {
    float resultado = 0;

    return resultado;
}

float media_geometrica(float datos[], int n) {
    float resultado = 0;

    return resultado;
}
*/

int main(int argc, char *argv[]) {
    
    float datos[argc];

    for (int i = 1; i < argc; i++) {
        datos[i] = atof(argv[i]);    
    }
    
    /*
    for (int i = 0; i < argc; i++) {
        printf("%f ", datos[i]);
    }
    return 0;
    */

    printf("%f", media_aritmetica(datos, argc));
    
}