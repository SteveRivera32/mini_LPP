%define parse.error verbose
%define api.pure full

%parse-param {ExprParser& parser}

%code top{

#include <iostream>
#include <stdexcept>
#include "ExprLexerImpl.hpp"
#include "ExprLexer.hpp"
#include "ExprParser.hpp"
#include "ExprParserImpl.hpp"

#define yylex(v) static_cast<int>(parser.getLexer().nextToken(v))

void yyerror(const ExprParser& parser, const char *msg)
{
      std::string errorMsg = "Line " + std::to_string(parser.getLexer().getLine()) + ": " + msg;
      throw std::runtime_error(msg);
}

}

%code requires {
#include <string>
#include <variant>
#include <typeinfo>
#include "ExprAst.hpp"

class ExprParser; // Forward declaration

//using ParserValueType = std::variant<std::string, double>;
using ParserValueType = AstNode *;

#define YYSTYPE ParserValueType
#define YYSTYPE_IS_DECLARED 1

}

//Este orden debe ser el mismo que en ExprLexer.hpp
%token OP_ADD "+" 
%token OP_SUB "-"
%token OP_MULT "*"
%token ASIGNACION "<-"
%token POTENCIA "^"
%token COMP_MENORQUE "<"
%token COMP_MAYORQUE ">"
%token COMP_IGUALQUE "="
%token COMP_DISTINTOQUE "<>"
%token COMP_MENORIGUALQUE "<="
%token COMP_MAYORIGUALQUE ">="
%token OPEN_PAR "("
%token CLOSE_PAR ")"
%token OPEN_BRACKET "["
%token CLOSE_BRACKET "]"
%token COMA ","
%token DOS_PUNTOS ":"
%token NUMERO "number"
%token IDENTIFICADOR "identifier"
%token BOOLEANO "boolean"
%token CARACTER "char"
%token CADENA "string"
%token RES_ENTERO "reserved word entero"
%token RES_CADENA "reserved word cadena"
%token RES_BOOLEANO "reserved word booleano"
%token RES_CARACTER "reserved word caracter"
%token RES_ARREGLO "reserved word arreglo"
%token RES_DE "reserved word de"
%token RES_FUNCION "reserved word funcion"
%token RES_PROCEDIMIENTO "reserved word procedimiento"
%token RES_VAR "reserved word var"
%token RES_INICIO "reserved word inicio"
%token RES_FIN "reserved word fin"
%token RES_FINAL "reserved word final"
%token RES_SI "reserved word si"
%token RES_ENTONCES "reserved word entonces"
%token RES_SINO "reserved word sino"
%token RES_PARA "reserved word para"
%token RES_MIENTRAS "reserved word mientras"
%token RES_HAGA "reserved word haga"
%token RES_LLAMAR "reserved word llamar"
%token RES_REPITA "reserved word repita"
%token RES_O "reserved word o"
%token RES_Y "reserved word y"
%token RES_NO "reserved word no"
%token RES_DIV "reserved word div"
%token RES_MOD "reserved word mod"
%token RES_LEA "reserved word lea"
%token RES_ESCRIBA "reserved word escriba"
%token RES_RETORNE "reserved word retorne"
%token RES_TIPO "reserved word tipo"
%token RES_ES "reserved word es"
%token RES_REGISTRO "reserved word registro"
%token RES_ARCHIVO "reserved word archivo"
%token RES_SECUENCIAL "reserved word secuencial"
%token RES_ABRIR "reserved word abrir"
%token RES_COMO "reserved word como"
%token RES_LECTURA "reserved word lectura"
%token RES_ESCRITURA "reserved word escritura"
%token RES_CERRAR "reserved word cerrar"
%token RES_LEER "reserved word leer"
%token RES_ESCRIBIR "reserved word escribir"
%token RES_VERDADERO "reserved word verdadero"
%token RES_FALSO "reserved word falso"
%token RES_HASTA "reserved word hasta"

%%

input: program {  }
;

program: subtypes-section variable-section subprogram-decl RES_INICIO statement-list RES_FIN { parser.generateASM(new Program($5)); }
;

subtypes-section: subtypes-section subtype-decl {}
      | subtype-decl {}
      |
;

subtype-decl: RES_TIPO IDENTIFICADOR RES_ES type {}
;

subprogram-decl: subprogram-header variable-section RES_INICIO statement-list RES_FIN subprogram-decl {}
      | subprogram-header variable-section RES_INICIO statement-list RES_FIN {}
      |
;

subprogram-header: RES_FUNCION IDENTIFICADOR OPEN_PAR parameters CLOSE_PAR DOS_PUNTOS type
      | RES_FUNCION IDENTIFICADOR DOS_PUNTOS type
      | RES_PROCEDIMIENTO IDENTIFICADOR OPEN_PAR parameters CLOSE_PAR
      | RES_PROCEDIMIENTO IDENTIFICADOR
;

parameters: parameters COMA type-variant IDENTIFICADOR {}
      | type-variant IDENTIFICADOR {}
;

type-variant: type {}
      | RES_VAR type {}
;

variable-section: variable-list {}
      |
;

variable-list: variable-list variable-decl {}
      | variable-decl {}
;

