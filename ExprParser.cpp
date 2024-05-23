#include <unordered_map>
#include "ExprParser.hpp"

int ExprParser::parse()
{
    return yyparse(*this);
}

std::string ExprParser::searchIdentValue(const std::string& cname) const
{
    // Values taken from https://en.wikipedia.org/wiki/List_of_mathematical_constants
    static std::unordered_map<std::string, std::string> cmap = {
        {"Pi", "3.14159"}, // Ratio of a circle's circumference to its diameter
        {"Tau", "6.28319"}, // Ratio of a circle's circumference to its radius
        {"SrTwo", "1.41421"}, // Square root of 2. Pythagoras constant
        {"SrThree", "1.73205"}, // Square root of 3. Theodorus' constant
        {"Phi", "1.61803"}, // Golden ratio
        {"E", "2.71828"}, // Euler's number
    };

    auto it = cmap.find(cname);
    if(it == cmap.end()){
        auto it2 = identValues.find(cname);
        return (it2 == identValues.end())? "0.0" : it2->second;
    } else
        return it->second;

}