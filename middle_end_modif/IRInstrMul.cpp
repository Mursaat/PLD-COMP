#include "IRInstrMul.h"

IRInstrMul::IRInstrMul(BasicBlock* _basicBlock, DataType _dataType, std::string _var1, std::string _var2, std::string _var3)
    : IRInstrThreeOp(_basicBlock, OperationType::mul, _dataType, _var1, _var2, _var3)
{

}

IRInstrMul::~IRInstrMul()
{

}

void IRInstrMul::genAsm(ostream &o)
{

}