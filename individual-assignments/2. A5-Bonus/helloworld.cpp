#include <iostream>
#include "PrimeChecker.hpp"

// sudo docker build -t joelmat/example:latest -f Dockerfile .
// sudo docker run --rm joelmat/example:latest 42

// CURRENT
// sudo docker build -t my-t12:latest -f Dockerfile .
// sudo docker run --rm my-t12:latest 42


// sudo docker run --rm -ti -v $PWD:/opt/sources ubuntu:22.04 /bin/bash
// sudo docker build -t joelmat-small-manual:latest -f Dockerfile .

int main(int argc, char** argv) {
    if (argc == 2) {
        int number = std::stoi(argv[1]);
        PrimeChecker pc;
        std::cout << "Mattsson, Joel; " << number << " is a prime number? " << pc.isPrime(number) << std::endl;
    }
    return 0;
}