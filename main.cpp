//Author: Ethan Kamus
//Email: ethanjpkamus@csu.fullerton.edu

/*
 * The purpose of this assignment is
 */

#include <stdio.h>
#include <iostream>

extern "C" float quickmath();

int main(){
	float pass;
	std::cout << "\nThis program was made by Ethan Kamus\n
			  Here we will find the sum of n terms of the harmonic series.";

 	pass = quickmath();

	std::cout << "\nThe driver recieved " << pass << " from the assembly\n"
	          << "The Main function will now return 0 to the operating system\n"
	     	   << "Bye\n";

	return 0;
}
