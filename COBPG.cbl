       IDENTIFICATION DIVISION.
       PROGRAM-ID. COBPG.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 PGCONN       USAGE POINTER.
       01 PGRES        USAGE POINTER.
       01 RESPTR       USAGE POINTER.
       01 CONN-STATUS  USAGE BINARY-LONG.
       01 USER         PIC X(80).
       01 RESSTR       PIC X(80) BASED.
       01 ANSWER       PIC X(80).
       PROCEDURE DIVISION.
       DISPLAY "PGCONN ptr before connection : " PGCONN.
       PERFORM 0000-CONNECT.
       DISPLAY "PGCONN ptr after conection   : " PGCONN.
       PERFORM 0001-GET-STATUS.
       DISPLAY "Current Connection Status    : " CONN-STATUS.
       PERFORM 0002-GET-USER.
       DISPLAY "User: " USER.
       PERFORM 0003-QUERY-VERSION.
       DISPLAY "Version: " ANSWER.
       PERFORM 0004-FINISH.
       GOBACK.

       0000-CONNECT.
           CALL "PQconnectdb" USING
               BY REFERENCE "dbname = postgres" & x"00"
               RETURNING PGCONN.

       0001-GET-STATUS.
           CALL "PQstatus" USING BY VALUE PGCONN RETURNING CONN-STATUS.

       0002-GET-USER.
           CALL "PQuser" USING BY VALUE PGCONN RETURNING RESPTR.
           SET ADDRESS OF RESSTR TO RESPTR.
           STRING RESSTR DELIMITED BY x"00" INTO USER.

       0003-QUERY-VERSION.
           CALL "PQexec" USING
               BY VALUE PGCONN
               BY REFERENCE "SELECT version();" & x"00"
               RETURNING PGRES.
           CALL "PQgetvalue" USING
               BY VALUE PGRES
               BY VALUE 0
               BY VALUE 0
               RETURNING RESPTR.
           SET ADDRESS OF RESSTR TO RESPTR.
           STRING RESSTR DELIMITED BY x"00" INTO ANSWER.

       0004-FINISH.
           CALL "PQfinish" USING BY VALUE PGCONN RETURNING NULL.
