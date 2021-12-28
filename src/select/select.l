%{
    #include "select.tab.h"
    int lineNumber = 1;
    int yylex();
    int count = 0;
    void yyerror(char *);
    extern int yylval;
    int yyparse();
%}

NUMBER                          [0-9]
LETTER                          [a-zA-Z]
POSITIVE_INTEGER                {NUMBER}+
IDENTIFIER                      ({LETTER}|_)({LETTER}|_|{NUMBER})*
PUNCTUATION                     [.,;_!?]
gt                              >=
lt                              <=
g                                >
l                                <
e                               =
p                               +
m                               -
Comparison                     ({e}|{gt}|{lt}|{g}|{l})
%%
[Ss][Ee][Ll][Ee][Cc][Tt]                          return SELECT;
[Dd][Ii][Ss][Tt][Ii][Nn][Cc][Tt]                  return DISTINCT;
[Aa][Ll][Ll]                                      return ALL;
[Ff][Rr][Oo][Mm]                                  return FROM;
[Ww][Hh][Ee][Rr][Ee]                              return WHERE;
[Nn][Oo][Tt]                                      return NOT;    
[Nn][Uu][Ll][Ll]                                  return No_Value;
[Dd][Ee][Ff][Aa][Uu][Ll][Tt]                      return DEFAULT;  
[Aa][Nn][Dd]                                      return AND;  
[Oo][Rr]                                          return OR;
{IDENTIFIER}                                      return IDENTIFIER;
{POSITIVE_INTEGER}                                return NUMBER; 
[,]                                               return Comma;
[;]                                               return Semicolon;
{Comparison}                                      return Comparison;
[']({NUMBER}|{LETTER}|{PUNCTUATION})*[']          return Literal;  
[\t ]                                            
[\n]                                              yylval = yylval + 1;
\(                                                return Left_Bracket;
\)                                                return Right_Bracket;
.                                                 {
                                                    return (yytext[0]);
                                                  }
%%  


int yywrap(){
    return 1;
}

int main(){ 
    yylval = 1; 
    yyparse();
    return 0;
}
