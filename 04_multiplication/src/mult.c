/* C89 / DOS：与 mult.asm 输出相同的倒三角九九乘法表。 */
#include <stdio.h>

int main(void)
{
    unsigned int row;
    unsigned int column;
    unsigned int product;

    printf("The 9mul9 table:\n");
    /* 外层从 9 递减到 1；无符号数在 row == 0 时退出。 */
    for (row = 9; row != 0; --row) {
        for (column = 1; column <= row; ++column) {
            product = row * column;
            printf("%u*%u=%u", row, column, product);
            if (column != row) {
                printf("  ");
            }
        }
        printf("\n");
    }
    return 0;
}
