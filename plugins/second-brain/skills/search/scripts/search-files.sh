#!/bin/sh
# Searches text inside .docx, .xlsx, .pptx, .md, .txt, and .csv files without Microsoft Office.
# This script only reads files and sends nothing over the network.
# On macOS, it skips online-only OneDrive and iCloud files so a search doesn't download them.
# Usage: sh search-files.sh <folder> <text>
# Output is tab-separated: path, file type, matching text.

set -f

folder=$1
query=$2

if [ -z "$folder" ] || [ -z "$query" ]; then
  echo "Usage: sh search-files.sh <folder> <text>" >&2
  exit 2
fi

if ! command -v unzip >/dev/null 2>&1; then
  echo "second-brain: unzip is required to search Office files" >&2
  exit 1
fi

# macOS marks online-only files with the SF_DATALESS flag (0x40000000).
# Reading one downloads it, but stat and find only read its metadata.
mac=0
[ "$(uname -s)" = Darwin ] && mac=1
dataless=1073741824

tab=$(printf '\t')
list=$(mktemp)
trap 'rm -f "$list"' EXIT

find "$folder" -type f \( -iname '*.docx' -o -iname '*.xlsx' -o -iname '*.pptx' \
  -o -iname '*.md' -o -iname '*.txt' -o -iname '*.csv' \) ! -name '~$*' > "$list"

searched=0
matched=0
unreadable=0
online_only=0

while IFS= read -r file; do
  if [ "$mac" = 1 ]; then
    flags=$(stat -f %f "$file" 2>/dev/null)
    if [ $(( ${flags:-0} & dataless )) -ne 0 ]; then
      online_only=$((online_only + 1))
      continue
    fi
  fi

  searched=$((searched + 1))
  case $file in
    *.[Dd][Oo][Cc][Xx])
      kind=docx
      parts='word/document.xml word/comments.xml word/footnotes.xml word/endnotes.xml word/header*.xml word/footer*.xml'
      ;;
    *.[Xx][Ll][Ss][Xx])
      kind=xlsx
      parts='xl/sharedStrings.xml xl/worksheets/sheet*.xml'
      ;;
    *.[Pp][Pp][Tt][Xx])
      kind=pptx
      parts='ppt/slides/slide*.xml ppt/notesSlides/notesSlide*.xml'
      ;;
    *)
      kind=text
      parts=
      ;;
  esac

  if [ "$kind" = text ]; then
    hits=$(grep -i -F -- "$query" "$file" 2>/dev/null | cut -c1-200)
  else
    # unzip exits non-zero when an optional part is missing, so check for text instead.
    # shellcheck disable=SC2086
    text=$(unzip -p "$file" $parts 2>/dev/null)
    if [ -z "$text" ]; then
      unreadable=$((unreadable + 1))
      continue
    fi

    hits=$(printf '%s' "$text" \
      | sed \
        -e 's#<f [^>]*/>##g' \
        -e 's#<f[ >][^<]*</f>##g' \
        -e 's#<c [^>]*t="s"[^>]*><v>[0-9]*</v></c>##g' \
        -e 's#</w:p>#|#g' -e 's#</a:p>#|#g' -e 's#</si>#|#g' -e 's#</c>#|#g' \
        -e 's/<[^>]*>//g' \
        -e 's/&lt;/</g' -e 's/&gt;/>/g' -e 's/&quot;/"/g' -e "s/&apos;/'/g" -e 's/&amp;/\&/g' \
      | tr '|' '\n' \
      | grep -i -F -- "$query" \
      | cut -c1-200)
  fi

  if [ -n "$hits" ]; then
    matched=$((matched + 1))
    printf '%s\n' "$hits" | while IFS= read -r line; do
      printf '%s%s%s%s%s\n' "$file" "$tab" "$kind" "$tab" "$line"
    done
  fi
done < "$list"

echo "# Searched $searched files. Matches in $matched files. Skipped: $online_only online-only, $unreadable unreadable or password-protected."
