#!/usr/bin/env bash
# update code between tag inside markdown

MD_FILE="README.md"
START="<!-- list file 0 -->"
END="<!-- list file 1 -->"

# Content to insert
OUTPUT=$(\ls -1 *.sh | xargs -I {} bash -c "echo -n - {}: ;sed -ne '2p' {} | sed 's/^\\#//'")

# Update Markdown file between tag START and END
awk -v start="$START" -v end="$END" -v content="$OUTPUT" '
BEGIN { in_block=0 }
{
	if ($0 ~ start) {
	 print
	 print content
	 in_block=1
	next
	}
	 if ($0 ~ end) {
	  in_block=0
	  print
	next
	  }
	  if (!in_block) {
	    print
	  }
}
' "$MD_FILE" >"${MD_FILE}.tmp"

mv "${MD_FILE}.tmp" "$MD_FILE"
