#ifndef _CREMENTIALVARIABLE_H
#define _CREMENTIALVARIABLE_H

#include "Expression.h"
#include "ExpressionVariable.h"

class CrementVariable : public Expression 
{
public:
	CrementVariable(ExpressionVariable* _exprVar, bool _increment, bool _preCrement);

private:
	ExpressionVariable* exprVar;
	// Si faux, decrement
	bool increment;
	// Si faux, post-crement
	bool preCrement;
};

#endif