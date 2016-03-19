#!/bin/bash

# If this is set to true, compare the output of the user compiler to that of the
# reference compiler.
CHECK_OUTPUT=true

# If this is set to true, print a single line hint why a test should succeed or
# fail.
SHOW_HINTS=false

# Fill in your compiler command here.
COMPILER=cccp

# Fill in the reference compiler here.
REFERENCE_COMPILER=civcc

# Fill in the assembler and virtual machine here.
ASSEMBLER=civas
VM=civvm

# Do not touch anything below. Actually, I don't really care what you do because
# it's a local copy so go ahead.
FAIL=0
TOTAL=0

execute() {
    $1 -o _tmp_$2.s $3 >/dev/null 2>&1
    $ASSEMBLER -o _tmp_$2.out _tmp_$2.s 2>&1
    $VM _tmp_$2.out 2>&1
    RV=$?
    rm -f _tmp_$2.s _tmp_$2.out
    return $RV
}

cd "$(dirname "${BASH_SOURCE[0]}")"
shopt -s nullglob
command -v $COMPILER >/dev/null 2>&1 || { echo "$COMPILER is not an executable file."; exit 1; }

echo "Running failure tests..."
for x in fail/*.cvc; do
    TOTAL=$((TOTAL+1))
    $COMPILER $COMPILER_ARGS $x 1>/dev/null 2>/dev/null && execute $COMPILER usr $x >/dev/null && {
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
        echo "Test $x should not fail!";
        FAIL=$((FAIL+1));
        continue;
    }

    if [ $CHECK_OUTPUT = true ]; then
        diff <(execute $REFERENCE_COMPILER ref $x) \
             <(execute $COMPILER usr $x) > /dev/null \
             || { echo "Test $x did not match reference output!"; FAIL=$((FAIL+1)); }
    fi
done

if [ $TOTAL -eq 0 ]; then echo "No tests were run. Make sure you are in the right directory."; exit 1; fi

echo "Passed $((TOTAL-FAIL)) out of $((TOTAL)) tests. Your grade: $(bc -l <<< "scale=1; ($TOTAL-$FAIL) * 10 / $TOTAL")."
if [ $FAIL -eq 0 ]; then echo "Well done! :)"; fi
