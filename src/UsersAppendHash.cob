       IDENTIFICATION DIVISION.
       PROGRAM-ID. USERS-APPEND-HASH.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT UserLogin ASSIGN TO "../database/users.csv"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-USERS-STAT.
           SELECT TempPassword ASSIGN TO "../temp/password_input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TempHash ASSIGN TO "../temp/password_hash.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.
       FD  UserLogin.
       01  Users-Rec          PIC X(256).

       FD  TempPassword.
       01  Pw-Rec             PIC X(256).

       FD  TempHash.
       01  Hash-Rec           PIC X(256).

       WORKING-STORAGE SECTION.
       01  WS-OUT             PIC X(256).
       01  WS-CMD             PIC X(700).
       01  WS-USERS-STAT      PIC XX VALUE "00".

       LINKAGE SECTION.
       01  L-USERNAME         PIC X(30).
       01  L-PASSWORD         PIC X(30).
       01  L-STATUS           PIC X.

       PROCEDURE DIVISION USING L-USERNAME L-PASSWORD L-STATUS.
           MOVE "N" TO L-STATUS

           INSPECT L-USERNAME REPLACING ALL X"0D" BY SPACE
           INSPECT L-PASSWORD REPLACING ALL X"0D" BY SPACE

           OPEN OUTPUT TempPassword
           MOVE SPACES TO Pw-Rec
           MOVE FUNCTION TRIM(L-PASSWORD) TO Pw-Rec
           WRITE Pw-Rec
           CLOSE TempPassword

           MOVE SPACES TO WS-CMD
           STRING "/bin/sh -c ""../scripts/hash_password.sh < ../temp/password_input.txt > ../temp/password_hash.txt"""
               DELIMITED BY SIZE INTO WS-CMD
           CALL "SYSTEM" USING WS-CMD

           OPEN INPUT TempHash
           READ TempHash INTO Hash-Rec
               AT END
                   CLOSE TempHash
                   GOBACK
           END-READ
           CLOSE TempHash

           *> Delete temp hash file
           CALL "SYSTEM" USING "rm -f /workspace/temp/password_hash.txt"

           MOVE SPACES TO WS-OUT
           STRING FUNCTION TRIM(L-USERNAME)
                  "|"
                  FUNCTION TRIM(Hash-Rec)
               DELIMITED BY SIZE INTO WS-OUT

           OPEN EXTEND UserLogin
           IF WS-USERS-STAT NOT = "00"
               OPEN OUTPUT UserLogin
               CLOSE UserLogin
               OPEN EXTEND UserLogin
           END-IF

           MOVE WS-OUT TO Users-Rec
           WRITE Users-Rec
           CLOSE UserLogin

           MOVE "Y" TO L-STATUS
           GOBACK.
       END PROGRAM USERS-APPEND-HASH.
