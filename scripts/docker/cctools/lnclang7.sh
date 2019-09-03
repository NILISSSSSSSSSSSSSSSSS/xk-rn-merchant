for proc in clang clang++ llvm-config
do
  ln -sf /usr/bin/$proc-7 /usr/bin/$proc
done