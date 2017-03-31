#include "Intel.h"

Intel::Intel(const std::string _filename)
    : Writer(_filename)
{
    open();

    // Begin of the assembler part
    write(".text");
    write(".global main");
    write();
}

void Intel::parse(CFG* _cfg)
{
    cfg = _cfg;

    std::string label;
    std::vector<IRInstruction*> instructions;

    BasicBlock* block = cfg->firstBB;
    while (block != nullptr)
    {
        label = block->getLabel();
        write(label + ":");

        instructions = block->getInstructions();
        for (std::vector<IRInstruction*>::iterator iri = instructions.begin() ; iri != instructions.end(); ++iri)
        {
            IRInstruction::IRInstructionType instruction = (*iri)->getOperation();

            switch (instruction)
            {
                case IRInstruction::IRInstructionType::BINARY_OP :
                    binaryOp();
                    break;
                case IRInstruction::IRInstructionType::RWMEMORY :
                    rwmemory();
                    break;
                case IRInstruction::IRInstructionType::CALL :
                    call();
                    break;
                case IRInstruction::IRInstructionType::JUMP :
                    jump();
                    break;
                case IRInstruction::IRInstructionType::SELECTION :
                    selection();
                    break;
                default:
                    break;
            }
        }

        if (block->getExitTrue() != nullptr)
        {
            block = block->getExitTrue();
        }
        else if (block->getExitFalse() != nullptr)
        {
            block = block->getExitFalse();
        }
        else
        {
            block = nullptr;
        }
    }
    write("\tretq");
}

int Intel::compile()
{
    if (!system(nullptr))
    {
        std::cout << "Erreur : impossible de lancer une commande système [back_end:Intel:compile()]." << std::endl;
        return -1;
    }
    close();

    int result = 0;
    result = system(("as -o " + filename + ".o " + filename + ".s").c_str());
    result = system(("gcc -o " + filename + ".out " + filename + ".o ").c_str());

    if (isOpen())
    {
        open(std::ios::app);
    }

    if (result != 0)
    {
        std::cout << "Erreur lors de la compilation de l'assembleur [back_end:Intel:compile()]." << std::endl;
        return -1;
    }    

    return 0;
}

void Intel::binaryOp()
{

}

void Intel::rwmemory()
{

}

void Intel::call()
{

}

void Intel::jump()
{

}

void Intel::selection()
{

}

void Intel::putchar(const char character)
{
    std::string finalCharacter;
    switch (character)
    {
        case '\n':
            finalCharacter = "\\n";
            break;
        case '\t':
            finalCharacter = "\\t";
            break;
        default:
            finalCharacter = character;
            break;
    }
    write(("\tmovl $'" + finalCharacter + "', %edi").c_str());
    write("\tcall putchar");
}

void Intel::test()
{
    putchar('I');
    putchar('N');
    putchar('T');
    putchar('E');
    putchar('L');
    putchar('\n');

    write();
    write("\tretq");
}

Intel::~Intel()
{
    close();
}