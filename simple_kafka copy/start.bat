@echo off
echo wait until ksqldb ready...
rem build and deply
docker compose up -d --build
setlocal enabledelayedexpansion
rem wait until kafka server is ready
rem wait until ksqldb is ready
for /l %%i in (1,1,90) do (
    set "status="
    for /f "delims=" %%a in ('curl --http1.1 -s http://localhost:8088/info' ) do (
        set line=%%a
        rem echo this is line !line!
    )
    for /f "tokens=2 delims=:" %%a in ("!line:*serverStatus=!") do (
        set "tmp=%%a"
    )
    rem echo status !tmp!
    set "tmp=!tmp:"=!"
    set "tmp=!tmp:,=!"
    set "tmp=!tmp:}=!"
    set "tmp=!tmp: =!"
    echo status-!tmp!-
    if /i "!tmp!"=="RUNNING" (
        echo Server Running:  !line!
        goto :end
    )
    timeout /t 2 > nul
)
echo wait until topics ready...
:end 
rem Init ksqldb
echo wait until topics ready...
docker exec -it ksqldb-server /bin/ksql --file /home/appuser/init-sql/init.sql
