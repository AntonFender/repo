#include <fstream>
#include <string>
#include <vector>
#include <sstream>

using namespace std;

const string f2reginfo_filename="./cache/FORM2REGINFO.xml";
const string wb_filename="./cache/WayBill_v3.xml";
const string csv_filename="./cache/out.csv";

struct f2info 
{
    string Identity;
    string InformF2RegId;
};

struct wbinfo 
{
    string Identity;
    string FARegId;
    string F2RegId;
    string AlcCode;
    vector<string> amclist;
    unsigned amccount;
};

int main(int argc, char* argv[])
{
    if (argc != 2) return(0);

    string fsrarid = argv[1];

    ofstream _out(csv_filename);
    ifstream _in1(f2reginfo_filename);
    vector<string> v_f2;

    ifstream _in2(wb_filename);
    vector<string> v_wb;

    while (!_in1.eof())
    {
	string line = "";
	_in1 >> line;
	if (line != "")	v_f2.push_back(line);
    }

    while (!_in2.eof())
    {
	string line = "";
	_in2 >> line;
	if (line != "")	v_wb.push_back(line);
    }

    while (v_f2[0].find("wbr:Position") == string::npos)
    {
	vector<string>::iterator it = v_f2.begin();
	v_f2.erase(it);
	if (v_f2.empty())
	{
	    _out << "An error occurred while reading f2reginfo file: no Position tag found." << endl;
	    return(2);
	}
    }

    vector<string> position1;
    vector<f2info> v_f2i;

    for (unsigned i = 0; i < v_f2.size(); ++i)
    {
	position1.push_back(v_f2[i]);
	if ((v_f2[i].find("</wbr:Position>") != string::npos) || (i == v_f2.size() - 1))
	{
	    //parse position1 array here
	    f2info f2i;
	    f2i.Identity = "Tag not found";
	    f2i.InformF2RegId = "Tag not found";
	    for (unsigned j = 0; j < position1.size(); ++j)
	    {
		if (position1[j].find("wbr:Identity") != string::npos)
		{
		    unsigned pos_brace1 = position1[j].find_first_of(">");
		    unsigned pos_brace2 = position1[j].find_last_of("<");
		    unsigned pos_count = pos_brace2 - pos_brace1 - 1;
		    f2i.Identity = position1[j].substr(pos_brace1 + 1, pos_count);
		}
		if (position1[j].find("wbr:InformF2RegId") != string::npos)
		{
		    unsigned pos_brace1 = position1[j].find_first_of(">");
		    unsigned pos_brace2 = position1[j].find_last_of("<");
		    unsigned pos_count = pos_brace2 - pos_brace1 - 1;
		    f2i.InformF2RegId = position1[j].substr(pos_brace1 + 1, pos_count);
		}
	    }
	    if ((f2i.Identity != "Tag not found") && (f2i.InformF2RegId != "Tag not found")) v_f2i.push_back(f2i);
	    position1.clear();
	}
    }

    while (v_wb[0].find("wb:Position") == string::npos)
    {
	vector<string>::iterator it = v_wb.begin();
	v_wb.erase(it);
	if (v_wb.empty())
	{
	    _out << "An error occurred while reading waybill_v3 file: no Position tag found." << endl;
	    return(2);
	}
    }

    position1.clear();
    vector<wbinfo> v_wbi;

    for (unsigned i = 0; i < v_wb.size(); ++i)
    {
	position1.push_back(v_wb[i]);
	if ((v_wb[i].find("</wb:Position>") != string::npos) || (i == v_wb.size() - 1))
	{
	    wbinfo wbi;
	    wbi.Identity = "Tag not found";
	    wbi.FARegId = "Tag not found";
	    wbi.F2RegId = "Tag not found";
	    wbi.AlcCode = "Tag not found";
	    wbi.amclist.clear();
	    wbi.amccount = 0;
	    for (unsigned j = 0; j < position1.size(); ++j)
	    {
		if (position1[j].find("wb:Identity") != string::npos)
		{
		    unsigned pos_brace1 = position1[j].find_first_of(">");
		    unsigned pos_brace2 = position1[j].find_last_of("<");
		    unsigned pos_count = pos_brace2 - pos_brace1 - 1;
		    wbi.Identity = position1[j].substr(pos_brace1 + 1, pos_count);
		}
		if (position1[j].find("<pref:AlcCode") != string::npos)
		{
		    unsigned pos_brace1 = position1[j].find_first_of(">");
		    unsigned pos_brace2 = position1[j].find_last_of("<");
		    unsigned pos_count = pos_brace2 - pos_brace1 - 1;
		    wbi.AlcCode = position1[j].substr(pos_brace1 + 1, pos_count);
		}
		if (position1[j].find("wb:FARegId") != string::npos)
		{
		    unsigned pos_brace1 = position1[j].find_first_of(">");
		    unsigned pos_brace2 = position1[j].find_last_of("<");
		    unsigned pos_count = pos_brace2 - pos_brace1 - 1;
		    wbi.FARegId = position1[j].substr(pos_brace1 + 1, pos_count);
		}
		if (position1[j].find("ce:F2RegId") != string::npos)
		{
		    unsigned pos_brace1 = position1[j].find_first_of(">");
		    unsigned pos_brace2 = position1[j].find_last_of("<");
		    unsigned pos_count = pos_brace2 - pos_brace1 - 1;
		    wbi.F2RegId = position1[j].substr(pos_brace1 + 1, pos_count);
		}
		if (position1[j].find("ce:amc>") != string::npos)
		{
		    unsigned pos_brace1 = position1[j].find_first_of(">");
		    unsigned pos_brace2 = position1[j].find_last_of("<");
		    unsigned pos_count = pos_brace2 - pos_brace1 - 1;
		    wbi.amclist.push_back(position1[j].substr(pos_brace1 + 1, pos_count));
		    ++wbi.amccount;
		}
	    }
	    if ((wbi.Identity != "Tag not found") && (wbi.FARegId != "Tag not found") && (wbi.F2RegId != "Tag not found")) v_wbi.push_back(wbi);
	    position1.clear();
	}
    }

    _out << "Num;FSRAR_ID;Identity;AlcCode;FARegId;F2RegId;InformF2RegId;amccount;amclist" << endl;
    for (unsigned i = 0; i < v_wbi.size(); ++i)
    {
	unsigned j = 0;
	string res_str = "";
	stringstream _sss;
	_sss.clear();
	//res_str += i + 1;
	for ( ; j < v_f2i.size(); ++j)
	{
	    if (v_f2i[j].Identity == v_wbi[i].Identity) break;
	}
	//_out << i + 1 << ";" << v_wbi[i].Identity << ";" << v_wbi[i].AlcCode << ";" << v_wbi[i].FARegId << ";" << v_wbi[i].F2RegId << ";";
	_sss << i + 1 << ";" << fsrarid << ";" << v_wbi[i].Identity << ";" << v_wbi[i].AlcCode << ";" << v_wbi[i].FARegId << ";" << v_wbi[i].F2RegId << ";";
	if (j != v_f2i.size())
	{
	    //_out << v_f2i[j].InformF2RegId << ";";
	    _sss << v_f2i[j].InformF2RegId << ";";
	}
	else
	{
	    //_out << "Position with identity " << v_wbi[i].Identity << " not found in TTNInformF2Reg file FORM2REGINFO.xml;";
	    _sss << "Position with identity " << v_wbi[i].Identity << " not found in TTNInformF2Reg file FORM2REGINFO.xml;";
	}
	//_out << v_wbi[i].amccount << ";";
	_sss << v_wbi[i].amccount << ";";
	res_str = _sss.str();
	if (v_wbi[i].amclist.empty())
	{
	    _out << res_str << endl;
	    _out.flush();
	    continue;
	}
	//_out << v_wbi[i].amclist << endl;
	for (unsigned k = 0; k < v_wbi[i].amclist.size(); ++k)
	{
	    _out << res_str << v_wbi[i].amclist[k] << endl;
	    _out.flush();
	}
	_out.flush();
    }

    _in1.close();
    _in2.close();
    _out.close();
    return(0);
}