variable-decl: type type-list { }
;

type: RES_ENTERO {}
      | RES_BOOLEANO {}
      | RES_CARACTER {}
      | RES_CADENA {}
      | array-type {}
;

array-type: RES_ARREGLO OPEN_BRACKET NUMERO CLOSE_BRACKET RES_DE type {  }
;

type-list: IDENTIFICADOR {  }
      | type-list COMA IDENTIFICADOR {  }
;

statement-list: statement-list statement { $$ = new BlockStmt($1, $2); }
      | statement { $$ = $1; }
;

statement: RES_ESCRIBA expr { $$ = new PrintStmt($2); }
      | factor-identifier ASIGNACION expr { $$ = new AssignStmt($1, $3); }
      | RES_MIENTRAS comp-expr-list RES_HAGA statement-list RES_FIN RES_MIENTRAS { $$ = new WhileStmt($2, $4);}
      | RES_PARA IDENTIFICADOR ASIGNACION expr RES_HASTA expr RES_HAGA statement-list RES_FIN RES_PARA {}
      | if-statement {}
      | RES_RETORNE expr {}
      | RES_LLAMAR IDENTIFICADOR OPEN_PAR factor-list CLOSE_PAR {}
      | RES_LLAMAR IDENTIFICADOR {}
      | RES_LEA factor-identifier {}
;

comp-expr-list: OPEN_PAR comp-expr-list CLOSE_PAR RES_Y OPEN_PAR comp-expr CLOSE_PAR { }
      | OPEN_PAR comp-expr-list CLOSE_PAR RES_O OPEN_PAR comp-expr CLOSE_PAR { }
      | comp-expr { $$ = $1; }
;

comp-expr: expr COMP_MENORQUE expr { $$ = new LessThanExpr($1, $3); }
      | expr COMP_MAYORQUE expr { $$ = new GreaterThanExpr($1, $3); }
      | expr COMP_IGUALQUE expr { $$ = new EqualThanExpr($1, $3);}
      | expr COMP_DISTINTOQUE expr { $$ = new NotEqualThanExpr($1, $3);}
      | expr COMP_MENORIGUALQUE expr { $$ = new LessOrEqualThanExpr($1, $3);}
      | expr COMP_MAYORIGUALQUE expr { $$ = new GreaterOrEqualThanExpr($1, $3);}
      | RES_NO comp-expr {  }
;

if-statement: RES_SI comp-expr-list RES_ENTONCES statement-list else-block RES_FIN RES_SI { $$ = new IfStmt($2, $4, $5); }
;

else-block: | RES_SINO RES_SI comp-expr-list RES_ENTONCES statement-list else-block { $$ = new IfStmt($3, $5, $6); }
      | RES_SINO RES_SI comp-expr-list RES_ENTONCES statement-list-no-if else-block { $$ = new IfStmt($3, $5, $6); }
      | RES_SINO statement-list-no-if { $$ = $2; }
      //| RES_SINO statement-list {}
;

statement-list-no-if: statement-list-no-if statement-no-if { $$ = new BlockStmt($1, $2); }
      | statement-no-if { $$ = $1; }
;

statement-no-if: RES_ESCRIBA expr { $$ = new PrintStmt($2); }
      | factor-identifier ASIGNACION expr { $$ = new AssignStmt($1, $3); }
      | RES_MIENTRAS comp-expr-list RES_HAGA statement-list RES_FIN RES_MIENTRAS {}
      | RES_PARA IDENTIFICADOR ASIGNACION expr RES_HASTA expr RES_HAGA statement-list RES_FIN RES_PARA {}
      | RES_RETORNE expr {}
      | RES_LLAMAR IDENTIFICADOR OPEN_PAR factor-list CLOSE_PAR {}
      | RES_LLAMAR IDENTIFICADOR {}
      | RES_LEA factor-identifier {}
;

expr: expr OP_ADD term { $$ = new AddExpr($1, $3); }
      | expr OP_SUB term { $$ = new SubExpr($1, $3); }
      | term { $$ = $1; }
;

term: term OP_MULT factor { $$ = new MultExpr($1, $3); }
      | term POTENCIA factor { $$ = new PowExpr($1, $3); }
      | term RES_Y factor { }
      | term RES_O factor { }
      | term RES_MOD factor { }
      | term RES_DIV factor { $$ = new DivExpr($1, $3); }
      | factor { $$ = $1; }
;

factor: OPEN_PAR expr CLOSE_PAR { $$ = $2; }
      | NUMERO { $$ = $1; }
      | factor-identifier { $$ = $1; }
      | CADENA { $$ = $1; }
      | bool-constant { $$ = $1; }
      | CARACTER { $$ = $1; }
      | factor-identifier OPEN_PAR factor-list CLOSE_PAR { }
      | factor-identifier OPEN_PAR CLOSE_PAR { }
;

factor-identifier: IDENTIFICADOR { $$ = $1; }
      | IDENTIFICADOR OPEN_BRACKET expr CLOSE_BRACKET { }
;

factor-list: factor-list COMA expr { }
      | expr { }
;

bool-constant: RES_VERDADERO { $$ = $1; }
      | RES_FALSO { $$ = $1; }
;