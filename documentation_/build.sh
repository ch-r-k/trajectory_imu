#!/bin/bash
CONTENTDIR="content"
BUILDDIR="build"
FILENAME="documentation"
ASSETSDIR="assets"

pdf_print() {
    mkdir "${BUILDDIR}" -p
    echo "Creating pdf-print output"
    pandoc "${CONTENTDIR}/${FILENAME}.md" \
        --toc -V toc-title:"Inhaltsverzeichnis" \
        --resource-path="${CONTENTDIR}" \
        --csl="${ASSETSDIR}/citation-style.csl" \
        --from="markdown+tex_math_single_backslash+tex_math_dollars+raw_tex" \
        --to="latex" \
        --highlight-style layouts/mytheme.theme \
        --output="${BUILDDIR}/output_print.pdf" \
        --filter pandoc-eqnos \
        --include-in-header="layouts/print.tex"
}

html() {
    mkdir "${BUILDDIR}" -p
    pandoc "${CONTENTDIR}/${FILENAME}.md" \
    --filter pandoc-eqnos \
    --from="markdown+tex_math_single_backslash+tex_math_dollars+raw_tex" \
    --mathml \
    --to=html5 \
    --output="${BUILDDIR}/${FILENAME}.html" \
    --standalone \
    --highlight-style layouts/mytheme.theme
}



pdf_test() {
    mkdir "${BUILDDIR}" -p
    echo "Creating pdf-print output"
    pandoc "${CONTENTDIR}/${FILENAME}.md" --filter pandoc-include -o output.pdf
}

# Allows to call a function based on arguments passed to the script
# Example: `./build.sh pdf_print`
$*