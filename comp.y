/**********/
/* HEADER */
/**********/
%{
    #include <cstdio>
    #include <iostream>
    #include <libgen.h>

    #include "declaration.h"
	#include "expression.h"
	#include "genesis.h"
	#include "declarationvariable.h" 
	#include "declarationfunction.h"
	#include "multipledeclarationvariableglobal.h"
	#include "multipleargument.h" 
	#include "argument.h" 
	#include "statement.h" 
	#include "multiplestatement.h" 
	#include "multipledeclarationvariablelocal.h" 
	#include "declarationinitvariable.h" 
	#include "declarationarrayvariable.h" 
	#include "binaryoperatorexpression.h"
	#include "return.h" 
	#include "iterationstatement.h"
	#include "whileloop.h"
	#include "forloop.h"
	#include "selectionstatement.h" 
	#include "ifelsestatement.h" 
	#include "unaryoperatorexpression.h" 
	#include "expressioninteger.h" 
	#include "expressionvariable.h" 
	#include "expressionarrayvariable.h"
	#include "assignmentexpression.h"
	#include "type.h"
	#include "globaldeclarationvariable.h"
	#include "assignmentvariable.h"
	#include "assignmentoperationvariable.h"

    char* filename;

    using namespace std;

    extern int yylex(void);
    void yyerror(Genesis** g, const char* msg);

    extern FILE* yyin;
    extern int yylineno;
    extern int column;
    extern bool hasSyntaxError;
    extern std::string syntaxError;
%}

/**************/
/* STRUCTURES */
/**************/
%union {
    int i;
	char* s;

    Genesis* g;
	Declaration* d;
	//MultipleDeclarationVariable* mdv; // Erreur ici : MultipleDeclarationVariableGlobal ou MultipleDeclarationVariableLocal ?
	MultipleDeclarationVariableLocal* mdv; // Global ou Local ?
	
	DeclarationFunction* df;
	DeclarationVariable* dv;
	TYPE type;
	Expression* expr;
	ExpressionVariable* exprVar;
	AssignmentExpression* assignExpr;
	MultipleStatement* dfs;
	MultipleArgument* al;
	MultipleStatement* ms;
	Argument* arg;
	Statement* ss;
	IterationStatement* iss;
	SelectionStatement* sss;
	Return* ret;
	Statement* stat;
	Expression* loopexpr;
	AssignmentVariable* assignVar;
}

/**********/
/* TOKENS */
/**********/
// Liste des tokens issus de Flex (comp.l)
%token ELLIPSE VOID
%token LEFT_DEC_ASSIGN RIGHT_DEC_ASSIGN
%token PLUS_ASSIGN MINUS_ASSIGN DIV_ASSIGN MUL_ASSIGN
%token MOD_ASSIGN AND_ASSIGN OR_ASSIGN OR_EXCL_ASSIGN
%token RIGHT_DEC LEFT_DEC
%token MORE_THAN LESS_THAN DIFF EQUAL
%token AND OR INCREMENT DECREMENT
%token CHAR INT32 INT64
%token BREAK RETURN CONTINUE WHILE FOR IF ELSE
%token <s> ID
%token <i> INT

// Type permettant la creation de la structure de donnees
%type <g> genesis
%type <d> declaration
%type <mdv> multiple_declaration_variable
%type <df> declaration_function
%type <dv> declaration_variable
%type <type> type
%type <expr> expression
%type <exprVar> expr_var
%type <assignVar> assignment_variable
%type <dfs> declaration_function_statement
%type <al> arguments_list
%type <ms> multiple_statement
%type <arg> argument
%type <ss> simple_statement
%type <iss> iteration_statement
%type <sss> selection_statement
%type <ret> return
%type <stat> statement
%type <loopexpr> loop_expression

/*********/
/* TYPES */
/*********/


/************/
/* PRIORITY */
/************/
// Pour la priorité des opérateurs qui a été définie
// Voir https://c.developpez.com/cours/bernard-cassagne/node101.php#footmp10620

%left ','
%right RIGHT_DEC_ASSIGN LEFT_DEC_ASSIGN AND_ASSIGN OR_EXCL_ASSIGN OR_ASSIGN
%right '=' PLUS_ASSIGN MINUS_ASSIGN MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN
%right '?' ':'
%left OR
%left AND
%left '|'
%left '^'
%left EQUAL DIFF
%left '<' LESS_THAN '>' MORE_THAN
%left RIGHT_DEC LEFT_DEC
%left '+' '-'
%nonassoc NEG
%right '*' '/' '%'
%right '!' '~' '&'
%left INCREMENT DECREMENT

/**************/
/* PARAMETERS */
/**************/

%parse-param { Genesis** g }

/***********/
/* GRAMMAR */
/***********/
%%

program
    : genesis {*g = $1;}
    ;

