#ifndef _DECLARATIONINITVARIABLE_H
#define _DECLARATIONINITVARIABLE_H

#include "Expression.h"
#include "DeclarationVariable.h"

class DeclarationInitVariable : public DeclarationVariable
{
public:
	DeclarationInitVariable(char* _id, Expression* _expr);

private:
	Expression* expr;
};


#endif