       IDENTIFICATION DIVISION.
       PROGRAM-ID. InCollege.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT InputFile ASSIGN TO "/workspace/input/InCollege-Input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OutputFile ASSIGN TO "/workspace/output/Incollege-Output.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT UserLogin ASSIGN TO "/workspace/database/users.csv"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT UserProfiles ASSIGN TO "/workspace/database/profiles.csv"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TempPassword ASSIGN TO "/workspace/temp/password_input.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD  InputFile.
       01  In-Rec                 PIC X(256).

       FD  OutputFile.
       01  Out-Rec                PIC X(256).

       FD  UserLogin.
       01  Users-Rec              PIC X(256).

       FD  UserProfiles.
       01  Profiles-Rec           PIC X(256).

       FD  TempPassword.
       01  Pw-Rec                 PIC X(256).

       WORKING-STORAGE SECTION.
       77  WS-EOF                 PIC X VALUE "N".

       01  WS-LINE                PIC X(256).
       01  WS-CHOICE              PIC X(10).

       01  WS-USERNAME            PIC X(30).
       01  WS-PASSWORD            PIC X(30).
       01  WS-USER-COUNT           PIC 9 VALUE 0.


       01  WS-VALID-PW            PIC X VALUE "N".
       01  WS-FOUND               PIC X VALUE "N".
       01  WS-STORED-HASH         PIC X(256).
       01  WS-AUTH-OK             PIC X VALUE "N".
       01  WS-STATUS              PIC X VALUE "N".

       01  WS-MSG                 PIC X(200).

       PROCEDURE DIVISION.
       MAIN.
           OPEN INPUT  InputFile
           OPEN OUTPUT OutputFile

           PERFORM UNTIL WS-EOF = "Y"
               PERFORM SHOW-TOP-MENU
               PERFORM READ-USER-LINE
               MOVE FUNCTION TRIM(WS-LINE) TO WS-CHOICE

               EVALUATE WS-CHOICE
                   WHEN "1"
                       PERFORM LOGIN-FLOW
                   WHEN "2"
                       PERFORM CREATE-ACCOUNT-FLOW
                   WHEN "9"
                       MOVE "Y" TO WS-EOF
                   WHEN OTHER
                       MOVE "Invalid option. Please try again." TO WS-MSG
                       PERFORM PRINTLN
               END-EVALUATE
           END-PERFORM

           CLOSE InputFile
           CLOSE OutputFile
           STOP RUN
           .

       SHOW-TOP-MENU.
           MOVE "Welcome to InCollege!" TO WS-MSG
           PERFORM PRINTLN
           MOVE "1. Log In" TO WS-MSG
           PERFORM PRINTLN
           MOVE "2. Create New Account" TO WS-MSG
           PERFORM PRINTLN
           MOVE "9. Exit" TO WS-MSG
           PERFORM PRINTLN
           MOVE "Enter your choice:" TO WS-MSG
           PERFORM PRINT
           .

       LOGIN-FLOW.
           MOVE SPACES TO WS-USERNAME WS-PASSWORD WS-STORED-HASH
           MOVE "N" TO WS-FOUND WS-AUTH-OK

           MOVE "Enter username:" TO WS-MSG
           PERFORM PRINT
           PERFORM READ-USER-LINE
           MOVE FUNCTION TRIM(WS-LINE) TO WS-USERNAME

           MOVE "Enter password:" TO WS-MSG
           PERFORM PRINT
           PERFORM READ-USER-LINE
           MOVE FUNCTION TRIM(WS-LINE) TO WS-PASSWORD

           CALL "USERS-LOOKUP" USING WS-USERNAME WS-FOUND WS-STORED-HASH

           IF WS-FOUND NOT = "Y"
               MOVE "Invalid credentials. Please try again." TO WS-MSG
               PERFORM PRINTLN
               EXIT PARAGRAPH
           END-IF

           CALL "AUTH-VERIFY" USING WS-PASSWORD WS-STORED-HASH WS-AUTH-OK

           IF WS-AUTH-OK = "Y"
               MOVE "You have successfully logged in." TO WS-MSG
               PERFORM PRINTLN
           ELSE
               MOVE "Invalid credentials. Please try again." TO WS-MSG
               PERFORM PRINTLN
           END-IF
           .

CREATE-ACCOUNT-FLOW.
           PERFORM COUNT-USERS

           IF WS-USER-COUNT >= 5
               MOVE "All permitted accounts have been created, please come back later"
               TO WS-MSG
               PERFORM PRINTLN
               EXIT PARAGRAPH
           END-IF

    *> Continue normal account creation below
           MOVE SPACES TO WS-USERNAME WS-PASSWORD
           MOVE "N" TO WS-VALID-PW
           MOVE "N" TO WS-STATUS

           MOVE "Enter username:" TO WS-MSG
           PERFORM PRINT
           PERFORM READ-USER-LINE
           MOVE FUNCTION TRIM(WS-LINE) TO WS-USERNAME

           MOVE "Enter password:" TO WS-MSG
           PERFORM PRINT
           PERFORM READ-USER-LINE
           MOVE FUNCTION TRIM(WS-LINE) TO WS-PASSWORD

           CALL "PW-VALIDATE" USING WS-PASSWORD WS-VALID-PW

           IF WS-VALID-PW NOT = "Y"
               MOVE "Password must be 8-12 chars, include 1 uppercase, 1 digit, and 1 special character."
                 TO WS-MSG
               PERFORM PRINTLN
               EXIT PARAGRAPH
           END-IF

           CALL "USERS-APPEND-HASH" USING WS-USERNAME WS-PASSWORD WS-STATUS

           IF WS-STATUS = "Y"
               MOVE "Account created successfully." TO WS-MSG
               PERFORM PRINTLN
           ELSE
               MOVE "Registration failed due to system error." TO WS-MSG
               PERFORM PRINTLN
           END-IF
           .
       COUNT-USERS.
           MOVE 0 TO WS-USER-COUNT
           OPEN INPUT UserLogin
           PERFORM UNTIL 1 = 2
           READ UserLogin
               AT END
           EXIT PERFORM
           END-READ
           ADD 1 TO WS-USER-COUNT
           END-PERFORM
           CLOSE UserLogin
           .


       READ-USER-LINE.
           READ InputFile INTO WS-LINE
               AT END
                   MOVE "Y" TO WS-EOF
                   MOVE SPACES TO WS-LINE
               NOT AT END
                   PERFORM ECHO-INPUT
           END-READ
           .

       PRINT.
           DISPLAY FUNCTION TRIM(WS-MSG) WITH NO ADVANCING
           MOVE FUNCTION TRIM(WS-MSG) TO Out-Rec
           WRITE Out-Rec
           .

       PRINTLN.
           DISPLAY FUNCTION TRIM(WS-MSG)
           MOVE FUNCTION TRIM(WS-MSG) TO Out-Rec
           WRITE Out-Rec
           .

       ECHO-INPUT.
           DISPLAY FUNCTION TRIM(WS-LINE)
           MOVE FUNCTION TRIM(WS-LINE) TO Out-Rec
           WRITE Out-Rec
           .

       END PROGRAM InCollege.