genesis
    : genesis declaration {$$ = $1; $$->addDeclaration($2);}
    | declaration {$$ = new Genesis(); $$->addDeclaration($1);}
    ;

declaration
    : type multiple_declaration_variable ';' {$$ = new GlobalDeclarationVariable($2); $2->setType($1);}
    | declaration_function {$$ = $1;}
    ;

type
    : VOID {$$ = TYPE::VOID_T;}
    | CHAR {$$ = TYPE::CHAR_T;}
    | INT32 {$$ = TYPE::INT32_T;}
    | INT64 {$$ = TYPE::INT64_T;}
    ;

multiple_declaration_variable
    : declaration_variable //{$$ = new MultipleDeclarationVariable(); $$->addDeclarationVariable($1);} // Erreur ici : global ou local ?
                             {$$ = new MultipleDeclarationVariableLocal(); $$->addDeclarationVariable($1);}
    | multiple_declaration_variable ',' declaration_variable {$$ = $1; $1->addDeclarationVariable($3);}
    ;

declaration_variable
    : ID {$$ = new DeclarationVariable($1);}
    | ID '[' INT ']' {$$ = new DeclarationArrayVariable($1, $3);}
    | ID '=' expression {$$ = new DeclarationInitVariable($1, $3);}
    ;

assignment_variable // utilisé pour affecter une valeur à une variable en dehors de son initialisation (int a; a = 3;)
    : expr_var '=' expression {$$ = new AssignmentVariable($1,$3);}
    | expr_var MUL_ASSIGN expression {$$ = new AssignmentOperationVariable($1,$3,MUL_ASSIGN);}
    | expr_var DIV_ASSIGN expression {$$ = new AssignmentOperationVariable($1,$3,DIV_ASSIGN);}
    | expr_var MOD_ASSIGN expression {$$ = new AssignmentOperationVariable($1,$3,MOD_ASSIGN);}
    | expr_var PLUS_ASSIGN expression {$$ = new AssignmentOperationVariable($1,$3,PLUS_ASSIGN);}
    | expr_var MINUS_ASSIGN expression {$$ = new AssignmentOperationVariable($1,$3,MINUS_ASSIGN);}
    | expr_var LEFT_DEC_ASSIGN expression {$$ = new AssignmentOperationVariable($1,$3,LEFT_DEC_ASSIGN);}
    | expr_var RIGHT_DEC_ASSIGN expression {$$ = new AssignmentOperationVariable($1,$3,RIGHT_DEC_ASSIGN);}
    | expr_var AND_ASSIGN expression {$$ = new AssignmentOperationVariable($1,$3,AND_ASSIGN);}
    | expr_var OR_ASSIGN expression {$$ = new AssignmentOperationVariable($1,$3,OR_ASSIGN);}
    | expr_var OR_EXCL_ASSIGN expression {$$ = new AssignmentOperationVariable($1,$3,OR_EXCL_ASSIGN);}
    ;

declaration_function
    : type ID '(' ')' declaration_function_statement {$$ = new DeclarationFonction($1, $2, new ArgumentList(), $5);}
    | type ID '(' arguments_list ')' declaration_function_statement {$$ = new DeclarationFonction($1, $2, $4, $6);}
    ;

declaration_function_statement
    : ';' {$$=new PureDeclarationFonctionStatement();}
    | '{' multiple_statement '}' {$$=new InitFonctionStatement($2);}
    | '{' '}' {$$=new InitFonctionStatement(new MultipleStatement());}
    ;

argument
    : type {$$=new Argument($1);}
    | type ID {$$=new Argument($1,$2);}
    | type ID '[' ']' {$$=new Argument($1,$2,true);}
    ;

arguments_list
    : argument {$$ = new ArgumentList(); $$->addArgument($1);}
    | arguments_list ',' argument {$$ = $1; $1->addArgument($3);}
    ;

simple_statement
    : iteration_statement {$$ = $1;}
    | selection_statement {$$ = $1;}
    | type multiple_declaration_variable ';' {$$ = new BlockDeclarationVariable($2); $2->setType($1);}
    | expression ';' {$$ = new ExpressionStatement($1);}
    | return ';' {$$ = new ReturnStatement($1);}
    | ';'  {$$ = new UselessStatement();}
    ;

multiple_statement
    : multiple_statement simple_statement { $$ = $1; $1->addStatement($2);}
    | simple_statement { $$ = new MultipleStatement(); $$->addStatement($1);}
    ;

return
    : RETURN {$$ = new Return(nullptr);}
    | RETURN expression  {$$ = new Return($2);}
    ;

iteration_statement
    : WHILE '(' expression ')' statement {$$ = new WhileLoop($3,$5);}
    | FOR '(' loop_expression ';' loop_expression ';' loop_expression ')' statement {$$ = new ForLoop($3,$5,$7,$9);}
    ;

