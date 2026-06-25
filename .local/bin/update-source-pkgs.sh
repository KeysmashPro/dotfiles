#!/bin/dash

src="$HOME/Sources"
ordered="beaker omnisearch"
ok="$(mktemp)"

pull_one() {
  dir="$1"
  name=$(basename "$dir")
  out=$(git -C "$dir" pull 2>&1)

  if [ $? -eq 0 ]; then
    printf '\033[1;32m[OK]\033[0m %s\n' "$name"
    printf '%s\n' "$name" >> "$ok"
  else
    printf '\033[1;31m[ERROR]\033[0m \033[1m%s\033[0m: %s\n' "$name" "$out"
  fi
}

build_one() {
  dir="$1"
  name=$(basename "$dir")
  out=$(cd "$dir" && just 2>&1)

  if [ $? -eq 0 ]; then
    printf '\033[1;32m[OK]\033[0m %s\n' "$name"
  else
    printf '\033[1;31m[ERROR]\033[0m \033[1m%s\033[0m: %s\n' "$name" "$out"
  fi
}

for dir in "$src"/*/; do
  [ -d "$dir/.git" ] || continue
  pull_one "$dir" &
done
wait

for name in $ordered; do
  dir="$src/$name"
  [ -d "$dir/.git" ] || continue
  grep -Fxq "$name" "$ok" && build_one "$dir"
done

for dir in "$src"/*/; do
  [ -d "$dir/.git" ] || continue
  name=$(basename "$dir")

  skip=0
  for o in $ordered; do
    [ "$name" = "$o" ] && skip=1
  done
  [ $skip -eq 1 ] && continue

  grep -Fxq "$name" "$ok" && build_one "$dir" &
done
wait

rm -f "$ok"

