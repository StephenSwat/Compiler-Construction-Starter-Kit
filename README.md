# Compiler Construction starter kit

A set of tests and miscellanious useful files for the Compiler Construction
course at the University of Amsterdam.

## Test suite

We provide a test suite consisting of dozens of edge cases that you might not
be aware of.

### Installation

The easiest way to install the test suite, would be to add it as a subdirectory
to your own respository. To do this, use the following code from the root of
your own project repository:

    git submodule add git@github.com:StephenSwat/Compiler-Construction-Starter-Kit.git test
    git commit -m 'Add the compiler construction starter kit'

#### Integrating with `make`

You can add a rule to your Makefile to easily run the test files for you. The
rule should look something like the following:

    test: civicc
	    @(cd test; ./test.sh)

Then, run `make test` to execute the full suite of tests.

#### Adding the compiler et al. to your path

To make developing your compiler easier, you might want to be able to just call
the name of your compiler in stead of having to give its path. One way of doing
this is as follows:

    mkdir ~/.bin
    echo 'PATH=$PATH:~/bin' >> ~/.bashrc
    ln -s [path to your compiler executabe] ~/.bin/my_compiler

You should then extract the compiler toolchain (`civcc`, `civas`, `civrun` and
`civvm`) to the `~/.bin` directory, which should allow you to simply run the
commands `civcc`, `my_compiler` (giving your compiler a creative name is
encouraged), etc.

### Configuration

After installing, fill in the file `test/test.sh` with the details of your
compiler. Enter the name of your compiler and any flags you want to give it.
Then enter the reference compiler, any flags for that, the assembler and the
virtual machine.

If you enable the `CHECK_OUTPUT` flag, the test suite will also compare the
output of your code after insertion into the virtual machine to the output of
the reference compiler. This only makes sense if you are already generating
bytecode!

### Running

To run the suite, navigate to the test directory and execute the test script
using a command such as `./test.sh`. If you have set everything up correctly,
you should get output similar to the following:

    Running failure tests...
    Test fail/embargo.cvc should not succeed!
    Running success tests...
    Test success/array_size.cvc should not fail!
    Test success/local_array.cvc should not fail!
    Test success/print_matrix.cvc should not fail!
    Test success/queens.cvc should not fail!
    Test success/quicksort.cvc should not fail!
    Test success/short_circuit.cvc should not fail!
    Test success/short_circuit_or.cvc should not fail!
    Passed 53 out of 61 tests. Your grade: 8.6.

## Patches

There are some blatant issues with the framework provided. Mainly, the C
proprocessor is proken and secondly, the framework wastes a lot of memory by
using strucs where is should use unions. Provided with this starter kit are
patches that fix these issues. To fix the problems, run the following from your
project root:

    (cd src/; patch -p1 -i ../test/patches/fix_unions.diff)
    (cd src/; patch -p1 -i ../test/patches/fix_preprocessor.diff)

## Updating

To update the test suite submodule, run the following command:

    git submodule foreach git pull origin master

## Contributing

You are encouraged to add your own tests to the suite. Granted that you insert
them into the right directory, the suite should adapt to any number of tests.
For reference, the reference compiler should score a perfect score. Please make
a pull request to share your tests with others so we can all profit from your
work!

## License

This code is licensed under the Unlicense, so you are completely free to do
anything you want with this code. Just don't come up to me crying if something
goes wrong.
