# DCR Graphs in LaTeX

LaTeX/TikZ package for drawing DCR graphs, by hand or from XML files of the
DCR portal and DCR-js. Version 0.2, work in progress.

## Install

The package is one file: **`dcrgraph.sty`**. Nothing else is needed.

1. Copy `dcrgraph.sty` into the folder of your document.
2. Load it in the preamble: `\usepackage{dcrgraph}`.

**Overleaf:** upload `dcrgraph.sty` (and your XML files) to the project;
for `\includedcrgraph` set *Menu → Settings → Compiler* to LuaLaTeX.

**Local:** e.g. TeX Live; compile with `latexmk -lualatex document.tex`
(or `lualatex` twice).

## Test the installation

```latex
\documentclass{article}
\usepackage{dcrgraph}
\begin{document}
\begin{dcrgraph}
  \activity[role=HR]{Fill out papers}{papers}
  \activity[role=New Hire, right=1.5cm of papers]{Sign Contract}{sign}
  \condition{papers}{sign}
  \response{papers}{sign}
\end{dcrgraph}
\end{document}
```

Import test (LuaLaTeX), with any file from [`xml/`](xml/):

```latex
\includedcrgraph{DCR-JS Graph.xml}
```

## Documentation and examples

| | |
|---|---|
| [`manuals/cookbook/`](manuals/cookbook/) | Cookbook: example graphs built step by step, then imported. Source `dcrgraph-cookbook.tex`, each example a file in `examples/`, XML files in `xml/`. |
| [`manuals/ctan-manual/`](manuals/ctan-manual/) | Manual: all features with examples, reference of all commands, keys and options. Source `dcrgraph-doc.tex`, examples in `examples/`. |
| [`notation-example.tex`](notation-example.tex) | every element of a DCR graph, drawn by hand |
| [`dcrjs-example.tex`](dcrjs-example.tex) | import from a DCR-js file |
| [`xml/`](xml/), [`tests/xml/`](tests/xml/) | sample XML files (DCR portal and DCR-js) |

## Input formats

Recognised from the file:

- DCR Solutions XML: DCR portal export, or the portal export of DCR-js.
- DCR-js XML: the format DCR-js saves in.
