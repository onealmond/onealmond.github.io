#!/bin/bash

src=$1

if [[ -z $src ]] ;then echo "src not given"; exit 0; fi
if [[ ! -d $src ]] ;then echo "src should be a directory"; exit 0; fi
puzzles=""

function generate_writeup_html {
  echo "Generating writeup html for $src"
  for f in $(ls -t `find "$src" -name "writeup.md"`); do
    dst=`sed "s|${src}||g" <<< $f`
    dst="ctf/"`basename $src`/$dst
    title=`awk -F/ '{print $(NF-1)}' <<< $dst`
    dst="$(dirname $dst).html"

    puzzles="$puzzles $(basename $dst):$title"

    title=$(sed "s|-| |g" <<< $title)
    title=`python3 -c "print(input().title())" <<< $title`

    echo "Generating '$title': $dst"
    mkdir -p `dirname $dst`
    ./scripts/md2html.sh $f "$dst" "$title"
  done
}

function generate_event_index {
echo "Generating index.html for $src"
dst="ctf/"`basename $src`"/index.html"
echo "Generating $dst"
cat > "$dst" << EOF
<html>
<head>
EOF
cat >> "$dst" < templates/writeup-head.html
cat >> "$dst" << EOF
</head>
<body>
EOF
cat >> "$dst" < templates/writeup-before-body.html
cat >> "$dst" << EOF
      <ul>
EOF

for f in $puzzles; do
  title=$(awk -F: '{print $2}' <<< "$f")
  title=$(sed "s|-| |g" <<< $title)
  title=`python3 -c "print(input().title())" <<< $title`
  file=$(awk -F: '{print $1}' <<< "$f")
  echo "Indexing '$title': $file"
  cat >> "$dst" << EOF
      <li class="puzzle-item"><a class="toc-item" href="${file}">${title}</a></li>
EOF
done

cat >> "$dst" << EOF
      </ul>
EOF
cat >> "$dst" < templates/writeup-after-body.html

cat >> "$dst" << EOF
</body>
EOF
cat >> "$dst" << EOF
</html>
EOF
}

generate_writeup_html
generate_event_index
