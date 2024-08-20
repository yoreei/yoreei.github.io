#!/bin/bash

# Step 1: Run Hugo to build the site into the 'docs' directory
hugo -d docs

# Step 2: Create a .nojekyll file in the 'docs' directory
touch docs/.nojekyll

# Step 3: Output a success message
echo "Site built successfully and .nojekyll file created in the docs directory."

