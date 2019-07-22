. ./support/do.inc

redo-ifchange ./sources/sources.done
redo-ifchange ./toolchain/toolchain.done

touch "$out"