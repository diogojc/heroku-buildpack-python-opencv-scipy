#!/bin/bash
docker build -t diogojc/opencvvendor:latest .
docker run --rm -v data:/vendoring diogojc/opencvvendor:latest