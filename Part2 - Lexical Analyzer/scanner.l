%option noyywrap

%{
#include <string>
#include <iostream>
#include <fstream>
#include <list>
#include <cstdio>
#include "SymbolTable.h"

using namespace std;

///Managing line count and error count tasks
int lineCnt;
int line_count = 1;
int error_count = 0;

///File stream tasks
ofstream logout;
ofstream tokenout;
string logString;
string tokenString;
//////SymbolTable tasks
int ScopeTable::count = 0;
int ScopeTable::bucketSize = 7;
SymbolTable SymbolTable;

%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
NEWLINE \n

%%

{NEWLINE} {line_count++;}

"if"	{
			tokenout << "<IF>";
			logout << "Line no " << line_count << ": TOKEN <IF> Lexeme " << yytext << " found\n";
		}
		
"else"	{
			tokenout << "<ELSE>";
			logout << "Line no " << line_count << ": TOKEN <ELSE> Lexeme " << yytext << " found\n";
		}

"for"	{
			tokenout << "<FOR>";
			logout << "Line no " << line_count << ": TOKEN <FOR> Lexeme " << yytext << " found\n";
		}

"while"	{
			tokenout << "<WHILE>";
			logout << "Line no " << line_count << ": TOKEN <WHILE> Lexeme " << yytext << " found\n";
		}

"do"	{
			tokenout << "<DO>";
			logout << "Line no " << line_count << ": TOKEN <DO> Lexeme " << yytext << " found\n";
		}

"break"	{
			tokenout << "<BREAK>";
			logout << "Line no " << line_count << ": TOKEN <BREAK> Lexeme " << yytext << " found\n";
		}

"int"	{
			tokenout << "<INT>";
			logout << "Line no " << line_count << ": TOKEN <INT> Lexeme " << yytext << " found\n";
		}

"char"	{
			tokenout << "<CHAR>";
			logout << "Line no " << line_count << ": TOKEN <CHAR> Lexeme " << yytext << " found\n";
		}

"float"	{
			tokenout << "<FLOAT>";
			logout << "Line no " << line_count << ": TOKEN <FLOAT> Lexeme " << yytext << " found\n";
		}

"void"	{
			tokenout << "<VOID>";
			logout << "Line no " << line_count << ": TOKEN <VOID> Lexeme " << yytext << " found\n";
		}

"return"	{
			tokenout << "<RETURN>";
			logout << "Line no " << line_count << ": TOKEN <RETURN> Lexeme " << yytext << " found\n";
		}

"switch"	{
			tokenout << "<SWITCH>";
			logout << "Line no " << line_count << ": TOKEN <SWITCH> Lexeme " << yytext << " found\n";
		}

"case"	{
			tokenout << "<CASE>";
			logout << "Line no " << line_count << ": TOKEN <CASE> Lexeme " << yytext << " found\n";
		}

"default"	{
			tokenout << "<DEFAULT>";
			logout << "Line no " << line_count << ": TOKEN <DEFAULT> Lexeme " << yytext << " found\n";
		}

"continue"	{
			tokenout << "<CONTINUE>";
			logout << "Line no " << line_count << ": TOKEN <CONTINUE> Lexeme " << yytext << " found\n";
		}


([a-zA-Z]|"_")+[a-zA-Z0-9_]* {
			tokenout << "<ID," << yytext << ">";
			logout << "Line no " << line_count << ": TOKEN <ID> Lexeme " << yytext << " found\n";
		}




"+"		|

"-"		{
			tokenout << "<ADDOP>";
			logout << "Line no " << line_count << ": TOKEN <ADDOP> Lexeme " << yytext << " found\n";
			SymbolTable.insert("ADDOP", yytext);
			SymbolTable.printCurrentScopeNonEmptyBucket();
		}


"*"		|

"/"		|

"%"		{
			tokenout << "<MULOP>";
			logout << "Line no " << line_count << ": TOKEN <MULOP> Lexeme " << yytext << " found\n";
			SymbolTable.insert("MULOP", yytext);
			SymbolTable.printCurrentScopeNonEmptyBucket();
		}
		

"++"	|

"--"	{
			tokenout << "<INCOP>";
			logout << "Line no " << line_count << ": TOKEN <INCOP> Lexeme " << yytext << " found\n";
			SymbolTable.insert("INCOP", yytext);
			SymbolTable.printCurrentScopeNonEmptyBucket();
		}


"<"		|

"<="	|

">"		|

">="	|

"=="	|

"!="	{
			tokenout << "<RELOP>";
			logout << "Line no " << line_count << ": TOKEN <RELOP> Lexeme " << yytext << " found\n";
			SymbolTable.insert("RELOP", yytext);
			SymbolTable.printCurrentScopeNonEmptyBucket();
		}

"="		{
			tokenout << "<ASSIGNOP>";
			logout << "Line no " << line_count << ": TOKEN <ASSIGNOP> Lexeme " << yytext << " found\n";
			SymbolTable.insert("ASSIGNOP", yytext);
			SymbolTable.printCurrentScopeNonEmptyBucket();
		}

"&&"	|

"||"	{
			tokenout << "<LOGICOP>";
			logout << "Line no " << line_count << ": TOKEN <LOGICOP> Lexeme " << yytext << " found\n";
			SymbolTable.insert("LOGICOP", yytext);
			SymbolTable.printCurrentScopeNonEmptyBucket();
		}


"&"		|

"|"	    |

"^"	    |

">>"	|

"<<"	{
			tokenout << "<BITOP>";
			logout << "Line no " << line_count << ": TOKEN <BITOP> Lexeme " << yytext << " found\n";
			SymbolTable.insert("BITOP", yytext);
			SymbolTable.printCurrentScopeNonEmptyBucket();
		}

"!"		{
			tokenout << "<NOT>";
			logout << "Line no " << line_count << ": TOKEN <NOT> Lexeme " << yytext << " found\n";
			SymbolTable.insert("NOT", yytext);
			SymbolTable.printCurrentScopeNonEmptyBucket();
		}

"("		{
			tokenout << "<LPAREN>";
			logout << "Line no " << line_count << ": TOKEN <LPAREN> Lexeme " << yytext << " found\n";
			SymbolTable.insert("LPAREN", yytext);
			SymbolTable.printCurrentScopeNonEmptyBucket();
		}

")"		{
			tokenout << "<RPAREN>";
			logout << "Line no " << line_count << ": TOKEN <RPAREN> Lexeme " << yytext << " found\n";
			SymbolTable.insert("RPAREN", yytext);
			SymbolTable.printCurrentScopeNonEmptyBucket();
		}

"{"		{
			tokenout << "<LCURL>";
			logout << "Line no " << line_count << ": TOKEN <LCURL> Lexeme " << yytext << " found\n";
			SymbolTable.insert("LCURL", yytext);
			SymbolTable.printCurrentScopeNonEmptyBucket();
		}

"}"		{
			tokenout << "<RCURL>";
			logout << "Line no " << line_count << ": TOKEN <RCURL> Lexeme " << yytext << " found\n";
			SymbolTable.insert("RCURL", yytext);
			SymbolTable.printCurrentScopeNonEmptyBucket();
		}

"["		{
			tokenout << "<LTHIRD>";
			logout << "Line no " << line_count << ": TOKEN <LTHIRD> Lexeme " << yytext << " found\n";
			SymbolTable.insert("LTHIRD", yytext);
			SymbolTable.printCurrentScopeNonEmptyBucket();
		}

"]"		{
			tokenout << "<RTHIRD>";
			logout << "Line no " << line_count << ": TOKEN <RTHIRD> Lexeme " << yytext << " found\n";
			SymbolTable.insert("RTHIRD", yytext);
			SymbolTable.printCurrentScopeNonEmptyBucket();
		}

","		{
			tokenout << "<COMMA>";
			logout << "Line no " << line_count << ": TOKEN <COMMA> Lexeme " << yytext << " found\n";
			SymbolTable.insert("COMMA", yytext);
			SymbolTable.printCurrentScopeNonEmptyBucket();
		}

";"		{
			tokenout << "<SEMICOLON>";
			logout << "Line no " << line_count << ": TOKEN <RTHISEMICOLONRD> Lexeme " << yytext << " found\n";
			SymbolTable.insert("SEMICOLON", yytext);
			SymbolTable.printCurrentScopeNonEmptyBucket();
		}				

		
{DIGIT}+ 	{
				tokenout << "<CONST_INT>";
				logout << "Line no " << line_count << ": TOKEN <CONST_INT> Lexeme " << yytext << " found\n";
				SymbolTable.insert("CONST_INT", yytext);
				SymbolTable.printCurrentScopeNonEmptyBucket();
			}
			

%%

int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	logout.open("log.txt");
	tokenout.open("token.txt");

	yyin= fin;
	yylex();
	fclose(yyin);
	logout.close();
	tokenout.close();
	return 0;
}
