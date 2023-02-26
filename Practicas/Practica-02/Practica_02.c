
#include <stdio.h> 
#include <stdlib.h>
#include <math.h>

float media_aritmetica(float datos[], int n) {  
    float suma = 0;
    for (int i = 2; i < n; i++) {
        suma += datos[i];
    }
    float total = (float)n-2;
    float resultado = suma/total;
    return resultado;
}

float media_armonica(float datos[], int n) {
    float suma = 0;
    for (int i = 2; i < n; i++) {
        suma += 1/datos[i];
    }
    float total = (float)n-2;
    float resultado = total/suma;
    return resultado;
}

float media_geometrica(float datos[], int n) {
    float producto = 1;
    for (int i = 2; i < n; i++) {
        producto *= datos[i];
    }
    float raiz = n-2;
    float resultado = pow(producto, 1/raiz);
    return resultado;
}

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

    // printf("%f", media_aritmetica(datos, argc));
    // printf("%f", media_armonica(datos, argc));
    printf("%f", media_geometrica(datos, argc));
    
}