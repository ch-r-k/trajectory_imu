#!/bin/bash
CONTENTDIR="content"
BUILDDIR="build"
FILENAME="documentation"
ASSETSDIR="assets"

pdf_print() {
    mkdir "${BUILDDIR}" -p
    echo "Creating pdf-print output"
    pandoc "${CONTENTDIR}/${FILENAME}.md" \
        --resource-path="${CONTENTDIR}" \
        --csl="${ASSETSDIR}/citation-style.csl" \
        --from="markdown+tex_math_single_backslash+tex_math_dollars+raw_tex" \
        --to="latex" \
        --highlight-style layouts/mytheme.theme \
        --output="${BUILDDIR}/output_print.pdf" \
        --include-in-header="layouts/print.tex"
}

pdf_ereader() {
    mkdir "${BUILDDIR}" -p
    echo "Creating pdf-ereader output"
    pandoc "${CONTENTDIR}/${FILENAME}.md" \
        --resource-path="${CONTENTDIR}" \
        --citeproc \
        --csl="${ASSETSDIR}/citation-style.csl" \
        --from="markdown+tex_math_single_backslash+tex_math_dollars+raw_tex" \
        --to="latex" \
        --output="${BUILDDIR}/output_ereader.pdf" \
        --pdf-engine="xelatex" \
        --include-in-header="layouts/ereader.tex"
}

# Allows to call a function based on arguments passed to the script
# Example: `./build.sh pdf_print`
$*