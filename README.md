# Heroku buildpack with Python, OpenCV, Numpy and SciPy

## What
This buildpack provides a self-contained environment for python applications that need:
OpenCV, Numpy or Scipy.

## Why
- Existing OpenCV buildpacks didin't work for me or python support simply wasn't there.
- All sorts of issues with heroku python buildpack and OpenCV.
- All sorts of issues with cedar stack default python and OpenCV.
- Compiling things in a one-off dyno is slow.

## How
A complete environment was created using a docker container running ubuntu 10.04.

This buildpack will download that environment and place it in your /app/.heroku folder.
This includes the following:
- Python-2.7.6
- Pip-1.5.4
- Setuptools-3.4.4
- Opencv-2.4.9 (with python support)
- Numpy-1.8.1
- Scipy-0.13.3
