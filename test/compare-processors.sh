#!/usr/bin/env bash
#
# Convert every test record with both Saxon and libxslt and require the two
# results to agree.
#
# The XSpec suite runs under Saxon only, so a construct that Saxon evaluates
# correctly and libxslt does not passes CI and still produces wrong output for
# the many downstream users on libxslt -- lxml (Python), Nokogiri (Ruby), PHP's
# XSL extension, XML::LibXSLT (Perl) and xsltproc itself.
#
# Both results are rendered through test/normalize.xsl before comparison, by
# the same processor, so that indentation, attribute order and the placement of
# namespace declarations do not count as differences.
#
# Usage:
#   SAXON_CP=/path/to/saxon-he-12.4.jar ./test/compare-processors.sh [file...]
#
# With no arguments it checks the records listed in DEFAULT_FILES below. Pass
# paths to check anything else -- pointing it at all of test/data is a quick
# way to see where else the two processors part company.

set -u

cd "$(dirname "$0")/.."

: "${SAXON_CP:?set SAXON_CP to the Saxon jar, e.g. /tmp/saxon/saxon-he-12.4.jar}"

command -v xsltproc >/dev/null || { echo "xsltproc not found"; exit 2; }

STYLESHEET=xsl/marc2bibframe2.xsl
NORMALIZE=test/normalize.xsl

# The transform stamps the current time into the work's admin metadata, which
# would differ between the two runs.
DATESTAMP=2020-01-01T00:00:00

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

# The records this check covers. Deliberately a subset for now: it starts with
# the series data, and should grow as other processor divergences are found and
# resolved.
DEFAULT_FILES=(test/data/ConvSpec-Process6-Series/*.xml)

if [ "$#" -gt 0 ]; then
  files=("$@")
else
  files=("${DEFAULT_FILES[@]}")
fi

failed=0
checked=0

for file in "${files[@]}"; do
  checked=$((checked + 1))

  if ! xsltproc --stringparam pGenerationDatestamp "$DATESTAMP" \
       "$STYLESHEET" "$file" > "$work/libxslt.xml" 2> "$work/libxslt.err"; then
    echo "FAIL $file"
    echo "     libxslt could not convert it:"
    sed 's/^/       /' "$work/libxslt.err"
    failed=$((failed + 1))
    continue
  fi

  if [ ! -s "$work/libxslt.xml" ]; then
    echo "FAIL $file"
    echo "     libxslt produced no output"
    sed 's/^/       /' "$work/libxslt.err"
    failed=$((failed + 1))
    continue
  fi

  java -cp "$SAXON_CP" net.sf.saxon.Transform \
    -s:"$file" -xsl:"$STYLESHEET" "pGenerationDatestamp=$DATESTAMP" \
    -o:"$work/saxon.xml" 2> "$work/saxon.err" || {
      echo "FAIL $file"
      echo "     Saxon could not convert it:"
      sed 's/^/       /' "$work/saxon.err"
      failed=$((failed + 1))
      continue
    }

  xsltproc "$NORMALIZE" "$work/libxslt.xml" > "$work/libxslt.txt"
  xsltproc "$NORMALIZE" "$work/saxon.xml" > "$work/saxon.txt"

  if ! diff -q "$work/libxslt.txt" "$work/saxon.txt" > /dev/null; then
    echo "FAIL $file"
    echo "     libxslt and Saxon disagree (< libxslt, > Saxon), first 20 lines:"
    diff "$work/libxslt.txt" "$work/saxon.txt" | head -20 | sed 's/^/       /'
    failed=$((failed + 1))
    continue
  fi

  echo "ok   $file"
done

echo
if [ "$failed" -gt 0 ]; then
  echo "$failed of $checked records differ between processors"
  exit 1
fi
echo "$checked records convert identically under libxslt and Saxon"
