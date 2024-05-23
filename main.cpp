#include <iostream>
#include <fstream>
#include "ExprLexer.hpp"
#include "ExprParser.hpp"

int main(int argc, char *argv[]) 
{
    if (argc != 2) {
        std::cerr << "Not enough CLI arguments\n";
        return 1;
    }
    std::ifstream in(argv[1], std::ios::in);

    if (!in.is_open()) {
        std::cerr << "Cannot open file\n";
        return 1;
    }

    ExprLexer lexer(in);
    ExprParser parser(lexer);

    try {
        parser.parse();
        for (std::string value : parser.getValues()) {
            std::cout << value << "\n";
        }

    } catch(const std::runtime_error ex){
        std::cerr << ex.what() << "\n";   
    }
}