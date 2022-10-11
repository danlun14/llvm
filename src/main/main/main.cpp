#include <iostream>
#include <fstream>
#include <string>
#include <cstdio>

#include <llvm/IR/Function.h>
#include <llvm/IR/Instructions.h>
#include <llvm-12/llvm/IR/LLVMContext.h>
#include <llvm-12/llvm/IR/Module.h>
#include <llvm-12/llvm/IRReader/IRReader.h>
#include <llvm-12/llvm/Support/SourceMgr.h>
#include <llvm-12/llvm/Support/CommandLine.h>

static llvm::cl::OptionCategory SelectionFile("File Selection Option");

static llvm::cl::opt<std::string> InputFilename("input", llvm::cl::desc("Specify input filename"), llvm::cl::value_desc("filename"), llvm::cl::cat(SelectionFile));
static llvm::cl::alias InputFilenameAlias("i", llvm::cl::desc("Alias for --input"), llvm::cl::aliasopt(InputFilename));
static llvm::cl::opt<std::string> OutputFilename("output", llvm::cl::desc("Specify output filename"), llvm::cl::value_desc("filename"), llvm::cl::cat(SelectionFile));
static llvm::cl::alias OutputFilenameAlias("o", llvm::cl::desc("Alias for --output"), llvm::cl::aliasopt(OutputFilename));

static llvm::cl::OptionCategory SelectionGraph("Graph Selection Option");

static llvm::cl::opt<bool> Callgraph("dot-callgraph", llvm::cl::desc("Output a call graph"), llvm::cl::cat(SelectionGraph));
static llvm::cl::opt<bool> Defusegraph("dot-def-use", llvm::cl::desc("Output a def-use graph"), llvm::cl::cat(SelectionGraph));

void callgraph(std::unique_ptr<llvm::Module> &module, std::ofstream &out)
{
    auto &FL = module->getFunctionList();

    out << "strict digraph G {";

    for (auto &F : FL)
    {
        llvm::StringRef parent = F.getName();
        for (auto &BB : F)
        {
            for (auto &I : BB)
            {
                if (llvm::isa<llvm::CallInst>(I))
                {
                    llvm::StringRef name = llvm::cast<llvm::CallInst>(I).getCalledFunction()->getName();
                    out << "  " << parent.data() << "->" << name.data() << '\n';
                }
            }
        }
    }

    out << "}";

    return;
}

void defusegraph(std::unique_ptr<llvm::Module> &module, const std::string &outfile)
{
    auto &FL = module->getFunctionList();

    freopen(outfile.data(), "w", stdout);
    llvm::outs() << "digraph G {";

    for (auto &F : FL)
    {
        for (auto &BB : F)
        {
            for (auto &I : BB)
            {
                auto operandList = I.operands();
                for (auto &it : operandList)
                {
                    if (!it->hasName())
                    {
                        llvm::outs() << "  \"\\";
                        llvm::outs() << I << "\""
                                     << "->";
                        llvm::outs() << "\"\\";
                        llvm::outs() << *it.get() << "\"" << '\n';
                    }
                }
            }
        }
    }

    llvm::outs() << "}";

    return;
}

int main(int argc, char *argv[])
{
    llvm::cl::ParseCommandLineOptions(argc, argv);

    llvm::SMDiagnostic errors;
    llvm::LLVMContext cont;
    auto Module = llvm::parseIRFile(InputFilename, errors, cont);

    if (!Module)
    {
        errors.print(argv[0], llvm::errs());
        return 1;
    }

    std::ofstream outfile(OutputFilename);

    if (Callgraph)
    {
        callgraph(Module, outfile);
    }

    if (Defusegraph)
    {
        defusegraph(Module, OutputFilename);
    }
    return 0;
}