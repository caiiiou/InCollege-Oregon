       IDENTIFICATION DIVISION.
       PROGRAM-ID. USERS-LOOKUP.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT UserLogin ASSIGN TO "../database/users.csv"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-USERS-STAT.

       DATA DIVISION.
       FILE SECTION.
       FD  UserLogin.
       01  Users-Rec          PIC X(256).

       WORKING-STORAGE SECTION.
       01  WS-U               PIC X(60).
       01  WS-H               PIC X(256).
       01  WS-USERS-STAT      PIC XX VALUE "00".

       LINKAGE SECTION.
       01  L-USERNAME         PIC X(30).
       01  L-FOUND            PIC X.
       01  L-HASH             PIC X(256).

       PROCEDURE DIVISION USING L-USERNAME L-FOUND L-HASH.
           MOVE "N" TO L-FOUND
           MOVE SPACES TO L-HASH

           INSPECT L-USERNAME REPLACING ALL X"0D" BY SPACE

           OPEN INPUT UserLogin
           IF WS-USERS-STAT NOT = "00"
               CLOSE UserLogin
               GOBACK
           END-IF

           PERFORM UNTIL 1 = 2
               READ UserLogin
                   AT END
                       EXIT PERFORM
               END-READ

               MOVE SPACES TO WS-U WS-H
               UNSTRING Users-Rec DELIMITED BY "|"
                   INTO WS-U WS-H

               INSPECT WS-U REPLACING ALL X"0D" BY SPACE

               IF FUNCTION TRIM(WS-U) = FUNCTION TRIM(L-USERNAME)
                   MOVE "Y" TO L-FOUND
                   MOVE FUNCTION TRIM(WS-H) TO L-HASH
                   EXIT PERFORM
               END-IF
           END-PERFORM

           CLOSE UserLogin
           GOBACK.
       END PROGRAM USERS-LOOKUP.
