
#include <stdio.h>
#include <stdlib.h>

int pwr(int a, int b) {
    int ans =1;
    while(b)
    {
        if(b%2)ans *= a;
        a*=a;
        b=b>>1;
    }
    
    return ans;
}

void mprn(int mem[], int index) {
    printf("+++ MEM[%d] is set to %d\n",index, mem[index]);
}

void eprn(int r[], int index) {
    printf("+++ Standalone expression evaluates to %d\n", r[index]);
}
