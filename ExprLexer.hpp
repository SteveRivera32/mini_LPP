#ifndef __ExprLexer_HPP__
#define __ExprLexer_HPP__

#include <iosfwd>
#include <string>
#include "ExprParserImpl.hpp"

enum class Token: int {
    Eof = 0,
    ERROR = 256,
    UNDEFINE = 257,
    OP_ADD = 258,
    OP_SUB = 259,
    OP_MULT = 260,
    ASIGNACION = 261,
    POTENCIA = 262,
    COMP_MENORQUE = 263,
    COMP_MAYORQUE = 264,
    COMP_IGUALQUE = 265,
    COMP_DISTINTOQUE = 266,
    COMP_MENORIGUALQUE = 267,
    COMP_MAYORIGUALQUE = 268,
    OPEN_PAR = 269,
    CLOSE_PAR = 270,
    OPEN_BRACKET = 271,
    CLOSE_BRACKET = 272,
    COMA = 273,
    DOS_PUNTOS = 274,
    NUMERO = 275,
    IDENTIFICADOR = 276,
    BOOLEANO = 277, //no se si es necesario
    CARACTER = 278,
    CADENA = 279,

    //Palabras reservadas
    RES_ENTERO = 280,
    RES_CADENA = 281,
    RES_BOOLEANO = 282,
    RES_CARACTER = 283,
    RES_ARREGLO = 284,
    RES_DE = 285,
    RES_FUNCION = 286,
    RES_PROCEDIMIENTO = 287,
    RES_VAR = 288,
    RES_INICIO = 289,
    RES_FIN = 290,
    RES_FINAL = 291,
    RES_SI = 292,
    RES_ENTONCES = 293,
    RES_SINO = 294,
    RES_PARA = 295,
    RES_MIENTRAS = 296,
    RES_HAGA = 297,
    RES_LLAMAR = 298,
    RES_REPITA = 299,
    RES_O = 300,
    RES_Y = 301,
    RES_NO = 302,
    RES_DIV = 303,
    RES_MOD = 304,
    RES_LEA = 305,
    RES_ESCRIBA = 306,
    RES_RETORNE = 307,
    RES_TIPO = 308,
    RES_ES = 309,
    RES_REGISTRO = 310,
    RES_ARCHIVO = 311,
    RES_SECUENCIAL = 312,
    RES_ABRIR = 313,
    RES_COMO = 314,
    RES_LECTURA = 315,
    RES_ESCRITURA = 316,
    RES_CERRAR = 317,
    RES_LEER = 318,
    RES_ESCRIBIR = 319,
    RES_VERDADERO = 320,
    RES_FALSO = 321,
    RES_HASTA = 322,
};

class ExprLexer
{
public:
    using yyscan_t = void*;
    //using ParserValueType = std::variant<std::string, double>;


public:
    ExprLexer(std::istream& _in);
    ~ExprLexer();

    Token nextToken(ParserValueType *lval) { return nextTokenHelper(yyscanner, lval); }

    std::string text() const;

    static const char *tokenString(Token tk);

    int getLine() const;

    Token searchReservedWord(std::string word);

private:
    Token nextTokenHelper(yyscan_t yyscanner, ParserValueType *lval);

private:
    std::istream& in;
    yyscan_t yyscanner;
};

#endif
