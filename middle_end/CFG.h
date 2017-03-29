#ifndef _CFG_H
#define _CFG_H

#include "Symbol.h"
#include "BasicBlock.h"
#include "../front_end/genesis.h"

#include <iostream>
#include <map>
#include <string>
#include <vector>

/** The class for the control flow graph, also includes the symbol table */

/* A few important comments:
	 The entry block is the one with the same label as the AST function name.
	   (it could be the first of bbs, or it could be defined by an attribute value)
	 The exit block is the one with both exit pointers equal to nullptr.
     (again it could be identified in a more explicit way)

 */

class CFG {

 public:
	CFG(Genesis* genesis);
	virtual ~CFG();

    std::string toString() const;

    void addBasicBlock(BasicBlock* bb);
	void addSymbol(Symbol* symbol);

    // symbol table methods
    Symbol* getSymbol(std::string name);
	std::string getUsableBasicBlockName() const;
	

 protected:
    std::map <string, Symbol*> globalSymbolsTable;
	BasicBlock * currentBasicBlock;
	int nextBBnumber; /**< just for naming */
	Genesis * genesis;
	std::vector <BasicBlock*> blocks; /**< all the basic blocks of this CFG*/
};

#endif