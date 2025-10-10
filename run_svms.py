#!/usr/bin/env python3
"""
Simple script to run SVM examples.
Usage: python run_svms.py [linear|soft|nonlinear|regression|all]
"""

import sys
import os

# Add current directory to path
sys.path.insert(0, os.path.dirname(__file__))

from SVMs.main import main

if __name__ == "__main__":
    main()