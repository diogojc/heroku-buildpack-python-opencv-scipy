# Heroku cedar14 stack buildpack with Python, OpenCV, Numpy, SciPy and Matplotlib

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
- Opencv-2.4.11 (with python support)
- Numpy-1.11.1
- Scipy-0.18.0
- Matplotlib-1.5.3