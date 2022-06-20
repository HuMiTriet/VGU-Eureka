#!/bin/bash

kill $(lsof -t -i:9099)
kill $(lsof -t -i:5001)
# kill firestore
kill $(lsof -t -i:8080)
# kill realtime database
kill $(lsof -t -i:9000)
kill $(lsof -t -i:8085)
kill $(lsof -t -i:9199)

