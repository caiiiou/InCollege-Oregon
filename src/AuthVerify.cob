       IDENTIFICATION DIVISION.
       PROGRAM-ID. AUTH-VERIFY.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TempPassword ASSIGN TO "/workspace/temp/password_input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TempStoredHash ASSIGN TO "/workspace/temp/stored_hash.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  TempPassword.
       01  Pw-Rec             PIC X(256).

       FD  TempStoredHash.
       01  Hash-Rec           PIC X(256).

       WORKING-STORAGE SECTION.
       01  WS-CMD             PIC X(600).
       01  WS-EXIT            PIC S9(9) COMP VALUE 0.

       LINKAGE SECTION.
       01  L-PASSWORD         PIC X(30).
       01  L-STORED-HASH      PIC X(256).
       01  L-OK               PIC X.

       PROCEDURE DIVISION USING L-PASSWORD L-STORED-HASH L-OK.
           MOVE "N" TO L-OK

           *> Normalize inputs (strip CR if any)
           INSPECT L-PASSWORD REPLACING ALL X"0D" BY SPACE
           INSPECT L-PASSWORD REPLACING ALL X"0A" BY SPACE
           INSPECT L-STORED-HASH REPLACING ALL X"0D" BY SPACE
           INSPECT L-STORED-HASH REPLACING ALL X"0A" BY SPACE

           *> Write candidate password to temp file
           OPEN OUTPUT TempPassword
           MOVE SPACES TO Pw-Rec
           MOVE FUNCTION TRIM(L-PASSWORD) TO Pw-Rec
           WRITE Pw-Rec
           CLOSE TempPassword

           *> Write stored hash to temp file
           OPEN OUTPUT TempStoredHash
           MOVE SPACES TO Hash-Rec
           MOVE FUNCTION TRIM(L-STORED-HASH) TO Hash-Rec
           WRITE Hash-Rec
           CLOSE TempStoredHash

           *> Run verify script with file arguments (no quoting needed)
           MOVE SPACES TO WS-CMD
           STRING "/workspace/scripts/verify_password_files.sh "
                  "/workspace/temp/password_input.txt "
                  "/workspace/temp/stored_hash.txt"
               DELIMITED BY SIZE INTO WS-CMD

           CALL "SYSTEM" USING WS-CMD

           *> Normalize RETURN-CODE (some envs return wait()-style status)
           MOVE RETURN-CODE TO WS-EXIT
           IF WS-EXIT >= 256
               DIVIDE WS-EXIT BY 256 GIVING WS-EXIT
           END-IF

           IF WS-EXIT = 0
               MOVE "Y" TO L-OK
           END-IF

           GOBACK.
       END PROGRAM AUTH-VERIFY.
