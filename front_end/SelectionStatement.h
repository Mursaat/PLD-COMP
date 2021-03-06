#ifndef _SELECTIONSTATEMENT_H
#define _SELECTIONSTATEMENT_H

#include "SimpleStatement.h"
#include "Expression.h"
#include "Statement.h"

class SelectionStatement : public SimpleStatement
{
public:
    SelectionStatement(Expression* _expr, Statement* _stat, Statement* _elseStat);
    virtual ~SelectionStatement();

    virtual std::string toString() const;
    virtual void buildIR(CFG * cfg) const;

private:
    // Expression dans le if
    Expression* expr;
    // Si la condition est realisee
    Statement* stat;
    // Sinon (peut etre = nullptr si on a pas de else)
    Statement* elseStat;
};

#endif
