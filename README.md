# InCollege -- COBOL Login System

## Project Overview

InCollege is a **COBOL-based login and account creation system**. It
supports user authentication, account management, and automated testing
using scripted input/output.

## Project Structure

    bin/
      InCollege

    scripts/
      build_and_run.sh
      run_automated_tests.sh
      hash_pw.sh
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

From the `scripts` directory, run:

``` sh
./build_and_run.sh
```

This script: - Compiles the COBOL source files - Removes old persistent
files - Produces the executable

### Run

After building, run the program from:

``` sh
/bin/InCollege
```

## Automated Testing

To run automated test cases:

1.  Place test input files in:

```{=html}
<!-- -->
```
    /test/automated-tests/input

2.  Run the automated test script:

``` sh
./scripts/run_automated_tests.sh
```

3.  Output files will be generated in:

```{=html}
<!-- -->
```
    /test/automated-tests/output

Each test input produces a corresponding output file.
