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
int string_line_count = 0;
int comment_line_count = 0;
int line_count = 1;
int error_count = 0;

///File stream tasks
ofstream logout;
ofstream tokenout;
string logString;
string tokenString;
string stringLexeme;
string commentLexeme;
//////SymbolTable tasks
int ScopeTable::count = 0;
int ScopeTable::bucketSize = 7;
SymbolTable symbolTable;

%}

%x singleLineComment
%x multiLineComment
%x string 

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
NEWLINE \n
IDENTIFIER ({LETTER}|_)+({LETTER}|{DIGIT}|_)*
CONST_INTEGER [-+]?{DIGIT}+
FLOAT_WITHOUT_EXP [-+]?({DIGIT}*\.?{DIGIT}+|{DIGIT}+\.{DIGIT}*)
CONST_FLOAT {FLOAT_WITHOUT_EXP}((E|e)[-+]?{DIGIT}+)?
CONST_CHAR1 [^\n\t\'\"\\]
CONST_CHAR2 (\\)[^\n\t]

%%

{NEWLINE} {line_count++;}

"if"	{
			tokenout << "<IF>";
			logout << "Line no " << line_count << ": TOKEN <IF> Lexeme <" << yytext << "> found\n";
		}
		
"else"	{
			tokenout << "<ELSE>";
			logout << "Line no " << line_count << ": TOKEN <ELSE> Lexeme <" << yytext << "> found\n";
		}

"for"	{
			tokenout << "<FOR>";
			logout << "Line no " << line_count << ": TOKEN <FOR> Lexeme <" << yytext << "> found\n";
		}

"while"	{
			tokenout << "<WHILE>";
			logout << "Line no " << line_count << ": TOKEN <WHILE> Lexeme <" << yytext << "> found\n";
		}

"do"	{
			tokenout << "<DO>";
			logout << "Line no " << line_count << ": TOKEN <DO> Lexeme <" << yytext << "> found\n";
		}

"break"	{
			tokenout << "<BREAK>";
			logout << "Line no " << line_count << ": TOKEN <BREAK> Lexeme <" << yytext << "> found\n";
		}

"int"	{
			tokenout << "<INT>";
			logout << "Line no " << line_count << ": TOKEN <INT> Lexeme <" << yytext << "> found\n";
		}

"char"	{
			tokenout << "<CHAR>";
			logout << "Line no " << line_count << ": TOKEN <CHAR> Lexeme <" << yytext << "> found\n";
		}

"float"	{
			tokenout << "<FLOAT>";
			logout << "Line no " << line_count << ": TOKEN <FLOAT> Lexeme <" << yytext << "> found\n";
		}

"void"	{
			tokenout << "<VOID>";
			logout << "Line no " << line_count << ": TOKEN <VOID> Lexeme <" << yytext << "> found\n";
		}

"return"	{
			tokenout << "<RETURN>";
			logout << "Line no " << line_count << ": TOKEN <RETURN> Lexeme <" << yytext << "> found\n";
		}

"switch"	{
			tokenout << "<SWITCH>";
			logout << "Line no " << line_count << ": TOKEN <SWITCH> Lexeme <" << yytext << "> found\n";
		}

"case"	{
			tokenout << "<CASE>";
			logout << "Line no " << line_count << ": TOKEN <CASE> Lexeme <" << yytext << "> found\n";
		}

"default"	{
			tokenout << "<DEFAULT>";
			logout << "Line no " << line_count << ": TOKEN <DEFAULT> Lexeme <" << yytext << "> found\n";
		}

"continue"	{
			tokenout << "<CONTINUE>";
			logout << "Line no " << line_count << ": TOKEN <CONTINUE> Lexeme <" << yytext << "> found\n";
		}


{IDENTIFIER} {
			tokenout << "<ID,<" << yytext << ">>";
			logout << "Line no " << line_count << ": TOKEN <ID> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "ID");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}

[0-9]+{IDENTIFIER} {
			error_count++;
			logout << "Error at Line no " << line_count << ": Invalid prefix on ID or invalid suffix on Number <"<< yytext <<"> found\n"; 
		}

{FLOAT_WITHOUT_EXP}((E|e)[-+]?{FLOAT_WITHOUT_EXP}+) {
			logout << "Error at Line no " << line_count << ": Ill formed number <"<< yytext <<"> found\n";
		}



"+"		|

"-" 	{
			tokenout << "<ADDOP>";
			logout << "Line no " << line_count << ": TOKEN <ADDOP> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "ADDOP");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}


"*"		|

"/"		|

"%"		{
			tokenout << "<MULOP>";
			logout << "Line no " << line_count << ": TOKEN <MULOP> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "MULOP");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}
		

"++"	|

"--"	{
			tokenout << "<INCOP>";
			logout << "Line no " << line_count << ": TOKEN <INCOP> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "INCOP");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}


"<"		|

"<="	|

">"		|

">="	|

"=="	|

"!="	{
			tokenout << "<RELOP>";
			logout << "Line no " << line_count << ": TOKEN <RELOP> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "RELOP");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}

"="		{
			tokenout << "<ASSIGNOP>";
			logout << "Line no " << line_count << ": TOKEN <ASSIGNOP> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "ASSIGNOP");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}

"&&"	|

"||"	{
			tokenout << "<LOGICOP>";
			logout << "Line no " << line_count << ": TOKEN <LOGICOP> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "LOGICOP");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}


"&"		|

"|"	    |

"^"	    |

">>"	|

"<<"	{
			tokenout << "<BITOP>";
			logout << "Line no " << line_count << ": TOKEN <BITOP> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "BITOP");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}

"!"		{
			tokenout << "<NOT>";
			logout << "Line no " << line_count << ": TOKEN <NOT> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "NOT");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}

"("		{
			tokenout << "<LPAREN>";
			logout << "Line no " << line_count << ": TOKEN <LPAREN> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "LPAREN");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}

")"		{
			tokenout << "<RPAREN>";
			logout << "Line no " << line_count << ": TOKEN <RPAREN> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "RPAREN");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}

"{"		{
			tokenout << "<LCURL>";
			logout << "Line no " << line_count << ": TOKEN <LCURL> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "LCURL");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}

"}"		{
			tokenout << "<RCURL>";
			logout << "Line no " << line_count << ": TOKEN <RCURL> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "RCURL");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}

"["		{
			tokenout << "<LTHIRD>";
			logout << "Line no " << line_count << ": TOKEN <LTHIRD> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "LTHIRD");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}

"]"		{
			tokenout << "<RTHIRD>";
			logout << "Line no " << line_count << ": TOKEN <RTHIRD> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "RTHIRD");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}

","		{
			tokenout << "<COMMA>";
			logout << "Line no " << line_count << ": TOKEN <COMMA> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "COMMA");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}

";"		{
			tokenout << "<SEMICOLON>";
			logout << "Line no " << line_count << ": TOKEN <SEMICOLON> Lexeme <" << yytext << "> found\n";
			symbolTable.insert(yytext, "SEMICOLON");
			symbolTable.printCurrentScopeNonEmptyBucket();
		}				

		
{CONST_INTEGER}	{
				tokenout << "<CONST_INT>";
				logout << "Line no " << line_count << ": TOKEN <CONST_INT> Lexeme <" << yytext << "> found\n";
				symbolTable.insert(yytext, "CONST_INT");
				symbolTable.printCurrentScopeNonEmptyBucket();
			}

{CONST_FLOAT}	{
				tokenout << "<CONST_FLOAT>";
				logout << "Line no " << line_count << ": TOKEN <CONST_FLOAT> Lexeme <" << yytext << "> found\n";
				symbolTable.insert(yytext, "CONST_FLOAT");
				symbolTable.printCurrentScopeNonEmptyBucket();
			}

\'{CONST_CHAR1}\' 	{
				tokenout << "<CONST_CHAR>";
				logout << "Line no " << line_count << ": TOKEN <CONST_CHAR> Lexeme <" << yytext << "> found\n";
				symbolTable.insert(yytext, "CONST_CHAR");
				symbolTable.printCurrentScopeNonEmptyBucket();
			}


\'{CONST_CHAR2}\' 	{ 
				char c = yytext[2];
				switch(c) 
				{
					case 'n': c = '\n'; break;
					case 't': c = '\t'; break;
					case 'a': c = '\a'; break;
					case 'v': c = '\v'; break;
					case 'f': c = '\f'; break;
					case 'r': c = '\r'; break;
					case 'b': c = '\b'; break;
					case '0': c = '\0'; break;
					default: break;	
				}
				tokenout << "<CONST_CHAR>";
				logout << "Line no " << line_count << ": TOKEN <CONST_CHAR> Lexeme " << c << " found\n";
				symbolTable.insert(yytext, "CONST_CHAR");
				symbolTable.printCurrentScopeNonEmptyBucket();
			}

\'({CONST_CHAR1}|{CONST_CHAR2})+({CONST_CHAR1}|{CONST_CHAR2})+\' {
				error_count++;
				logout << "Error at Line no " << line_count << ": Multi character constant error <"<< yytext <<"> found\n";
			}


\'\' 		{
				error_count++;
				logout << "Error at Line no " << line_count << ": Empty character constant <"<< yytext <<"> found\n";
			}

\'\\\' 		{
				error_count++;
				logout << "Error at Line no " << line_count << ": Unterminated character <"<< yytext <<"> found\n";
			}

\'({CONST_CHAR1}|{CONST_CHAR2})[^\'] {
				error_count++;
				logout << "Error at Line no " << line_count << ": Unfinished character <"<< yytext <<"> found\n";
			}

\"			{
				stringLexeme = "\"";
				string_line_count = 0;
				BEGIN(string);
			}

<string>[^\"\\\n]+ {
				stringLexeme+=yytext;
			}

<string>\\\n {
				string_line_count++;
				stringLexeme+=yytext;
			}

<string>\\. {
		switch(yytext[1]) 
		{
			case 'n' : stringLexeme += '\n'; break;
			case 'a' : stringLexeme += '\a'; break;		
			case 'f' : stringLexeme += '\f'; break;
			case 'r' : stringLexeme += '\r'; break;
			case 't' : stringLexeme += '\t'; break;
			case 'b' : stringLexeme += '\b'; break;
			case 'v' : stringLexeme += '\v'; break;
			case '0' : stringLexeme += '\0'; break;
			default: stringLexeme += yytext[1]; break;
		}
	}

<string>\n {
			string_line_count++;
			error_count++;
			stringLexeme+=yytext;
			logout << "Error at Line no " << line_count << ": Unterminated String <"<< stringLexeme <<"> found\n";
			line_count += string_line_count;
			string_line_count = 0;
			stringLexeme = "";
			BEGIN(INITIAL);
		}

<string><<EOF>> {
			string_line_count++;
			error_count++;
			logout << "Error at Line no " << line_count << ": Unterminated String <"<< stringLexeme <<"> found\n";
			line_count += string_line_count;
			string_line_count = 0;
			stringLexeme = "";
			BEGIN(INITIAL);
		}

<string>\"  {
				stringLexeme+="\"";
				tokenout << "<STRING>";
				logout << "Line no " << line_count << ": TOKEN <STRING> Lexeme <" << stringLexeme << "> found\n";
				line_count+=string_line_count;
				stringLexeme = "";
				string_line_count = 0;
				BEGIN(INITIAL);
			}

"//" 		{
				commentLexeme = "//";
				comment_line_count = 0;
				BEGIN(singleLineComment);
			}

<singleLineComment>[^\n\\]* {
				commentLexeme += yytext;
			}

<singleLineComment>(\\)+(\n) {
				commentLexeme +=yytext;
				comment_line_count++;
			}

<singleLineComment>\n {
				comment_line_count++;
				logout << "Line no " << line_count << ": TOKEN <SINGLELINECOMMENT> Lexeme <" << commentLexeme << "> found\n";
				line_count+=comment_line_count;
				comment_line_count = 0;
				BEGIN(INITIAL);
			}

<singleLineComment><<EOF>> { 
			error_count++;
			logout << "Error at Line no " << line_count << ": Unterminated Comment <"<< commentLexeme <<"> found\n";
			line_count += comment_line_count;
			comment_line_count = 0;
			commentLexeme = "";
			BEGIN(INITIAL);
		}

"/*" 		{
				commentLexeme = "/*";
				BEGIN(multiLineComment);
			}

<multiLineComment>\n {
				comment_line_count++;
				commentLexeme += yytext;
			}

<multiLineComment>[^*\n]+ {
				commentLexeme += yytext;
			}

<multiLineComment>"*"[^*/\n] {
				commentLexeme += yytext;
			}

<multiLineComment>"*/" {
				commentLexeme += yytext;
				logout << "Line no " << line_count << ": TOKEN <MULTILINECOMMENT> Lexeme <" << commentLexeme << "> found\n";
				line_count += comment_line_count;
				commentLexeme = "";
				BEGIN(INITIAL);
			}

<multiLineComment><<EOF>> { 
			error_count++;
			logout << "Error at Line no " << line_count << ": Unterminated Comment <"<< commentLexeme <<"> found\n";
			line_count += comment_line_count;
			comment_line_count = 0;
			commentLexeme = "";
			BEGIN(INITIAL);
		}


{WHITESPACE} {
				///do nothing
				//just eat up
			}

. 			{
				//error generation
				logout << "Error at Line no " << line_count << ": Unrecognized character <"<< yytext <<"> found\n";
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
	logout << "Total lines: " << line_count << "\n";
	logout << "Total errors: " << error_count << "\n";
	logout.close();
	tokenout.close();
	return 0;
}
