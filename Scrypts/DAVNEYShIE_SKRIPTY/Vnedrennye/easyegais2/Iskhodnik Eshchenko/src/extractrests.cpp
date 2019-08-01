#include <string>
#include <fstream>
#include <iostream>
#include <vector>

using namespace std;

struct rest
{
    string quantity;
    string informbregid;
    string alccode;
    string productvcode;
};

vector<string> lines;
vector<rest> rests;
vector<string> beercodes;

bool isBeer(string _code)
{
    for (int i = 0; i < beercodes.size(); ++i)
    {
	if (beercodes[i] == _code)
	    return(true);
    }
    return(false);
}

int main(int argc, char* argv[])
{
    if (argc == 1) return(0);

    for (int i = 1; i < argc; ++i)
    {
	beercodes.push_back(argv[i]);
    }

    string filename = "./cache/ReplyRests.xml";

    ifstream _in;
    _in.open(filename);

    if (!_in.is_open())
    {
	return(0);
    }

    string text = "";

    while (!_in.eof())
    {
	string buf = "";
	_in >> buf;
	text += buf;
    }

    bool in_tag = false;
    string buf = "";
    for (int i = 0; i < text.length(); ++i)
    {
	if ((text[i] == '<') && !in_tag)
	{
	    if (!buf.empty())
	    {
		lines.push_back(buf);
		buf.clear();
	    }
	    in_tag = true;
	    buf += text[i];
	    continue;
	}
	if ((text[i] == '>') && in_tag)
	{
	    in_tag = false;
	    buf += text[i];
	    lines.push_back(buf);
	    buf.clear();
	    continue;
	}
	buf += text[i];
    }

    /*ofstream _out;
    _out.open("11111.xml");
    for (int i = 0; i < lines.size(); ++i)
    {
	_out << lines[i] << endl;
    }*/

    
    for (int i = 0; i < lines.size(); ++i)
    {
	if (lines[i].find("<rst:StockPosition") != string::npos)
	{
	    rest REST;
	    REST.quantity = lines[i + 2];
	    REST.informbregid = lines[i + 8];
	    REST.alccode = lines[i + 15];
	    REST.productvcode = lines[i + 24];
	    if (REST.productvcode.find("ClientRegId") != string::npos) REST.productvcode = lines[i + 21];
	    rests.push_back(REST);
	}
    }

    vector<rest> rests_unmarked;
    for (int i = 0; i < rests.size(); ++i)
    {
	//if ((rests[i].productvcode == "500")||(rests[i].productvcode == "520")||(rests[i].productvcode == "261")||(rests[i].productvcode == "262"))
	if (isBeer(rests[i].productvcode))
	{
	    rests_unmarked.push_back(rests[i]);
	}
    }
    
    ofstream _out;
    _out.open("./cache/rests.list");
    for (int i = 0; i < rests_unmarked.size(); ++i)
    {
	_out << rests_unmarked[i].quantity << "\t" << rests_unmarked[i].alccode << "\t" << rests_unmarked[i].informbregid << endl;
    }
    _out.flush();
    _out.close();
    cout << rests_unmarked.size();

    //cout << text;

    //char ch;
    //cin >> ch;

    _in.close();
    return(0);
}