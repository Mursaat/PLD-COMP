#include "ExpressionInteger.h"

#include "../middle_end/CFG.h"
#include "../middle_end/IRLoadConstant.h"
#include "../middle_end/Symbol.h"

ExpressionInteger::ExpressionInteger(int _value, int _type)
    : Expression(), value(_value)
{
    setType(_type);
    setExpressionType(EXPRESSION_INTEGER);
}

ExpressionInteger::~ExpressionInteger()
{
}

std::string ExpressionInteger::toString() const
{
    return std::to_string(value);
}

void ExpressionInteger::buildIR(CFG *cfg) const
{
    std::string tmpName = cfg->getTempVariableName();
    Symbol * destination = new Symbol(tmpName,getType(),cfg->getOffsetFromCurrentBasicBlock());
    IRLoadConstant * instruction = new IRLoadConstant(destination, value);

    cfg->addInstructionInCurrentBasicBlock(instruction);
}

int ExpressionInteger::getValue()
{
    return value;
}
