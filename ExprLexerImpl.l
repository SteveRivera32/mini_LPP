%option noyywrap
%option reentrant
%option yylineno
%option extra-type = "std::istream *"

%{
#include <iostream>
#include <cstdlib>
#include "ExprLexer.hpp"
#include "ExprAst.hpp"

#define YY_DECL Token ExprLexer::nextTokenHelper(yyscan_t yyscanner, ParserValueType *lval)
#define yyterminate() return Token::Eof

#define YY_INPUT(buf, result, max_size) \
    { \
        auto *in = yyget_extra(yyscanner); \
        in->read(buf, max_size); \
        result = in->gcount(); \
    }
%}

%x comment

%%
[ \t\n]	        { }
"//"[^\n]*\n    { }
"/*"    { BEGIN(comment); }
"+"		{ return Token::OP_ADD; }
"-"     { return Token::OP_SUB; }
"*"		{ return Token::OP_MULT; }
"<-"	{ return Token::ASIGNACION; }
"^"		{ return Token::POTENCIA; }
"<"		{ return Token::COMP_MENORQUE; }
">"		{ return Token::COMP_MAYORQUE; }
"="     { return Token::COMP_IGUALQUE; }
"<>"    { return Token::COMP_DISTINTOQUE; }
"<="    { return Token::COMP_MENORIGUALQUE; }
">="    { return Token::COMP_MAYORIGUALQUE; }
"("		{ return Token::OPEN_PAR; }
")"		{ return Token::CLOSE_PAR; }
"["     { return Token::OPEN_BRACKET; }
"]"     { return Token::CLOSE_BRACKET; }
","     { return Token::COMA; }
":"     { return Token::DOS_PUNTOS; }
"\'"[a-zA-Z0-9]"\'"       { *lval = new CharExpr(std::string(1, yytext[1])); return Token::CARACTER; }
"\"".*"\""                { *lval = new StringExpr(std::string(yytext + 1, yyleng - 2)); return Token::CADENA; }
[0-9]+(\.[0-9]+)?	      { *lval = new NumExpr(std::atof(yytext)); return Token::NUMERO; }
[a-zA-Z_][a-zA-Z0-9_]*    { *lval = new IdentExpr(std::string(yytext)); return searchReservedWord(std::string(yytext)); }
.		                  { std::cerr << "Invalid symbol\n"; return Token::ERROR; }

<comment>"*/" { BEGIN(INITIAL); }
<comment>.|\n { /* Nothing */ }
<comment><<EOF>> { std::cerr << "Warning: Block comment without close\n";  }
%%
