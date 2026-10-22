# dcrgraph manual: feature checklist

Every feature of the package that the CTAN manual should show in an example
(or at least explain). Tick an item once an example in the manual covers it;
write the example's file name behind it, e.g. `– examples/onboarding-2.tex`.

Planned structure: **1. Examples** (graphs built step by step) → **2. Importing
XML** → **3. Reference** (every command, key and colour, complete).

---

## 1. Loading and notations

- [ ] `\usepackage{dcrgraph}`: default notation dcr-solutions (DCR portal look)
- [ ] Package options: `[dcr-solutions]`, `[classic]`, `[coopis23]`
- [ ] Notation of one graph: `\begin{dcrgraph}[notation=classic]` (settings need no `dcr/` prefix; it still works)
- [ ] Notation of the rest of the document: `\dcrset{notation=…}`
- [ ] The same graph in all three notations (side by side)
- [ ] classic / coopis23: a pre-condition is drawn as condition + milestone
- [ ] classic / coopis23: a logical include is drawn as include (guard) + exclude (negated guard, `\dcrnotguard`)
- [ ] coopis23: update, no-response and spawn get their dcr-solutions symbol in the circle
- [ ] classic / coopis23: no shields or clocks, values always as text

## 2. Activities (events)

- [ ] `\activity[options]{label}{id}`
- [ ] Placing with TikZ: `right=2cm of a`, `below=…`, `at={(x,y)}`
- [ ] Size: `minimum width=`, `minimum height=` (default 2.6 cm × 2.8 cm)
- [ ] Long labels: the box grows taller automatically, label wraps
- [ ] `role=…`, several roles `role={A, B}`
- [ ] `receiver=…` (choreographies): grey band at the bottom, box one header taller; several `receiver={A,B}`
- [ ] `subtitle=…`: grey italic text below the label, cut off with "…"
- [ ] Any other TikZ option on the box (passed through)

### Marking
- [ ] `pending` (blue "!")
- [ ] `executed` (green tick)
- [ ] `pending` + `executed` together
- [ ] `excluded` (dashed outline), `included` (default)

### Event types
- [ ] `data` (page icon top right)
- [ ] `computation` (blue "=")
- [ ] `dmn` (decision table grid)
- [ ] `global` (two squares bottom left)
- [ ] `access` ("#" top right)
- [ ] `form` (event with a form, "f" bottom right)
- [ ] `subgraph` (template event, target of spawns: dotted, no header, "|||" and "g")
- [ ] Several types on one event (icons placed side by side)

### Colours of one activity
- [ ] `bgcolor=`, `bordercolor=`, `textcolor=`

## 3. Relations

Commands, all `\relation[options]{from}{to}`:

- [ ] `\condition`
- [ ] `\response`
- [ ] `\include`
- [ ] `\exclude`
- [ ] `\milestone`
- [ ] `\update` (value relation)
- [ ] `\noresponse`
- [ ] `\precondition`
- [ ] `\spawn`
- [ ] `\logicalinclude`
- [ ] Where the marker sits: at the target for condition, pre-condition and milestone; at the source for all others
- [ ] All relations at a glance (overview figure)

### Guards and times
- [ ] `guard={expression}` on any relation
- [ ] `guard` without expression (shield only)
- [ ] `delay=…`: only conditions (and pre-conditions)
- [ ] `deadline=…`: only responses
- [ ] Error for a wrong time key (`delay=` on a response, `deadline=` on anything but a response, a time on other relations) — mention in text
- [ ] dcr-solutions: shield for guards, clock marker for times (default)
- [ ] Graph settings `guards=shield|explicit|both|none`
- [ ] Graph settings `delays=marker|explicit|none`, `deadlines=marker|explicit|none`
- [ ] `explicit` (all values as text, whole graph)
- [ ] `explicit`, `explicit={guard,delay,deadline}` on one relation
- [ ] Guard format: `\dcrguardformat`; negated guard: `\dcrnotguard`

### Placing the lines
- [ ] Straight line between the boxes (default)
- [ ] Parallel relations between the same two events are spread side by side
- [ ] Start/end at an anchor: `\condition{a.south}{b.north}`
- [ ] `via={(x1,y1),(x2,y2)}`: routed line with right angles (points on the outline start/end it there; `(a.east |- 0,-5)` style coordinates)
- [ ] TikZ options: `bend left=20`, `out=…, in=…`
- [ ] `bundle=node:name`: spread relations with a common end that would overlap
- [ ] Relations to and from collections (nesting, subprocess)

### Self-relations
- [ ] `\exclude{a}{a}` etc.: dcr-solutions marker on the top edge; several side by side
- [ ] `selfpos=` (dcr-solutions: position of the marker on the top edge)
- [ ] classic / coopis23: a loop at a corner, corners in turn
- [ ] `corner=north west|north east|south east|south west` (classic / coopis23); without it the next free corner
- [x] Guard and time of a self-relation as text (next to the loop / above the marker) – examples/self-values.tex
- [x] Text size of guards and times: styles `guard label`, `delay label` (`guard label/.append style={font=...}`) – examples/self-values.tex

## 4. Collections

All `\command[options]{label}{id}{child1, child2, …}`, written after their children:

