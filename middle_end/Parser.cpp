#include "Parser.h"

Parser::~Parser()
{
    for(auto item : functionCFG)
    {
        delete item.second;
    }

    for(auto item : globalSymbolTable)
    {
        delete item.second;
    }
}

void Parser::generateIR(Genesis *genesis)
{
    for(int declarationId = 0; declarationId < genesis->countDeclaration() ; ++declarationId)
    {
        Declaration* declaration = (*genesis)[declarationId];
        if(declaration->getType() == GLOBAL_DECLARATION_VARIABLE)
        {
            handleNewSymbolInTable((GlobalDeclarationVariable*)declaration);
        }
        else if (declaration->getType() == DECLARATION_FUNCTION)
        {
            generateCFG((DeclarationFunction*)declaration);
        }
    }
}

// crée les symboles liés aux nouvelles déclarations/définition et les ajoute à la table
void Parser::handleNewSymbolInTable(GlobalDeclarationVariable* declaration)
{
    MultipleDeclarationVariable* multipleDeclarationVariable;
    multipleDeclarationVariable = declaration->getMultipleDeclarationVariable();

    int type = multipleDeclarationVariable->getType()->getType();

    for(int declarationId = 0; declarationId < multipleDeclarationVariable->countDeclaration() ; ++declarationId)
    {
        DeclarationVariable* declarationVariable = (*multipleDeclarationVariable)[declarationId];
        Symbol *s = new Symbol(declarationVariable->getId(), type , globalSymbolTable.size());
        this->addSymbolToTable(s);
    }
}

void Parser::addNewFunctionInTable(CFG * controllFlowGraph)
{
    if(controllFlowGraph != nullptr) {
        functionCFG.insert(std::pair<std::string, CFG*>(controllFlowGraph->getName(), controllFlowGraph));
    }
}

// Génère le CFG d'une fonction et le stock dans la map des CFG
void Parser::generateCFG(DeclarationFunction * declaration)
{
    // if declaration
    //  -> on ajoute un symbole a la table;
    // if definition
    //  -> on ajoute un symbole a la table;
    //  -> code du dessous (pour build IR)

    CFG * controllFlowGraph = new CFG(this,declaration);
    addNewFunctionInTable(controllFlowGraph);
}

const std::map<std::string, const Symbol *> & Parser::getGlobalSymbolTable() const
{
    return globalSymbolTable;
}

void Parser::addSymbolToTable(Symbol * symbol)
{
    if(symbol != nullptr) {
        globalSymbolTable.insert(std::pair<std::string, Symbol*>(symbol->getName(), symbol));
    }
}
