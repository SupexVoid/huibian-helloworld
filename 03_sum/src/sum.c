/* 作业3 C对照：16位unsigned int足以容纳5050，保留循环便于反汇编。 */
#include <stdio.h>

unsigned int sum_to(unsigned int n)
{
    unsigned int i;
    unsigned int total = 0;
    for (i = 1; i <= n; ++i) {
        total += i;
    }
    return total;
}

int main(void)
{
    printf("%u\n", sum_to(100));
    return 0;
}
