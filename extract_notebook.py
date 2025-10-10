#!/usr/bin/env python3
"""
Script to extract code cells from the SVM Jupyter notebook and organize them into Python modules.
"""

import json
import os
from pathlib import Path

def extract_code_cells(notebook_path):
    """Extract all code cells from a Jupyter notebook."""
    with open(notebook_path, 'r') as f:
        notebook = json.load(f)
    
    code_cells = []
    for i, cell in enumerate(notebook['cells']):
        if cell['cell_type'] == 'code':
            source = ''.join(cell['source']).strip()
            if source:  # Skip empty cells
                code_cells.append({
                    'cell_num': i,
                    'source': source
                })
    
    return code_cells

def categorize_code_cells(code_cells):
    """Categorize code cells based on their content."""
    categories = {
        'setup': [],
        'linear_svm': [],
        'soft_margin': [],
        'nonlinear_svm': [],
        'svm_regression': [],
        'implementation': [],
        'visualization': [],
        'exercises': []
    }
    
    for cell in code_cells:
        source_lower = cell['source'].lower()
        
        # Setup and imports
        if any(keyword in source_lower for keyword in ['import', 'assert', 'plt.rc', 'images_path']):
            categories['setup'].append(cell)
        # Linear SVM
        elif any(keyword in source_lower for keyword in ['linearsvc', 'linear svm', 'linear classification']):
            categories['linear_svm'].append(cell)
        # Soft margin
        elif any(keyword in source_lower for keyword in ['soft margin', 'c=', 'regularization']):
            categories['soft_margin'].append(cell)
        # Nonlinear SVM
        elif any(keyword in source_lower for keyword in ['polynomial', 'rbf', 'kernel', 'gamma']):
            categories['nonlinear_svm'].append(cell)
        # SVM Regression
        elif any(keyword in source_lower for keyword in ['svr', 'regression', 'housing']):
            categories['svm_regression'].append(cell)
        # Implementation
        elif any(keyword in source_lower for keyword in ['class mysvm', 'gradient', 'sgd']):
            categories['implementation'].append(cell)
        # Visualization
        elif any(keyword in source_lower for keyword in ['plot', 'contour', 'decision_boundary', 'save_fig']):
            categories['visualization'].append(cell)
        # Exercises
        elif any(keyword in source_lower for keyword in ['exercise', '# solution']):
            categories['exercises'].append(cell)
        else:
            # Default to linear_svm if unclear
            categories['linear_svm'].append(cell)
    
    return categories

def main():
    notebook_path = 'svm_notebook.ipynb'
    svms_dir = Path('SVMs')
    svms_dir.mkdir(exist_ok=True)
    
    # Extract all code cells
    code_cells = extract_code_cells(notebook_path)
    print(f"Extracted {len(code_cells)} code cells")
    
    # Categorize cells
    categories = categorize_code_cells(code_cells)
    
    # Print summary
    for category, cells in categories.items():
        print(f"{category}: {len(cells)} cells")
    
    # Write each category to a separate file
    for category, cells in categories.items():
        if cells:  # Only create files for non-empty categories
            filename = svms_dir / f"{category}.py"
            with open(filename, 'w') as f:
                f.write(f'"""\n{category.replace("_", " ").title()} - Extracted from SVM Notebook\n"""\n\n')
                
                for i, cell in enumerate(cells):
                    f.write(f"# === Cell {cell['cell_num']} ===\n")
                    f.write(cell['source'])
                    f.write('\n\n')
            
            print(f"Created {filename}")

if __name__ == '__main__':
    main()