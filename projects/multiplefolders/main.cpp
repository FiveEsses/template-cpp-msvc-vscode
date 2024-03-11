#include <iostream>
#include <string>

using namespace std;

double add(double a, double b);
double subtract(double a, double b);
double multiply(double a, double b);
double divide(double a, double b);
double square(double a);

int main()
{
    double a;
    double b;
    cout << "Please enter two numbers:" << endl << endl;

    cin >> a >> b;

    cout << endl << endl;
    cout << "All right!:" << endl;
    cout << "add(" << a << ", " << b << ");      =>  " << add(a, b) << endl;
    cout << "subtract(" << a << ", " << b << "); =>  " << subtract(a, b) << endl;
    cout << "multiply(" << a << ", " << b << "); =>  " << multiply(a, b) << endl;
    cout << "divide(" << a << ", " << b << ");   =>  " << divide(a, b) << endl;
    cout << "square(" << a << ");      =>  " << square(a) << endl;
    cout << "square(" << b << ");      =>  " << square(b) << endl;
    
    cout << endl << endl;
    return 0;
}