/*
* есть последовательность неотсортированных целых чисел. 
* Среди них каждое кроме одного повторяются дважды. 
* Нужно найти это единственное за один проход, используя одну переменную
* 
*  f(234 212 57 22 -23 22 212 1 57 233334 234 1 -23 123 233334) -> 123
*  f(0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5) -> 5
*  f(-235, 44, 13, 21, 44, 13, 21) -> -235

* f() -> ?
* f(1, 2, 3) -> ?
* f(1, 1, 1, 2) -> ?
* f(1, 1, 1, 1) -> ?

* f() -> ?
* f(1, 2, 3) -> ?
* f(1, 1, 1, 2) -> ?
* f(1, 1, 1, 1) -> ?
*/

#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

/*
#define START_VALUE 1

// свести ряд чисел ближе к 0 // нельзя так как результат будет зависеть от порядка аргументов
// а передача по ссылке - это плюсы? // int& sum
void analyze(int* sum, int num){
    if (abs(*sum+num) < abs(*sum-num))
        *sum += num;
    else
        *sum -= num;
}

int main(int argc, char* argv[]){
    if (argc < 2)
        return NULL; // assert() // save

    int result = START_VALUE;
    
    for (int i = 1; i < argc; i++)
        analyze(&result, atoi(argv[i]));
    
    result -= START_VALUE;

    return result;
}
*/

// recourse function
int findAlone(int argc, char* argv[]){

}

int main(int argc, char* argv[]){
    if (argc < 2)
        return 1; // assert()

    int result = 0;
    for (int i = 1; i < argc; i++){
        result = result ^ atoi(argv[i]);
    }

    (void)printf("result = %d\n", result);
    
    return 0;
}