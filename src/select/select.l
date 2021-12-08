%{
    int lineNumber = 1;
    int yylex();
    int count = 0;
    void yyerror(char *);
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
[Ss][Ee][Ll][Ee][Cc][Tt]                          printf("SELECT ");
[Dd][Ii][Ss][Tt][Ii][Nn][Cc][Tt]                  printf("DISTINCT ");
[Aa][Ll][Ll]                                      printf("ALL ");
[Ff][Rr][Oo][Mm]                                  printf("FROM ");
[Ww][Hh][Ee][Rr][Ee]                              printf("WHERE ");
[Nn][Oo][Tt]                                      printf("NOT ");    
[Nn][Uu][Ll][Ll]                                  printf("NULL ");
[Dd][Ee][Ff][Aa][Uu][Ll][Tt]                      printf("DEFAULT ");  
[Aa][Nn][Dd]                                      printf("AND ");  
[Ii][Nn]                                          printf("In "); 
[Oo][Rr]                                          printf("OR ");
[Ll][Ii][Kk][Ee]                                  printf("String Comparison ");  
{IDENTIFIER}                                      printf("IDENTIFIER ");
{POSITIVE_INTEGER}                                printf("NUMBER "); 
[,]                                               printf("Comma ");
[;]                                               printf("Semi-colon");
{Comparison}                                      printf("Comparison ");
[']({NUMBER}|{LETTER}|{PUNCTUATION})*[']          printf("Literal");  
[\t ]                                            
[\n]                                              lineNumber = lineNumber + 1;
[*]                                               printf("* ");
\(                                                printf("Left Bracket ");
\)                                                printf("Right Bracket ");
.                                                 {
                                                    yyerror(yytext);
                                                  }
%%  


int yywrap(){
    return 1;
}

int main(){  
    yylex();
    return 0;
}

void yyerror(char *s){
    printf("\nERROR: illegal symbol on line: %d.\n", lineNumber);
    exit(1);
}

