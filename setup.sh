#!/bin/bash
# Setup script for coral-reef-analysis repository
# Run this once to create the complete directory structure

echo "=========================================="
echo "Setting up coral-reef-analysis repository"
echo "=========================================="
echo ""

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo "Initializing Git repository..."
    git init
    echo "✓ Git initialized"
else
    echo "✓ Git repository already exists"
fi
echo ""

# Create Project 1 directories
echo "Creating Project 1 (Reef Geospatial Analysis) directories..."
mkdir -p project-01-reef-geospatial/{data/{raw,processed},outputs}
touch project-01-reef-geospatial/data/raw/.gitkeep
touch project-01-reef-geospatial/data/processed/.gitkeep
touch project-01-reef-geospatial/outputs/.gitkeep
echo "✓ Project 1 directories created"
echo ""

# Create Project 2 directories
echo "Creating Project 2 (Eco-Socio Integration) directories..."
mkdir -p project-02-eco-socio-integration/{data/{raw,processed},outputs}
touch project-02-eco-socio-integration/data/raw/.gitkeep
touch project-02-eco-socio-integration/data/processed/.gitkeep
touch project-02-eco-socio-integration/outputs/.gitkeep
echo "✓ Project 2 directories created"
echo ""

# Create docs directory
echo "Creating shared documentation directory..."
mkdir -p docs
echo "✓ Docs directory created"
echo ""

# Create .gitignore
echo "Creating .gitignore file..."
cat > .gitignore << 'EOF'
# Data files (regenerated from scripts)
project-01-reef-geospatial/data/raw/*.csv
project-01-reef-geospatial/data/raw/*.tif
project-01-reef-geospatial/data/raw/*.tiff
project-01-reef-geospatial/data/processed/*.csv
project-01-reef-geospatial/outputs/*.png
project-01-reef-geospatial/outputs/*.pdf
project-01-reef-geospatial/outputs/*.csv

project-02-eco-socio-integration/data/raw/*.csv
project-02-eco-socio-integration/data/processed/*.csv
project-02-eco-socio-integration/outputs/*.png
project-02-eco-socio-integration/outputs/*.pdf
project-02-eco-socio-integration/outputs/*.csv

# R files
.Rhistory
.Rdata
.RDataTmp
*.Rproj
.Rproj.user/

# System files
.DS_Store
Thumbs.db
.directory

# IDE files
.vscode/
.idea/

# Keep directory structure
!**/.gitkeep
EOF
echo "✓ .gitignore created"
echo ""

# Display directory structure
echo "=========================================="
echo "Repository structure created:"
echo "=========================================="
echo ""
tree -L 3 -I '.git' --charset ascii 2>/dev/null || find . -maxdepth 3 -not -path '*/\.*' -print | sed 's|[^/]*/| |g'
echo ""

echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Copy R scripts to each project folder:"
echo "   - generate_raw_data_FIXED.R → project-01-reef-geospatial/"
echo "   - analyze_reef_data_FIXED.R → project-01-reef-geospatial/"
echo "   - generate_eco_socio_data_FIXED.R → project-02-eco-socio-integration/"
echo "   - analyze_eco_socio_data_FIXED.R → project-02-eco-socio-integration/"
echo ""
echo "2. Copy documentation files:"
echo "   - Project 1 docs → project-01-reef-geospatial/"
echo "   - Project 2 docs → project-02-eco-socio-integration/"
echo "   - Shared docs → docs/"
echo ""
echo "3. Initialize Git and commit:"
echo "   git add ."
echo "   git commit -m 'Initial project setup'"
echo ""
echo "4. Run the analysis:"
echo "   cd project-01-reef-geospatial && Rscript generate_raw_data_FIXED.R"
echo "   cd ../project-02-eco-socio-integration && Rscript generate_eco_socio_data_FIXED.R"
echo ""
