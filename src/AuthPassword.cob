       IDENTIFICATION DIVISION.
       PROGRAM-ID. PW-VALIDATE.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-PW-LEN        PIC 9(2).
       01  WS-HAS-UPPER     PIC X VALUE "N".
       01  WS-HAS-DIGIT     PIC X VALUE "N".
       01  WS-HAS-SPECIAL   PIC X VALUE "N".
       01  WS-CHAR          PIC X.
       01  WS-I             PIC 9(2).

       LINKAGE SECTION.
       01  L-PASSWORD       PIC X(30).
       01  L-VALID          PIC X.

       PROCEDURE DIVISION USING L-PASSWORD L-VALID.
           MOVE "N" TO L-VALID
           MOVE "N" TO WS-HAS-UPPER WS-HAS-DIGIT WS-HAS-SPECIAL

           MOVE FUNCTION LENGTH(FUNCTION TRIM(L-PASSWORD)) TO WS-PW-LEN
           IF WS-PW-LEN < 8 OR WS-PW-LEN > 12
               GOBACK
           END-IF

           PERFORM VARYING WS-I FROM 1 BY 1
             UNTIL WS-I > WS-PW-LEN
               MOVE L-PASSWORD(WS-I:1) TO WS-CHAR

               IF WS-CHAR >= "A" AND WS-CHAR <= "Z"
                   MOVE "Y" TO WS-HAS-UPPER
               ELSE
                   IF WS-CHAR >= "0" AND WS-CHAR <= "9"
                       MOVE "Y" TO WS-HAS-DIGIT
                   ELSE
                       MOVE "Y" TO WS-HAS-SPECIAL
                   END-IF
               END-IF
           END-PERFORM

           IF WS-HAS-UPPER = "Y"
              AND WS-HAS-DIGIT = "Y"
              AND WS-HAS-SPECIAL = "Y"
               MOVE "Y" TO L-VALID
           END-IF

           GOBACK.
       END PROGRAM PW-VALIDATE.
