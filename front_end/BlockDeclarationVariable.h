#ifndef _BLOCKDECLARATIONVARIABLE_H
#define _BLOCKDECLARATIONVARIABLE_H

#include "SimpleStatement.h"
#include "MultipleDeclarationVariable.h"

// Declaration de variable dans un block
class BlockDeclarationVariable : public SimpleStatement
{
public:
    BlockDeclarationVariable(MultipleDeclarationVariable* _multipleDeclarationVariable);
    virtual ~BlockDeclarationVariable();

    virtual std::string toString() const;
    virtual void buildIR(CFG * cfg) const;

    MultipleDeclarationVariable* getMultipleDeclarationVariable();

private:
    MultipleDeclarationVariable* multipleDeclarationVariable;
};

#endif
