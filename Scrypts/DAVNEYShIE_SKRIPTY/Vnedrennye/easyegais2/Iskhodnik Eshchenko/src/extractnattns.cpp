#include <string>
#include <fstream>
#include <iostream>
#include <vector>

using namespace std;

struct ttn
{
    string wbregid;
    string ttnnumber;
    string ttndate;
    string shipper;
};

vector<string> lines;
vector<ttn> ttns;

int main(int argc, char* argv[])
{

    if (argc != 2) return(0);
    string stopdate = argv[1];

    //cout << stopdate << endl;

    string filename = "./cache/ReplyNATTN.xml";

    ifstream _in;
    _in.open(filename);

    if (!_in.is_open())
    {
	retur(0);
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

    for (int i = 0; i < lines.size(); ++i)
    {
	if (lines[i].find("<ttn:WbRegID") != string::npos)
	{
	    ttn TTN;
	    TTN.wbregid = lines[i + 1];
	    TTN.ttnnumber = lines[i + 4];
	    TTN.ttndate = lines[i + 7];
	    TTN.shipper = lines[i + 10];
	    ttns.push_back(TTN);
	}
    }

    ofstream _out;
    ofstream _out_deferred;
    ofstream _out_4quick;
    _out.open("./cache/ttns.list");
    _out_deferred.open("./cache/ttns_deferred.list");
    _out_4quick.open("./cache/ttns_quick.list");
    for (int i = 0; i < ttns.size(); ++i)
    {
	if (ttns[i].ttndate <= "2018-12-31")
	{
	    _out_4quick << ttns[i].wbregid << "\t" << ttns[i].ttnnumber << "\t" << ttns[i].ttndate << "\t" << ttns[i].shipper << endl;
	    continue;
	}
	if (ttns[i].ttndate <= stopdate)
	    _out << ttns[i].wbregid << "\t" << ttns[i].ttnnumber << "\t" << ttns[i].ttndate << "\t" << ttns[i].shipper << endl;
	else
	    _out_deferred << ttns[i].wbregid << "\t" << ttns[i].ttnnumber << "\t" << ttns[i].ttndate << "\t" << ttns[i].shipper << endl;
    }
    _out.flush();
    _out_deferred.flush();
    _out_4quick.flush();
    _out.close();
    _out_deferred.close();
    _out_4quick.close();

    //cout << text;

    //char ch;
    //cin >> ch;

    _in.close();
    return(0);
}