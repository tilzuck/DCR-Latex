-- run-tests.lua -- test suite for dcrgraph (run from the repository root):
--
--   texlua tests/run-tests.lua            run all tests
--   texlua tests/run-tests.lua --update   accept the current converter output
--                                         as the new expected output
--
-- 1. Content: for every tests/xml/NN-*.xml, what the graph says (events, labels,
--    roles, types, marking, nesting, relations) -- without any positions --
--    compared with tests/expected/content/<name>.txt.
--    Layout: where it is drawn (box positions and sizes, nesting areas,
--    relation routes) compared with tests/expected/layout/<name>.txt.
--    A moved box only fails the layout test; a changed relation only the
--    content test. The layout description also lists which values are
--    written as text, and the converter's warnings.
--    Layout variants: tests/xml/<name>.variants, lines "variant: options";
--    each is checked against tests/expected/layout/<name>@<variant>.txt
--    and drawn in the gallery.
-- 2. Gallery: tests/xml-gallery.tex (generated: every test XML via
--    \includedcrgraph, plain, with waypoints, and with all values explicit)
--    must compile with LuaLaTeX.
-- 3. Examples: the example documents must compile (twice) with pdfLaTeX and
--    LuaLaTeX (dcrjs-example.tex: LuaLaTeX only).
-- 4. Manual: manual/dcrgraph-doc.tex must compile with LuaLaTeX (in manual/).
-- Look at tests/out/xml-gallery.pdf to check the pictures themselves.
kpse.set_program_name("luatex")

local update = arg[1] == "--update"
local OUT = "tests/out"
local EXPECTED = "tests/expected"
lfs.mkdir(OUT)
lfs.mkdir(EXPECTED)
lfs.mkdir(EXPECTED .. "/content")
lfs.mkdir(EXPECTED .. "/layout")

-- the converter, loaded from dcrgraph.sty as in dcrgraph-cli.lua
local f = assert(io.open("dcrgraph.sty", "rb"), "run from the repository root")
local text = f:read("*a")
f:close()
local s = assert(text:find("-- DCRGRAPHS " .. "LUA BEGIN", 1, true))
local _, nl = text:sub(1, s):gsub("\n", "")
local dcrgraphs = assert(load(string.rep("\n", nl) .. text:sub(s), "@dcrgraph.sty"))()

