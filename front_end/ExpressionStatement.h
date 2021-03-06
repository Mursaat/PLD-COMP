#ifndef _EXPRESSIONSTATEMENT_H
#define _EXPRESSIONSTATEMENT_H

#include "SimpleStatement.h"
#include "Expression.h"

class ExpressionStatement : public SimpleStatement
{
public:
    ExpressionStatement(Expression* _expr);
    virtual ~ExpressionStatement();

    virtual std::string toString() const;
    virtual void buildIR(CFG * cfg) const;
	
private:
    Expression* expr;
};

#endif
