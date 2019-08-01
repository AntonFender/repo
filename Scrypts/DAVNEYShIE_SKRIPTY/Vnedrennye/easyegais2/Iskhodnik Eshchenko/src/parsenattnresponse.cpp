#include <fstream>
#include <string>
#include <iostream>

using namespace std;

int main(int argc, char* argv[])
{
    if (argc != 2) return(0);

    string filename = argv[1];
    ifstream _in;
    _in.open(filename);

    while (!_in.eof())
    {
	string line;
	_in >> line;
	size_t pos_start = line.find("<url>");
	size_t pos_finish = line.find("</url>");
	if ((pos_start != string::npos) && (pos_finish != string::npos) && (pos_finish > pos_start))
	{
	    cout << line.substr(pos_start + 5, pos_finish - pos_start - 5);
	    _in.close();
	    return(0);
	}
    }

    _in.close();
    return(0);
}