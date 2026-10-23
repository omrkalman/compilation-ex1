/***************************/
/* FILE NAME: LEX_FILE.lex */
/***************************/

/*************/
/* USER CODE */
/*************/

import java_cup.runtime.*;

/******************************/
/* DOLLAR DOLLAR - DON'T TOUCH! */
/******************************/

%%

/************************************/
/* OPTIONS AND DECLARATIONS SECTION */
/************************************/
   
/*****************************************************/ 
/* Lexer is the name of the class JFlex will create. */
/* The code will be written to the file Lexer.java.  */
/*****************************************************/ 
%class Lexer

/********************************************************************/
/* The current line number can be accessed with the variable yyline */
/* and the current column number with the variable yycolumn.        */
/********************************************************************/
%line
%column

/*******************************************************************************/
/* Note that this has to be the EXACT same name of the class the CUP generates */
/*******************************************************************************/
%cupsym TokenNames

/******************************************************************/
/* CUP compatibility mode interfaces with a CUP generated parser. */
/******************************************************************/
%cup

/****************/
/* DECLARATIONS */
/****************/
/*****************************************************************************/   
/* Code between %{ and %}, both of which must be at the beginning of a line, */
/* will be copied verbatim (letter to letter) into the Lexer class code.     */
/* Here you declare member variables and functions that are used inside the  */
/* scanner actions.                                                          */  
/*****************************************************************************/   
%{
	/*********************************************************************************/
	/* Create a new java_cup.runtime.Symbol with information about the current token */
	/*********************************************************************************/
	private Symbol symbol(int type)               {return new Symbol(type, yyline, yycolumn);}
	private Symbol symbol(int type, Object value) {return new Symbol(type, yyline, yycolumn, value);}

	/*******************************************/
	/* Enable line number extraction from main */
	/*******************************************/
	public int getLine() { return yyline + 1; } 

	/**********************************************/
	/* Enable token position extraction from main */
	/**********************************************/
	public int getTokenStartPosition() { return yycolumn + 1; } 
%}

/***********************/
/* MACRO DECLARATIONS */
/***********************/
LineTerminator	= \r|\n|\r\n
WhiteSpace		= {LineTerminator} | [ \t]
INTEGER			= 0 | [1-9][0-9]*
ID				= [a-zA-Z][a-zA-Z0-9]*
LEADING_ZERO	= 0[0-9]+
STRING			= \"[a-zA-Z]*\"
COMMENT_CHAR    = [a-zA-Z0-9 \t\(\)\[\]\{\}\?\!\+\-\*\/\.\;]
COMMENT_TYPE_1	= "//"{COMMENT_CHAR}*{LineTerminator}
%state TYPE_2_COMMENT

/******************************/
/* DOLLAR DOLLAR - DON'T TOUCH! */
/******************************/

%%

/************************************************************/
/* LEXER matches regular expressions to actions (Java code) */
/************************************************************/

/**************************************************************/
/* YYINITIAL is the state at which the lexer begins scanning. */
/* So these regular expressions will only be matched if the   */
/* scanner is in the start state YYINITIAL.                   */
/**************************************************************/

<YYINITIAL> {

"+"					{ return symbol(TokenNames.PLUS);}
"-"					{ return symbol(TokenNames.MINUS);}
"*"					{ return symbol(TokenNames.TIMES);}
"/"					{ return symbol(TokenNames.DIVIDE);}
"="					{ return symbol(TokenNames.EQ);}
"<"					{ return symbol(TokenNames.LT);}
">"					{ return symbol(TokenNames.GT);}
"and"				{ return symbol(TokenNames.AND);}
"or"				{ return symbol(TokenNames.OR);}
"("					{ return symbol(TokenNames.LPAREN);}
")"					{ return symbol(TokenNames.RPAREN);}
"["					{ return symbol(TokenNames.LBRACK);}
"]"					{ return symbol(TokenNames.RBRACK);}
"{"					{ return symbol(TokenNames.LBRACE);}
"}"					{ return symbol(TokenNames.RBRACE);}
","					{ return symbol(TokenNames.COMMA);}
"."					{ return symbol(TokenNames.DOT);}
";"					{ return symbol(TokenNames.SEMICOLON);}
":="				{ return symbol(TokenNames.ASSIGN);}
"array"				{ return symbol(TokenNames.ARRAY);}
"class"				{ return symbol(TokenNames.CLASS);}
"extends"			{ return symbol(TokenNames.EXTENDS);}
"new"				{ return symbol(TokenNames.NEW);}
"nil"				{ return symbol(TokenNames.NIL);}
"if"				{ return symbol(TokenNames.IF);}
"else"				{ return symbol(TokenNames.ELSE);}
"while"				{ return symbol(TokenNames.WHILE);}
"return"			{ return symbol(TokenNames.RETURN);}
"int"				{ return symbol(TokenNames.TYPE_INT);}
"string"			{ return symbol(TokenNames.TYPE_STRING);}
"void"				{ return symbol(TokenNames.TYPE_VOID);}
{LEADING_ZERO}		{ return symbol(TokenNames.ERROR); }  // A leading zero is a lexical error
{INTEGER}			{
					  // We need to check overflow in L.
					  String t = yytext();
					  if (t.length() > 5 || Integer.parseInt(t) > 32767) // the length check is faster then parsing and checking
					      return symbol(TokenNames.ERROR);
					  return symbol(TokenNames.INT, Integer.valueOf(t));
					}
{ID}				{ return symbol(TokenNames.ID,     yytext());}
{WhiteSpace}		{ /* just skip what was found, do nothing */ }
{COMMENT_TYPE_1} { /* valid comment type 1: skip */ }
"//"[^\r\n]*                          { return symbol(TokenNames.ERROR); }
"/*"    { yybegin(TYPE_2_COMMENT); }
{STRING} { return symbol(TokenNames.STRING, yytext()); }
[^]     { return symbol(TokenNames.ERROR); } /* Error Sink */
<<EOF>>				{ return symbol(TokenNames.EOF);}
}


<TYPE_2_COMMENT> {
"*/"                          { yybegin(YYINITIAL); }
{COMMENT_CHAR}|{LineTerminator} { /* skip */ }
<<EOF>>                       { return symbol(TokenNames.ERROR); }   /* unclosed comment */
[^]                           { return symbol(TokenNames.ERROR); }   /* illegal char, not in the set of COMMENT_CHARs */
}