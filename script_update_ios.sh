# This script copies the source files from the src directory to the ios directory.
# Should be run every time the src directory files are updated.

srcPath="src" 
iosSrcPath="ios/Classes/src"

# Remove the source files if they exist
rm -rf $iosSrcPath

# create the source directories
mkdir -p $iosSrcPath

# Copy the source files
rsync -av --exclude '*.txt'  --exclude "include/" "$srcPath/" "$iosSrcPath/" 