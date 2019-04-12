/*
* Task:
*  f(2) -> "10"
*  f(5) -> "10200"
*  f(10) -> "1020030004"
*/

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h> 

void f_v1(int length, char* str)
{
    int num = 0, zeroCount = 0, i = 0;
    bool flagNum = true;

    while(i < length)
    {
        if(!flagNum)
        {
            str[i] = '0';
            i++;
            zeroCount++;
            if (zeroCount == num)
                flagNum = true;
        }
        else
        {
            sprintf(str+i, "%d", num+1);
            num++;
            i++;
            flagNum = false;
            zeroCount = 0;
        }
    }
    str[i] = '\0';
}

void f_v2(int n)
{
    if (n < 0)
    {
        printf("f_v2: %d is incorrect argument\n", n);
        return;
    }

    char* str = (char*)calloc(n+1, sizeof(char));
    int i = 0, el = 1, step = 2;
    while (i < n)
    {
        sprintf(str+i, "%d", el);
        i += step;
        step++;
        el++;
    }

    i = -1;
    while(i < n)
    {
        i++;
        if (str[i] | 0x00)
            continue;
        str[i] = '0';
    }

    str[n] = '\0';
    printf("f_v2(%d) -> \"%s\"\n", n, str);
    free(str);
}

int main(int argc, char* argv[])
{
    int n = atoi(argv[1]);

    char* str = (char*)malloc(n*sizeof(char)+1);
    f_v1(n, str);
    printf("f_v1(%d) -> \"%s\"\n", n, str);
    free(str);
    
    f_v2(n);

    return 0;
}
