#ifndef __EXPR_PARSER_HPP__
#define __EXPR_PARSER_HPP__

#include "ExprParserImpl.hpp"
#include "ExprLexer.hpp"
#include <vector>
#include <unordered_map>
#include <iostream>
#include <algorithm>

class ExprParser {
public:
    ExprParser(ExprLexer& lexer) :
        lexer(lexer)
    {}

    int parse();

    void addValue(std::string value){
        printValues.push_back(value);
    }

    void addDeclaratedIdentifiers(std::string type){
        if(tempArrayType != ""){
            for(auto ident : tempVector){
            declaratedIdentifiers[ident] = type;
            }
        } else {
            for(auto ident : tempVector){
            declaratedIdentifiers[ident] = tempArrayType;
            }
        }
        tempVector.clear();
        tempArraySize = "";
        tempArrayType = "";
    }

    std::vector<std::string> getValues(){
        return printValues;
    }

    ExprLexer& getLexer() const {
        return lexer;
    }

    std::string searchIdentValue(const std::string& cname) const;

    void setIdentValue(std::string& ident, std::string value){
        if(declaratedIdentifiers.find(ident) != declaratedIdentifiers.end()){
            identValues[ident] = value;
        }
    }

    void createArray(std::string type, std::string size){
        tempArrayType = type;
        tempArraySize = size;
    }

    void addTempValue(std::string value){
        if(tempArraySize != ""){
            for(int i = 0; i <= std::stoi(tempArraySize); i++){
                tempVector.push_back(value + "[" + std::to_string(i) + "]");
            }
        } else {
            tempVector.push_back(value);
        }
    }

private:
    ExprLexer& lexer;
    std::vector<std::string> printValues, tempVector;
    std::unordered_map<std::string, std::string> identValues, declaratedIdentifiers;
    std::string tempArraySize = "", tempArrayType = "";
};

#endif