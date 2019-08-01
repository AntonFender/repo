#include <fstream>
#include <string>
#include <iostream>

using namespace std;

int main()
{
    ifstream _in;
    _in.open("C:\Users\MainPage");

    while (!_in.eof())
    {
	string line;
	_in >> line;
	size_t pos = line.find("FSRAR-RSA-");
	if (pos != string::npos)
	{
	    cout << line.substr(pos + 10, 12);
	    _in.close();
	    return(0);
	}
    }

    _in.close();
    return(0);
}