#include <iostream>
#include "llvm-12/llvm/IRReader/IRReader.h"
#include "llvm-12/llvm/IR/Module.h"
#include <llvm-12/llvm/IR/LLVMContext.h>
#include <llvm-12/llvm/IR/Function.h>
#include <llvm-12/llvm/IR/Instruction.h>
#include <llvm-12/llvm/IR/User.h>
#include <llvm-12/llvm/ADT/ilist.h>
#include <llvm-12/llvm/IR/BasicBlock.h>
#include <llvm-12/llvm/Support/SourceMgr.h>
#include <llvm-12/llvm/Support/raw_ostream.h>

bool runOnModule(llvm::Module &M)
{
    for (llvm::Module::iterator F = M.begin(), E = M.end(); F != E; ++F)
    {
        llvm::errs() << "Function:" << F->getName() << "\n";
        for (auto &BB : *F)
        {
            for (llvm::Instruction &I : BB)
            {
                llvm::errs() << I << "\n";
                llvm::errs() << I.getOpcodeName() << "\n";
                for (llvm::User::op_iterator op = I.op_begin(), e = I.op_end(); op != e; ++op)
                {
                    // llvm::errs() << "      |||" << **op << '\n';
                }
            }
        }
    }
    return true;
}

int main()
{
    std::cout << "Test\n";
    llvm::SMDiagnostic errors;
    llvm::LLVMContext cont;
    auto parseResult = llvm::parseIRFile("example.ll", errors, cont);
    runOnModule(*parseResult.get());
    return 0;
}