. ./support/do.inc

redo-ifchange ./sources/sources.done
redo-ifchange ./toolchain/toolchain.done
redo-ifchange ./packages/packages.done

touch "$out"