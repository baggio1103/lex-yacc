%token SELECT
%token DISTINCT
%token ALL
%token FROM
%token WHERE
%token NOT
%token No_Value
%token DEFAULT
%token AND
%token OR
%token IDENTIFIER
%token Literal
%token NUMBER
%token Comma
%token Semicolon
%token Comparison
%token Left_Bracket
%token Right_Bracket

%{
#include <stdio.h>
#include <stdlib.h>

int yywrap();
int yylex();
int has_error = 0;

void yyerror(const char *str);

int yylval;

int error_count = 0;

void yyerror(const char *str) {
	fprintf(stderr, "error: %s in line %d\n", str, yylval);
	if (error_count >= 3) {
		exit(-1);
	}
}

void line_error(char const *s, int first_line) {
	printf("Error line: %d - %s\n", first_line, s);
	has_error = 1;
	error_count++;
	
	if (error_count >= 3) {
		exit(-1);
	}
}

void printCorrect(int first_line) {
	if (has_error == 0) {
		printf("Line %d - correct SQL SELECT expression\n", first_line);
	}
	has_error = 0;
	error_count = 0;
}
%}


%%
select_list:
	select | 
	select_list select
select:
	select_part from_part Semicolon {printCorrect($1);} |
	select_part from_part where_part Semicolon {printCorrect($1);}
select_part:
	SELECT field_list {printf("shit")}  |
	SELECT select_opt field_list |
	error {yyerrok;} field_list |
	error {yyerrok;} select_opt field_list
field_list:
	'*' |
	field_names
field_names:
	field_name |
	field_names Comma field_name |
	field_names error {yyerrok; yyclearin;} field_name
field_name:
	IDENTIFIER |
	error {yyerrok; yyclearin;}
from_part:
	FROM table_list
table_list:
	table_name |
	table_list Comma table_name |
	table_list error {yyerrok; yyclearin;} table_name
table_name:
	IDENTIFIER |
	error {yyerrok; yyclearin;}
where_part:
	WHERE condition
select_opt:
	DISTINCT | 
	ALL
condition: 
	predicate |
	Left_Bracket condition Right_Bracket |
	condition condition_operator condition
predicate:
	NOT predicate |
	field_value Comparison field_value |
	field_value error {yyerrok;} field_value
field_value:
	value
condition_operator:
	AND |
	OR
value:
	Literal |
	number_expression |
	No_Value |
	DEFAULT |
	error {yyerrok;}
number_expression:
	computable_expression |
	Left_Bracket number_expression Right_Bracket |
	number_expression number_operator number_expression
computable_expression:
	number |
	IDENTIFIER
number_operator:
	'+' |
	'-' |
	'*' |
	'/'
number:
	negative_number | NUMBER
negative_number:
	'-' NUMBER
%%