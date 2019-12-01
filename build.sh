#Name: Ethan Kamus
#email: ethanjpkamus@csu.fullerton.edu

# The purpose of this assignment is to practice the use of floating point numbers
# in intel x86_64 assemnly language

rm *.o
rm *.out
rm *.lis

echo "Assemble quickmath.asm"
nasm -f elf64 -l quickmath.lis -o quickmath.o quickmath.asm

echo "Compile main.cpp"
g++ -c -Wall -m64 -std=c++14 -o main.o -fno-pie -no-pie main.cpp

echo "Link all object files"
g++ -m64 -std=c++14 -fno-pie -no-pie main.o quickmath.o -o myprog.out

echo "Now the program will run"
./myprog.out
