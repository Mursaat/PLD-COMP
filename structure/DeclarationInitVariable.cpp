#include "DeclarationInitVariable.h"

DeclarationInitVariable::DeclarationInitVariable(char* _id, Expression* _expr)
	: DeclarationVariable(_id), expr(_expr)
{

}