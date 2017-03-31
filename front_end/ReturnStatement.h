#ifndef _RETURNSTATEMENT_H
#define _RETURNSTATEMENT_H

#include "SimpleStatement.h"
#include "Return.h"

class ReturnStatement : public SimpleStatement
{
public:
    ReturnStatement(Return* _ret);
    virtual ~ReturnStatement();
    virtual std::string toString() const;

private:
    Return* ret;
};

#endif