#include <stdio.h>

void arregloMasUno(long size, int arr[]){
	for (int i = 0; i < size; i++){
		arr[i]= arr[i]+1;
		printf("Valor de arreglo[%d] :%d\n", i, arr[i]);
	}
}


int main () {
	int  var = 20;   //Declaracion de la variable
	int  *apunta;        //Declaracion del apuntador.

	apunta = &var;  //Asignacion del apuntador
	//&var nos da el valor Hexadecimal
	printf("Direccion de la variable var: %p\n", &var  );


	printf("Direccion guardada en la variable apunta: %p\n", apunta );

	//Accedemos al valor usando el apuntador
	printf("Valor de la variable a la que apunta *apuntador : %d\n", *apunta );
	printf("Valor de la variable var: %d\n", var);

	int arreglo[5]={0,1,2,3,4};Por favor, lean detenidamente las instrucciones de la practica.
	long size = sizeof(arreglo) / sizeof(arreglo[0]);
	printf(" Longitud de arr: %ld\n",size);
	arregloMasUno(size, arreglo);
	return 0;
}
