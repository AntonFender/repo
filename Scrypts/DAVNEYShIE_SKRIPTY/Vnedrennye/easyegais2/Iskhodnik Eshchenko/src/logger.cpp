#include <fstream>
#include <iostream>
#include <string>

using namespace std;

int main(int argc, char* argv[])
{
    //cout << argc;
    if (argc != 4) return(0);

    //cout << argv[1] << endl << argv[2] << endl << argv[3] << endl;
    //return(0);

    string filename = argv[1];
    string timestamp = argv[2];
    string logstr = argv[3];

    ofstream _out;
    _out.open(filename, ios_base::app);

    _out << timestamp << "\t" << logstr << "\r\n";

    _out.flush();
    _out.close();
    return(0);
}