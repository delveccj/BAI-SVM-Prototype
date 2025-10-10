#!/usr/bin/env python3
"""
Main script to run SVM examples.
Usage: python -m SVMs.main [example_type]
"""

import sys
from .config import setup_environment
from .linear_svm import LinearSVMExamples
from .nonlinear_svm import NonlinearSVMExamples
from .soft_margin import SoftMarginSVMExamples
from .svm_regression import SVMRegressionExamples

def main():
    """Run SVM examples."""
    setup_environment()
    
    if len(sys.argv) > 1:
        example_type = sys.argv[1].lower()
    else:
        example_type = "all"
    
    print("🎯 SVM Examples - Standalone Python Implementation")
    print("=" * 50)
    
    if example_type in ["linear", "all"]:
        print("\n📏 Linear SVM Examples:")
        linear_examples = LinearSVMExamples()
        linear_examples.run_all()
    
    if example_type in ["soft", "all"]:
        print("\n🎛️ Soft Margin SVM Examples:")
        soft_examples = SoftMarginSVMExamples()
        soft_examples.run_all()
    
    if example_type in ["nonlinear", "all"]:
        print("\n🎪 Nonlinear SVM Examples:")
        nonlinear_examples = NonlinearSVMExamples()
        nonlinear_examples.run_all()
    
    if example_type in ["regression", "all"]:
        print("\n📊 SVM Regression Examples:")
        regression_examples = SVMRegressionExamples()
        regression_examples.run_all()
    
    print("\n✅ All examples completed!")

if __name__ == "__main__":
    main()