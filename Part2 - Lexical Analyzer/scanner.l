%option noyywrap

%{
#include <string>
#include <iostream>
#include <fstream>
#include <list>
#include <cstdio>
#include "SymbolTable.h"

using namespace std;


string logString;
string tokenString;
int lineCnt;
int line_count = 1;
int error_count = 0;

ofstream logout;
ofstream tokenout;

int ScopeTable::count = 0;
int ScopeTable::bucketSize = 7;

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

"+"		|

"-"		{
			tokenout << "<ADDOP>";
			logout << "Line no " << line_count << ": TOKEN <ADDOP> Lexeme " << yytext << " found\n";
			//insert in symbol table and print symbol table content(only non empty buckets)
			// There is a '|' in "+"'s rule, this means match execute the action for following rule
		}
		
{DIGIT}+ 	{
				tokenout << "<CONST_INT>";
				logout << "Line no " << line_count << ": TOKEN <CONST_INT> Lexeme " << yytext << " found\n";
				//insert in symbol table and print symbol table content(only non empty buckets)
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
