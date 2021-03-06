#ifndef _RETURN_H
#define _RETURN_H

#include "Expression.h"
#include "Printable.h"

class Return : public Printable, public IRTranslatable
{
public:
	Return(Expression* _expr);
	virtual ~Return();

    virtual std::string toString() const;
    virtual void buildIR(CFG * cfg) const;

private:
	Expression* expr;
};

#endif
