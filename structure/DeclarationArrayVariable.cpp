#include "DeclarationArrayVariable.h"

DeclarationArrayVariable::DeclarationArrayVariable(char* _id, int _size)

	: DeclarationVariable(_id, true),size(_size)
{

}

DeclarationArrayVariable::~DeclarationArrayVariable()
{

}

string DeclarationArrayVariable::toString() const
{
	return "DeclarationArrayVariable";
}