local failures, passed = {}, 0
local function ok(name) passed = passed + 1; print("  ok    " .. name) end
local function bad(name, why)
  failures[#failures + 1] = name
  print("  FAIL  " .. name .. (why and ("  (" .. why .. ")") or ""))
end

local function readfile(name)
  local h = io.open(name, "rb")
  if not h then return nil end
  local t = h:read("*a"); h:close()
  return (t:gsub("\r\n", "\n"))
end
local function writefile(name, t)
  local h = assert(io.open(name, "wb")); h:write(t); h:close()
end

-- the test inputs: tests/xml/NN-*.xml (numbered, one topic each), sorted
local XML = "tests/xml"
local xmls = {}
for name in lfs.dir(XML) do
  if name:match("^%d%d%-.*%.xml$") then xmls[#xmls + 1] = name end
end
table.sort(xmls)

-- compare lines with tests/expected/<kind>/<name>.txt; on a difference,
-- report the first differing line
local function check(kind, name, lines)
  local label = kind .. " " .. name
  local got = table.concat(lines, "\n") .. "\n"
  local expfile = EXPECTED .. "/" .. kind .. "/" .. name .. ".txt"
  local expected = readfile(expfile)
  if update or not expected then
    writefile(expfile, got)
    print("  saved " .. label .. (expected and "" or "  (new)"))
  elseif got == expected then
    ok(label)
  else
    local outfile = OUT .. "/" .. kind .. "-" .. name .. ".txt"
    writefile(outfile, got)
    local exp = {}
    for l in expected:gmatch("[^\n]+") do exp[#exp + 1] = l end
    local i = 1
    while lines[i] and lines[i] == exp[i] do i = i + 1 end
    bad(label, "line " .. i .. ": expected `" .. tostring(exp[i]) ..
      "', got `" .. tostring(lines[i]) .. "' -- full output in " .. outfile)
  end
end

-- layout variants of a test file: tests/xml/<name>.variants, one per line
-- "variant-name: options for \includedcrgraph" (# starts a comment)
local function variants_of(x)
  local list = {}
  local t = readfile(XML .. "/" .. x:gsub("%.xml$", ".variants"))
  for line in (t or ""):gmatch("[^\n]+") do
    local vname, o = line:match("^%s*([%w%-]+)%s*:%s*(.-)%s*$")
    if vname and not line:match("^%s*#") then list[#list + 1] = { vname, o } end
  end
  return list
end

-- 1. content and layout ------------------------------------------------
print("Content and layout (" .. #xmls .. " files):")
for _, x in ipairs(xmls) do
  local name = x:gsub("%.xml$", ""):gsub("[^%w%-]", "-")
  local good, graph, opts = pcall(dcrgraphs.read, XML .. "/" .. x, "")
  if not good then
    bad(name, tostring(graph))
  else
    check("content", name, dcrgraphs.describe_content(graph))
    check("layout", name, dcrgraphs.describe_layout(graph, opts))
  end
  -- the layout with options (e.g. single relations explicit)
  for _, v in ipairs(variants_of(x)) do
    local vname = name .. "@" .. v[1]
    local good2, graph2, opts2 = pcall(dcrgraphs.read, XML .. "/" .. x, v[2])
    if not good2 then
      bad("layout " .. vname, tostring(graph2))
    else
      check("layout", vname, dcrgraphs.describe_layout(graph2, opts2))
    end
  end
end

-- 2 and 3. compiling ----------------------------------------------------
local function compile(engine, file, jobname, dir)
  -- dir: compile in this folder (the manual is compiled in manual/)
  local cmd = string.format(
    '%s -interaction=nonstopmode -halt-on-error -output-directory=%s -jobname=%s "%s"',
    engine, dir and ("../" .. OUT) or OUT, jobname, file)
  if dir then cmd = "cd " .. dir .. " && " .. cmd end
  local quiet = (os.type == "windows") and " >NUL 2>&1" or " >/dev/null 2>&1"
  local r
  for _ = 1, 2 do r = os.execute(cmd .. quiet) end   -- twice: parallel relations
  return r == 0 or r == true
end

-- the gallery document: every XML file, plain and with waypoints
local g = { "% generated by tests/run-tests.lua",
  "\\documentclass{article}",
  "\\usepackage[a4paper, margin=1cm, landscape]{geometry}",
  "\\usepackage[T1]{fontenc}", "\\usepackage[scaled=0.92]{helvet}",
  "\\usepackage{dcrgraph}", "\\begin{document}" }
for _, x in ipairs(xmls) do
  local opts = { "", "waypoints", "explicit" }
  for _, v in ipairs(variants_of(x)) do opts[#opts + 1] = v[2] end
  for _, o in ipairs(opts) do
    g[#g + 1] = "\\begin{figure}[p]\\centering"
    g[#g + 1] = "  \\resizebox{\\ifdim\\width>\\linewidth\\linewidth\\else\\width\\fi}{!}{%"
    g[#g + 1] = "    \\includedcrgraph[" .. o .. "]{" .. XML .. "/" .. x .. "}}"
    g[#g + 1] = "  \\caption{\\texttt{" .. x:gsub("_", "\\_") .. "}" ..
      (o ~= "" and " (\\detokenize{" .. o .. "})" or "") .. "}"
    g[#g + 1] = "\\end{figure}"
  end
end
g[#g + 1] = "\\end{document}"
writefile("tests/xml-gallery.tex", table.concat(g, "\n") .. "\n")

print("Gallery:")
if compile("lualatex", "tests/xml-gallery.tex", "xml-gallery") then
  ok("xml-gallery (LuaLaTeX)")
else
  bad("xml-gallery (LuaLaTeX)", "see " .. OUT .. "/xml-gallery.log")
end

print("Examples:")
local examples = {
  { "notation-example.tex", { "pdflatex", "lualatex" } },
  { "logik-eksempel.tex",   { "pdflatex", "lualatex" } },
  { "dcrjs-example.tex",    { "lualatex" } },
}
for _, e in ipairs(examples) do
  for _, engine in ipairs(e[2]) do
    local job = e[1]:gsub("%.tex$", "") .. "-" .. engine
    if compile(engine, e[1], job) then ok(job)
    else bad(job, "see " .. OUT .. "/" .. job .. ".log") end
  end
end

print("Manual:")
if compile("lualatex", "dcrgraph-doc.tex", "dcrgraph-doc", "manual") then
  ok("manual (LuaLaTeX)")
else
  bad("manual (LuaLaTeX)", "see " .. OUT .. "/dcrgraph-doc.log")
end

print(string.format("\n%d passed, %d failed", passed, #failures))
os.exit(#failures == 0 and 0 or 1)
