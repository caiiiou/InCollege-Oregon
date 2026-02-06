# InCollege -- COBOL Login System

## Project Overview

InCollege is a **COBOL-based login and account creation system**. It
supports user authentication, account management, and automated testing
using scripted input/output.

## Project Structure

    bin/
      InCollege

    scripts/
      build.sh
      run_automated_tests.sh
      hash_password.sh
      verify_password_files.sh

    database/
      users.csv

    input/
      InCollege-Input.txt

    output/
      Incollege-Output.txt

    test/
      automated-tests/
        input/
        output/

## Building and Running

### Build

Open Visual Studio Code Dev Container

From the `workspace` directory, run:

``` sh
./scripts/build.sh
```

This script: - Compiles the COBOL source files - Removes old persistent
files - Produces the executable

### Run

After building, run the program from the `workspace` directory:

``` sh
./bin/InCollege
```

## Automated Testing

To run automated test cases:

1.  Place test input files in:

``` sh
/test/automated-tests/input
```
with number prepended to test name for example

```
01_descriptive-test-case.txt
```

2.  Run the automated test script:

``` 
./scripts/run_automated_tests.sh
```

3.  Output files will be generated in:

``` 
/test/automated-tests/output
```
Each test input produces a corresponding output file.  
Note: output files are deleted after running the build script