- [ ] `\nesting` ("n")
- [ ] `\subprocess` ("s")
- [ ] Multi-instance subprocess = a subprocess spawned several times with `\spawn` (no notation of its own!)
- [ ] `\form` (header, "f")
- [ ] `\subgraph` (template with its own events: dotted, "|||", "g"; target of `\spawn`)
- [ ] Nested collections (collection inside a collection, several levels)
- [ ] `role=` on a collection (header like an activity)
- [ ] Marking on a collection (`pending`, `executed`, `excluded`)
- [ ] `area={(x1,y1)(x2,y2)}`: exact box instead of fitting the children
- [ ] `subtitle=` on a collection
- [ ] Colours: `bgcolor=`, `bordercolor=`, `textcolor=`

## 5. Choreographies

- [ ] Sender in the header (`role=`), receiver in the bottom band (`receiver=`)
- [ ] A complete small choreography (e.g. Buyer/Seller)
- [ ] Imported from the portal (read roles = receivers)

## 6. Inline symbols (relations in running text)

- [ ] All ten commands: `\dcrcondition`, `\dcrresponse`, `\dcrinclude`, `\dcrexclude`, `\dcrmilestone`, `\dcrupdate`, `\dcrnoresponse`, `\dcrprecondition`, `\dcrspawn`, `\dcrlogicalinclude`
- [ ] In math (`$A \dcrcondition B$`) and in text (`A \dcrcondition B`)
- [ ] Spaced like `\rightarrow` / `\xrightarrow`; no space added before punctuation
- [ ] `guard=` (above the line, line grows to fit)
- [ ] `delay=` / `deadline=` (below the line)
- [ ] `notation=` per symbol; default = notation of the document
- [ ] classic / coopis23: stacked pre-condition and logical include (negated guard below)
- [ ] `length=` (minimum line length)
- [ ] Sub- and superscripts shrink like `\rightarrow`
- [ ] Follow `\Large`, `\footnotesize`, …
- [ ] Settings: `dcr/inline` style, `dcr/inline label distance`
- [ ] Tip: `\usepackage[T1]{fontenc}` for `<` and `>` in guards

## 7. Customisation (`\dcrset{…}`, colours)

### Document-wide settings
- [ ] `font=` (default sans serif), `subtitle font=`
- [ ] `bgcolor=`, `nesting bgcolor=` (default backgrounds)
- [ ] `header height=`
- [ ] `border width=`, `relation width=`
- [ ] `marker size=`, `condition marker size=`, `response marker size=`, `marker gap=`
- [ ] `classic marker size=`, `classic arrow` (extra style for classic arrows)
- [ ] `coopis bend=`
- [ ] `data size=`, `dmn size=`, `tick size=`, `guard size=`
- [ ] `parallel distance=`
- [ ] Overriding a style with `\tikzset{dcr/… /.append style=…}`

### Colours (`\colorlet{…}{…}`)
- [ ] Relations: `dcr condition`, `dcr precondition`, `dcr response`, `dcr include`, `dcr exclude`, `dcr logical include`, `dcr milestone`, `dcr noresponse`, `dcr update`, `dcr spawn`
- [ ] Boxes: `dcr activity`, `dcr nesting`, `dcr border`, `dcr text`, `dcr receiver`
- [ ] Markers and icons: `dcr executed`, `dcr delay`, `dcr subtitle`, `dcr icon`, `dcr dmn`, `dcr subgraph`, `dcr subgraph collection`
- [ ] Colours affect graphs and inline symbols alike

## 8. Importing XML (LuaLaTeX)

- [ ] `\includedcrgraph{file.xml}`; needs LuaLaTeX (Overleaf: set the compiler)
- [ ] Formats recognised automatically: DCR Solutions XML (portal export, also DCR-js's portal export), DCR-js XML; `format=auto|dcrsolutions|dcrjs`
- [ ] Looks like the portal / DCR-js: positions, sizes, colours, roles
- [ ] `notation=`, `scale=`, `marking=false`, `waypoints` (routes from the file)
- [ ] `guards=`, `delays=`, `deadlines=`, `explicit` for the whole graph
- [ ] `guards={A4 response A6, A6 A7}` etc.: values of single relations as text ("source type target" or "source target"; `value` = update)
- [ ] Warnings: unknown relation names, relation without such a value, unsupported elements
- [ ] `export=file.tex`: write the generated code (to take it over and edit by hand)
- [ ] `\begin{dcrgraphfile}[options]{file}` … `\end{dcrgraphfile}`
- [ ] `\adjustactivity{id}{shift={(x,y)}, xshift=, yshift=, other activity options}`
- [ ] `\adjustrelation{relation}{from=anchor, to=anchor, other relation options}`
- [ ] What is read: events, labels, roles, receivers (portal read roles), event types, marking, colours, nestings, subprocesses, forms, subgraphs, all relations with guards and times
- [ ] What is not reproduced (portal routing etc.) — compatibility appendix
- [ ] The same graph drawn by hand and imported (cookbook idea)

## 9. Tools (optional, for the appendix)

- [ ] `texlua dcrgraph-cli.lua [--notation=…] [--waypoints] [--scale=…] [--marking=false] file.xml`: print the generated code
- [ ] Test suite `texlua tests/run-tests.lua` (for contributors)

---

## Rules to keep correct in every example

- Only a **condition** (and a pre-condition) has a **delay**; only a **response** has a **deadline**; no other relation has a time.
- **Multi-instance** = a subprocess spawned several times through `\spawn`; there is no multi-instance notation.
- Notation names are exactly `dcr-solutions`, `classic`, `coopis23`.
