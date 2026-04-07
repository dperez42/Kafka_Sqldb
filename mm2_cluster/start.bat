@echo off
echo wait until ksqldb ready...
rem build and deply
docker compose up -d --build
setlocal enabledelayedexpansion


echo wait until mirror maker is ready...
echo Waiting for 10 seconds...
timeout /t 20 /nobreak >nul
echo Done.
docker exec -it -d mirror-maker /bin/bash /bin/connect-mirror-maker mm2.properties

echo Create a topic in cluster A.
docker exec -it mirror-maker /bin/bash /bin/kafka-topics --bootstrap-server broker1A:9092 --create --topic topic1 --partitions 2 --replication-factor 2 