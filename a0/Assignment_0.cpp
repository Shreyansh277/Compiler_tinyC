/*Name - Ansh Sahu
Roll No - 22cs30010
Assignment - 0
*/

#include <bits/stdc++.h>
using namespace std;

int evalexpression(const string &);

int evalsum(const string, int);
int precedence(char);
bool is_operator(char);
bool is_digit(char);


int evalsum(stack<char> &operators, stack<int> &operands)
{
    // int result = evalterm(operators, operands);

    // while (!operators.empty() && operators.top() == '*')
    // {
    //     operators.pop(); // Consume the '*'
    //     result *= evalterm(operators, operands);
    // }

    // return result;
    return 0;
}

int evalterm(stack<char> &operators, stack<int> &operands)
{

//     char top = operators.top();


//     operators.pop();

//    int result = evalsum(operators, operands);
//         operators.pop();
//         return result;
return 0;
}

int evalexpression(const string &expression)
{
    stack<int> operands;
    stack<char> operators;

    for (size_t i = 0; i < expression.size(); ++i)
    {
        char ch = expression[i];

        if (isspace(ch))
        {
            continue;
        }
        else if (is_digit(ch))
        {
            int num = 0;
            while (i < expression.size() && is_digit(expression[i]))
            {
                num = num * 10 + (expression[i] - '0');
                i++;
            }
            operands.push(num);
            i--;
        }
        else if (ch == '(')
        {
            operators.push(ch);
        }
        else if (ch == ')')
        {
            while (!operators.empty() && operators.top() != '(')
            {
                char op = operators.top();
                operators.pop();

                int num2 = operands.top();
                operands.pop();

                int num1 = operands.top();
                operands.pop();

                if (op == '+')
                {
                    operands.push(num1 + num2);
                }
                else if (op == '*')
                {
                    operands.push(num1 * num2);
                }
            }
            operators.pop();
        }
        else if (is_operator(ch))
        {

            while (!operators.empty() && precedence(operators.top()) >= precedence(ch))
            {
                char op = operators.top();
                operators.pop();

                int num2 = operands.top();
                operands.pop();

                int num1 = operands.top();
                operands.pop();

                if (op == '+')
                {
                    operands.push(num1 + num2);
                }
                else if (op == '*')
                {
                    operands.push(num1 * num2);
                }
            }
            operators.push(ch);
        }
    }

    while (!operators.empty())
    {
        char op = operators.top();
        operators.pop();

        int num2 = operands.top();
        operands.pop();

        int num1 = operands.top();
        operands.pop();

        if (op == '+')
        {
            operands.push(num1 + num2);
        }
        else if (op == '*')
        {
            operands.push(num1 * num2);
        }
    }

    return operands.top();
}

int precedence(char op)
{
    if (op == '+')
    {
        return 1;
    }
    else if (op == '*')
    {
        return 2;
    }
    return 0;
}

bool is_operator(char ch)
{
    return (ch == '+' || ch == '*');
}

bool is_digit(char ch)
{
    return isdigit(ch);
}

int main()
{
    string s;
    cout << "Enter the expression: ";
    getline(cin, s, '\n');

    int result = evalexpression(s);
    cout << result << endl;

    return 0;
}
