if [[ -n "$1" ]]; then
  cd "$1"
else
  echo "Error: pass root directory as argument"
  exit 1
fi

find . \( -type f -o -type l \) ! -name . ! -name .. -print0 | sort -rz | while IFS= read -r -d '' f; do
  if [[ $f != *.gitkeep ]]; then
    echo "Removing file: $f"
    rm "$f"
  fi
done

find . -type d ! -name . ! -name .. -print0 | sort -rz | while IFS= read -r -d '' d; do
  if [ -z "$(ls -A "$d")" ]; then
    echo "Removing directory: $d"
    rmdir "$d"
  fi
done
