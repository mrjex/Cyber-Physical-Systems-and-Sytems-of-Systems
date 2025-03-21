# Remove the files from git tracking but keep them on your disk
git rm --cached "individual-assignments/2. A5-Bonus/joelmat-example.tar.gz"
git rm --cached "individual-assignments/4. A13 - Access data from the miniature car/submission-showcase.mp4"
git rm --cached "individual-assignments/5. A14 - Object detection with HSV/submission-showcase.mp4"
git rm --cached "presentations/MS3 - Final Presentation.mp4"

# Add them to .gitignore
echo "*.mp4" >> .gitignore
echo "*.tar.gz" >> .gitignore

# Commit and push
git add .gitignore
git commit -m "Remove large files and update gitignore"
git push