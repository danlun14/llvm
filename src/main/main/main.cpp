#include <iostream>
#include "llvm-12/llvm/IRReader/IRReader.h"
#include "llvm-12/llvm/IR/Module.h"
#include <llvm-12/llvm/IR/LLVMContext.h>
#include <llvm-12/llvm/Support/SourceMgr.h>

int main(){
    std::cout << "Test\n";
    llvm::SMDiagnostic errors;
    llvm::LLVMContext cont;
    auto parseResult = llvm::parseIRFile("test.ir", errors,cont);
    while(1){
    }
    return 0;
}