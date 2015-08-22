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
A complete environment was created using the Dockerfile file based on the heroku cedar stack v14.

This buildpack will download that environment and place it in your /app/.heroku folder.
This includes the following:
- Python-2.7.10
- Pip-7.1.1
- Setuptools-18.2
- Opencv-3.0.0 (with python support)
- Numpy-1.9.2
- Scipy-0.16.0
