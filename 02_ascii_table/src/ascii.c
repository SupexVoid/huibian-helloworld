/* C89, 16-bit DOS small model; equivalent to the assembly versions. */
#include <stdio.h>

int main(void)
{
    int row;
    int column;
    int letter;

    letter = 'a';
    for (row = 0; row < 2; ++row) {
        for (column = 0; column < 13; ++column) {
            printf("%c", letter);
            ++letter;
            if (column < 12) {
                printf(" ");
            }
        }
        printf("\n");
    }
    return 0;
}
