#include <fstream>
#include <algorithm>
#include <unordered_map>
#include "ExprLexer.hpp"
#include "ExprLexerImpl.hpp"
#include <iostream>

ExprLexer::ExprLexer(std::istream& _in)
  : in(_in)
{
    yylex_init_extra(&in, &yyscanner);
}

ExprLexer::~ExprLexer()
{
    yylex_destroy(yyscanner);
}

std::string ExprLexer::text() const
{
    return std::string(yyget_text(yyscanner));
}

const char *ExprLexer::tokenString(Token tk)
{
    return "Unknown";
}

int ExprLexer::getLine() const { 
    return yyget_lineno(yyscanner); 
}

char custom_tolower(char c) {
    if (c >= 'A' && c <= 'Z') {
        return c + ('a' - 'A');
    }
    return c;
}

Token ExprLexer::searchReservedWord(std::string word) {
    std::string lowerWord = word;

    std::transform(lowerWord.begin(), lowerWord.end(), lowerWord.begin(), custom_tolower);

    //std::cout << "Lower word: " << lowerWord << std::endl;
    static const std::unordered_map<std::string, Token> reserverWords = {
        {"entero", Token::RES_ENTERO},
        {"cadena", Token::RES_CADENA},
        {"booleano", Token::RES_BOOLEANO},
        {"caracter", Token::RES_CARACTER},
        {"arreglo", Token::RES_ARREGLO},
        {"de", Token::RES_DE},
        {"funcion", Token::RES_FUNCION},
        {"procedimiento", Token::RES_PROCEDIMIENTO},
        {"var", Token::RES_VAR},
        {"inicio", Token::RES_INICIO},
        {"fin", Token::RES_FIN},
        {"final", Token::RES_FINAL},
        {"si", Token::RES_SI},
        {"entonces", Token::RES_ENTONCES},
        {"sino", Token::RES_SINO},
        {"para", Token::RES_PARA},
        {"mientras", Token::RES_MIENTRAS},
        {"haga", Token::RES_HAGA},
        {"llamar", Token::RES_LLAMAR},
        {"repita", Token::RES_REPITA},
        {"o", Token::RES_O},
        {"y", Token::RES_Y},
        {"no", Token::RES_NO},
        {"div", Token::RES_DIV},
        {"mod", Token::RES_MOD},
        {"lea", Token::RES_LEA},
        {"escriba", Token::RES_ESCRIBA},
        {"retorne", Token::RES_RETORNE},
        {"tipo", Token::RES_TIPO},
        {"es", Token::RES_ES},
        {"registro", Token::RES_REGISTRO},
        {"archivo", Token::RES_ARCHIVO},
        {"secuencial", Token::RES_SECUENCIAL},
        {"abrir", Token::RES_ABRIR},
        {"como", Token::RES_COMO},
        {"lectura", Token::RES_LECTURA},
        {"escritura", Token::RES_ESCRITURA},
        {"cerrar", Token::RES_CERRAR},
        {"leer", Token::RES_LEER},
        {"escribir", Token::RES_ESCRIBIR},
        {"verdadero", Token::RES_VERDADERO},
        {"falso", Token::RES_FALSO},
        {"hasta", Token::RES_HASTA},
    };

    auto it = reserverWords.find(lowerWord);
    if (it != reserverWords.end()) {
        return it->second;
    } else {
        return Token::IDENTIFICADOR;
    }
}