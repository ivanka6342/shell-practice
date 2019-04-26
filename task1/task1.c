/*
* Task:
*  f(2) -> "10"
*  f(5) -> "10200"
*  f(10) -> "1020030004"
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h> 
#include <string.h>

static char* str;

void f(int length){
    if (length < 1)
        return;

    int strIt = 0;
    int el = 1;
    int step = 2;

    int numSize = 1, decCount = 10;

    while (strIt < length)
    {
        sprintf(str+strIt, "%d", el);
        strIt += step+(numSize-1);
        step++;
        el++;
        if (el/decCount){
            numSize++;
            decCount *= 10;
        }
    }

    strIt = -1;
    while(strIt < length)
    {
        strIt++;
        if (str[strIt]) continue;
        str[strIt] = '0';
    }

    str[length] = '\0';
}

int main(int argc, char* argv[]){
    if (argc > 1){
        int length = atoi(argv[1]);
        int allocMemSize = ((length > 0) ? length : 0) + 1;

        str = (char*)calloc(allocMemSize, sizeof(char));

        f(length);
        (void)printf("f(%d) -> \"%s\"\n", length, str);
        
        free(str);
        str = NULL;
    }

    return 0;
}
