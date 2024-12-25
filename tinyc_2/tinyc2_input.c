// Global variable declarations
int globalVar = 10;
const float PI = 3.14159;

// Function prototype
int calculateSum(int a, int b);



int main() {
    // Variable declarations
    int x = 5, y = 10;
    float z = 3.14;
    char ch = 'A';
    
    // Array declaration and initialization
    int arr[5] = {1, 2, 3, 4, 5};
    
    // Pointer declaration
    int *ptr = &x;
    
    // Function call
    int sum = calculateSum(x, y);
    
    // Arithmetic expressions
    int result = (x + y) * z / 2;
    
    // Bitwise operations
    int bitwiseResult = x & y;
    
    // Logical expressions
    int logicalResult = (x > y) && (z < 5.0) || (ch == 'A');


if (x<y)
{
    /* code */
    x+=y;
}
else
    {
     y-=x;
    }


    for(x;x<10;x++)
    {
        x+=y;
    }

    do
    {
    
        x++;
    } while (x<y
    );
    


    }

// Function definition
int calculateSum(int a, int b) {
    return a + b;
}