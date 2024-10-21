// Single-line comment: This is a sample tinyC test file.

/*
 * Multi-line comment: This file tests all lexical elements
 * specified for tinyC.
 */

int main() {
    // Keywords
    auto int_var = 10;
    char* gdf = "bch3b\tc3b\n";
    const float pi = 3.14;
    if (int_var > 0) {
        return 0;
    } else {
        break;
    }

    // Identifiers
    int variable1 = 100;
    char my_char = 'A';

    // Integer constant
    unsigned long number = 42;
    
    // Floating constant
    double decimal = 2.71828;
    
    // Character constant
    char newline = '\n';
    
    // String literal
    char* greeting = "Hello, tinyC!";
    
    // Punctuators
    int *ptr = &variable1;
    variable1 += 5;
    int result = (variable1 > 10) ? variable1 : 10;

    // Comments
    // Single-line comment example
    /* Multi-line comment example */

    // Testing all keywords
    enum Color { RED, GREEN, BLUE };
    register int r = 5;
    static int s = 10;
    volatile int v = 15;

    // Testing all punctuators
    int arr[5] = {1, 2, 3, 4, 5};
    int increment = ++variable1;
    int decrement = --variable1;
    ptr = &arr[0];
    *ptr = *ptr + 1;
    increment *= 2;
    int division = increment / 3;
    int modulus = division % 2;
    int shift_left = modulus << 1;
    int shift_right = shift_left >> 1;
    int less_than = shift_right < 10;
    int greater_than = shift_right > 5;
    int less_equal = shift_right <= 5;
    int greater_equal = shift_right >= 5;
    int equal = shift_right == 5;
    int not_equal = shift_right != 4;
    int bitwise_and = shift_right & 2;
    int bitwise_xor = bitwise_and ^ 3;
    int bitwise_or = bitwise_xor | 1;
    int logical_and = bitwise_or && 1;
    int logical_or = logical_and || 0;
    int ternary = logical_or ? 1 : 0;

    return 0;
}
