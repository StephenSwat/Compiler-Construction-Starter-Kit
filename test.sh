#!/bin/bash

# If this is set to true, compare the output of the user compiler to that of the reference compiler.
CHECK_OUTPUT=false

# If this is set to true, print a single line hint why a test should succeed or fail.
SHOW_HINTS=true

# Fill in your compiler command and any flags here.
COMPILER=cccp
COMPILER_ARGS=-t

# Fill in the reference compiler and its flags here.
REFERENCE_COMPILER=civcc
REFERENCE_COMPILER_ARGS=

# Fill in the assembler and virtual machine here.
ASSEMBLER=civas
VM=civvm

# Do not touch anything below.
FAIL=0
TOTAL=0

execute() {
    $1 $2 -o _tmp_$1.s $3
    $ASSEMBLER -o _tmp_$1.out _tmp_$1.s
    $VM _tmp_$1.out >/dev/null 2>&1
    rm -f _tmp_$1.s _tmp_$1.out
}

command -v $COMPILER >/dev/null 2>&1 || { echo "$COMPILER is not an executable file."; exit 1; }

echo "Running failure tests..."
for x in fail/*.cvc; do
    TOTAL=$((TOTAL+1))
    $COMPILER $COMPILER_ARGS $x 1>/dev/null 2>/dev/null && {
        ERROR=$(head -1 $x | grep '//' | cut -c4-);
        if [ -n "$ERROR" ] && [ $SHOW_HINTS = true ]; then
            echo -n "Test $x should not succeed... ";
            echo $ERROR;
        else
            echo "Test $x should not succeed!";
        fi
        FAIL=$((FAIL+1));
    }
done

echo "Running success tests..."
for x in success/*.cvc; do
    TOTAL=$((TOTAL+1))
    $COMPILER $COMPILER_ARGS $x 1>/dev/null 2>/dev/null || {
        ERROR=$(head -1 $x | grep '//' | cut -c4-);
        if [ -n "$ERROR" ] && [ $SHOW_HINTS = true ]; then
            echo -n "Test $x should not fail... ";
            echo $ERROR;
        else
            echo "Test $x should not fail!";
        fi
        FAIL=$((FAIL+1));
        continue;
    }

    if [ $CHECK_OUTPUT = true ]; then
        diff <(execute $REFERENCE_COMPILER $REFERENCE_COMPILER_ARGS $x) \
             <(execute $COMPILER $COMPILER_ARGS $x) >/dev/null \
             || { echo "Test $x did not match reference output!"; FAIL=$((FAIL+1)); }
    fi
done

echo "Passed $((TOTAL-FAIL)) out of $((TOTAL)) tests. Your grade: $(bc -l <<< "scale=1; ($TOTAL-$FAIL) * 10 / $TOTAL")."

if [ $FAIL -eq 0 ]; then
    echo "Well done! :)";
fi
