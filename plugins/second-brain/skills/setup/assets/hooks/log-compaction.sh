#!/bin/sh
# Appends Claude's compaction summary to "Session Summary.md" in the work folder.
# Claude's working notes before the summary are left out.
# This script writes one local file and sends nothing over the network.

input=$(cat)
stamp=$(date '+%Y-%m-%d %H:%M')
file="$CLAUDE_PROJECT_DIR/Session Summary.md"

if command -v jq >/dev/null 2>&1; then
  printf '%s' "$input" | jq -r --arg stamp "$stamp" '
    (.compact_summary
      | sub("^\\s*<analysis>[\\s\\S]*?</analysis>\\s*"; "")
      | sub("^\\s*<summary>\\s*(?<text>[\\s\\S]*?)\\s*</summary>\\s*$"; "\(.text)")) as $text
    | "\n## " + $stamp + " (" + .trigger + ")\n\n" + $text' >> "$file"
elif command -v perl >/dev/null 2>&1 && perl -MJSON::PP -e 1 2>/dev/null; then
  printf '%s' "$input" | perl -MJSON::PP -0777 -e '
my $hook = JSON::PP->new->utf8->decode(<STDIN>);
my $text = $hook->{compact_summary};
$text =~ s/^\s*<analysis>.*?<\/analysis>\s*//s;
$text =~ s/^\s*<summary>\s*(.*?)\s*<\/summary>\s*$/$1/s;
binmode STDOUT, ":encoding(UTF-8)";
print "\n## $ARGV[0] ($hook->{trigger})\n\n$text\n";
' "$stamp" >> "$file"
# On macOS, python3 is a placeholder that asks to install Apple's developer tools until they're installed.
elif command -v python3 >/dev/null 2>&1 && { [ "$(uname -s)" != Darwin ] || xcode-select -p >/dev/null 2>&1; }; then
  printf '%s' "$input" | python3 -c '
import json, re, sys
hook = json.load(sys.stdin)
text = re.sub(r"^\s*<analysis>.*?</analysis>\s*", "", hook["compact_summary"], flags=re.S)
text = re.sub(r"^\s*<summary>\s*(.*?)\s*</summary>\s*$", r"\1", text, flags=re.S)
print("\n## {} ({})\n\n{}".format(sys.argv[1], hook["trigger"], text))
' "$stamp" >> "$file"
else
  echo "second-brain: install jq, perl, or python3 to enable the compaction log" >&2
fi
