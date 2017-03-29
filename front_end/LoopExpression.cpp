#include "LoopExpression.h"

LoopExpression::LoopExpression(Expression* _expr)
    : Printable(), expr(_expr)
{

}

LoopExpression::~LoopExpression()
{
    delete expr;
}

string LoopExpression::toString() const
{
	string txt = "";
	if(expr != nullptr) 
	{
		txt = expr->toString();
	}
	return txt;
}