statement
    : '{' multiple_statement '}' {$$ = new Statement($2);}
    | simple_statement {MultipleStatement* mult = new MultipleStatement(); mult->addStatement($1); $$ = new Statement(mult);}
    ;

loop_expression
    : expression {$$ = new LoopExpression($1);}
    | {$$ = new LoopExpression(nullptr);}
    ;

expression
    : '(' expression ')' {$$ = $2;}
    | expression ',' expression  {$$ = new BinaryOperatorExpression($1,$3,',');}
    | expression EQUAL expression {$$ = new BinaryOperatorExpression($1,$3,EQUAL);}
    | expression DIFF expression {$$ = new BinaryOperatorExpression($1,$3,DIFF);}
    | expression '<' expression {$$ = new BinaryOperatorExpression($1,$3,'<');}
    | expression LESS_THAN expression {$$ = new BinaryOperatorExpression($1,$3,LESS_THAN);}
    | expression '>' expression {$$ = new BinaryOperatorExpression($1,$3,'>');}
    | expression MORE_THAN expression {$$ = new BinaryOperatorExpression($1,$3,MORE_THAN);}
    | expression AND expression {$$ = new BinaryOperatorExpression($1,$3,AND);}
    | expression OR expression {$$ = new BinaryOperatorExpression($1,$3,OR);}
    | assignment_variable {$$ = $1;}
    | '+' expression {$$ = new UnaryOperatorExpression($2,'+');}
    | '-' expression %prec NEG {$$ = new UnaryOperatorExpression($2,'-');}
    | '~' expression {$$ = new UnaryOperatorExpression($2,'~');}
    | '!' expression {$$ = new UnaryOperatorExpression($2,'!');}
    | INT {$$ = new ExpressionInteger($1);}
    | INCREMENT expr_var {$$ = new CrementVariable($2, true, true);}
    | DECREMENT expr_var {$$ = new CrementVariable($2, false, true);}
    | expr_var INCREMENT {$$ = new CrementVariable($1, true, false);}
    | expr_var DECREMENT {$$ = new CrementVariable($1, false, false);}
    | expr_var {$$ = $1;}
    | ID '(' expression ')' {$$ = new FunctionCallExpression($1, $3);}
    | ID '(' ')' {$$ = new FunctionCallExpression($1, nullptr);}
    | expression '+' expression {$$ = new BinaryOperatorExpression($1,$3,'+');}
    | expression '-' expression {$$ = new BinaryOperatorExpression($1,$3,'-');}
    | expression '*' expression {$$ = new BinaryOperatorExpression($1,$3,'*');}
    | expression '/' expression {$$ = new BinaryOperatorExpression($1,$3,'/');}
    | expression '%' expression {$$ = new BinaryOperatorExpression($1,$3,'%');}
    | expression '&' expression {$$ = new BinaryOperatorExpression($1,$3,'&');}
    | expression '|' expression {$$ = new BinaryOperatorExpression($1,$3,'|');}
    | expression '^' expression {$$ = new BinaryOperatorExpression($1,$3,'^');}
    | expression LEFT_DEC expression {$$ = new BinaryOperatorExpression($1,$3,LEFT_DEC);}
    | expression RIGHT_DEC expression {$$ = new BinaryOperatorExpression($1,$3,RIGHT_DEC);}
    ;

expr_var
    : ID '[' expression ']' {$$ = new ExpressionArrayVariable($1, $3);}
    | ID {$$ = new ExpressionSimpleVariable($1);}
    ;

selection_statement
    : IF '(' expression ')' statement ELSE statement {$$ = new SelectionStatement($3,$5,$7);}
    | IF '(' expression ')' statement {$$ = new SelectionStatement($3,$5,nullptr);}
    ;

%%

/***********************/
/* PROGRAMME PRINCIPAL */
/***********************/
void yyerror(Genesis** g, const char* msg)
{
    if(hasSyntaxError){
        cout << filename << ":" << yylineno << "." << column <<": syntax error : " << syntaxError << endl;
        hasSyntaxError = false;
    } else {
        cout << filename << ":" << yylineno << "." << column <<": error : " << msg << endl;
    }
}

int main(int argc, char* argv[])
{
    // Test parameters
    if (argc <= 1)
    {
        cout << "Error: no input filename given." << endl;
        cout << "Example of use: ~$ ./comp codeFile" << endl;
        return 1;
    }

    // Compilation
    cout << "Compilation of file '" << argv[1] << "'..." << endl;

    //yydebug = 1;

    yyin = fopen(argv[1], "r");
    if (!yyin)
    {
        printf("Error: unable to open file '%s'.\n", argv[1]);
        return 1;
    }

    filename = basename(argv[1]);
    yylineno = 1;

    Genesis* g = 0;
    yyparse(&g);

    cout << "Compilation finished." << endl;
    return 0;
}
