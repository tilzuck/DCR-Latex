# DCR Graphs in LaTeX

LaTeX/TikZ package for drawing DCR graphs, by hand or from XML files exported from
[DCR Solutions](https://dcrsolutions.net/) and [DCR-js](https://hugoalopez-dtu.github.io/dcr-js/).

## Usage

The package is one file: **`dcrgraph.sty`**. Nothing else is needed.

1. Copy `dcrgraph.sty` into the folder of your document.
2. Load it in the preamble: `\usepackage{dcrgraph}`.

**Overleaf:** upload `dcrgraph.sty` (and your XML files) to the project;
for `\includedcrgraph` set *Menu → Settings → Compiler* to LuaLaTeX.

You can quickly see if it works by copying the following code:

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
<img width="273" height="133" alt="image" src="https://github.com/user-attachments/assets/2dcfe85b-80c0-4ed3-8891-7e06a7526f51" />

Import test (LuaLaTeX), with any file from [`xml/`](xml/):

```latex
\includedcrgraph{xml/DCR-JS Graph.xml}
```
<img width="300" alt="image" src="https://github.com/user-attachments/assets/179b26bc-ab06-49c9-a8b1-ed0e91dddcba" />

## Features

- **Three notations** — dcr-solutions (DCR portal look), classic, coopis23;
  set per graph (`notation=`), for the whole document (`\dcrset{notation=...}`),
  or as a package option.
- **Events** — `\activity`, with role(s), choreography receivers, subtitles,
  marking (pending, executed, included/excluded) and event types (data,
  computation, DMN, global, access control, form, subgraph)
- **Relations** — condition, pre-condition,
  response, include, exclude, logical include, milestone, no-response,
  update, spawn. Guards (shield or text), delays/deadlines, custom paths
  (`via=`, `bend`, `bundle=`).
- **Collections** — nestings, subprocesses, forms, subgraphs.
- **Choreographies** — sender (`role=`) and receiver bands on the same event.
- **Inline symbols** — all ten relations as `\dcrcondition`, `\dcrresponse`,
  etc., usable in running text or math, with guards and times.
- **Customisation** — fonts, sizes (boxes, headers, markers, lines,
  icons) and colours for every element, graph-wide or document-wide via
  `\dcrset`.
- **Import from XML** — `\includedcrgraph` reads DCR Solutions
  exports and DCR-js files. Options for notation, scaling, waypoint routing,
  explicit values, and exporting the generated code to edit by hand;
  `\adjustactivity`/`\adjustrelation` to tweak an imported graph afterwards.


## Documentation and examples

| | |
|---|---|
| [`manuals/cookbook/`](manuals/cookbook/) | Cookbook: example graphs built step by step, then imported. Source `dcrgraph-cookbook.tex`, each example a file in `examples/`, XML files in `xml/`. |
| [`manuals/ctan-manual/`](manuals/ctan-manual/) | Manual: all features with examples, reference of all commands, keys and options. **[Read the PDF](manuals/ctan-manual/dcrgraph-doc.pdf)**. Source `dcrgraph-doc.tex`, examples in `examples/`. |
| [`notation-example.tex`](notation-example.tex) | every element of a DCR graph, drawn by hand |
| [`dcrjs-example.tex`](dcrjs-example.tex) | import from a DCR-js file |
| [`xml/`](xml/), [`tests/xml/`](tests/xml/) | sample XML files (DCR portal and DCR-js) |
