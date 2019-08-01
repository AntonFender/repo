#include <string>
#include <iostream>

using namespace std;

int main(int argc, char* argv[])
{
    if (argc != 2) return(0);

//    cout << argv[1] << endl;

    string str = argv[1];
    size_t right_bracket = str.find('>');
    size_t left_bracket = str.find("</");

    if ((right_bracket != string::npos) && (left_bracket != string::npos) && (left_bracket > right_bracket))
    {
	cout << str.substr(right_bracket + 1, left_bracket - right_bracket - 1);
    }

    return(0);
}