echo "Running file: $(basename "$0")"

git add .
git commit -m "Update test"
git push
