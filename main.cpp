#include <iostream>
#include <fstream>
#include "ExprLexer.hpp"
#include "ExprParser.hpp"

std::string runASM(std::string name_file ,std::string code)
{
    std::ofstream archivo;
    archivo.open(name_file, std::ios::out | std::ios::trunc);
    if (!archivo.is_open()) {
       throw std::runtime_error("Failed to open asm file for writing!");
    }
    archivo << code;
    archivo.close();
};

int main(int argc, char *argv[]) 
{
    if (argc != 3) {
        std::cerr << "Not enough CLI arguments\n";
        return 1;
    }
    

    std::string LPPFileName = argv[1];
    std::string ASMFileName = argv[2];

    std::ifstream in(LPPFileName, std::ios::in);

    if (!in.is_open()) {
        std::cerr << "Cannot open file\n";
        return 1;
    }

    ExprLexer lexer(in);
    ExprParser parser(lexer);

    try {
        parser.parse();
        runASM(ASMFileName, parser.getCode());

        return 0;

    } catch(const std::runtime_error ex){
        std::cerr << ex.what() << "\n"; 
        return 1;  
    }
}
