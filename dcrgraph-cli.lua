-- dcrgraph-cli.lua -- development tool, not needed to use the package.
-- Runs the converter stored at the end of dcrgraph.sty from the command line:
--   texlua dcrgraph-cli.lua [--waypoints] [--notation=DCRSolutions|Classic|CoopIS2023] [--scale=0.8]
--                           [--marking=false] file.xml
-- prints the LaTeX code.
--
-- Copyright (C) 2026 tilzuck. Part of the dcrgraph package; distributed
-- under the LaTeX Project Public License 1.3c or later (see LICENSE).
kpse.set_program_name("luatex")

local dir = arg[0]:match("^(.*[/\\])") or ""
local path = dir .. "dcrgraph.sty"
local f = io.open(path, "rb") or io.open(kpse.find_file("dcrgraph.sty") or "", "rb")
if not f then io.stderr:write("dcrgraph.sty not found\n"); os.exit(1) end
local text = f:read("*a")
f:close()

local s = text:find("-- DCRGRAPHS " .. "LUA BEGIN", 1, true)
if not s then io.stderr:write("no Lua part in dcrgraph.sty\n"); os.exit(1) end
local _, lines = text:sub(1, s):gsub("\n", "")
local dcrgraphs = assert(load(string.rep("\n", lines) .. text:sub(s), "@" .. path))()
dcrgraphs.main(arg)
