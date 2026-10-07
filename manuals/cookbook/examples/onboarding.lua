-- onboarding.lua -- generates onboarding-2.tex .. onboarding-6.tex, the steps
-- of the first cookbook recipe (onboarding-1.tex is written by hand).
-- each entry: { first step it appears in, line } or
--             { first step, line, step in which it changes, changed line }
-- One command per line: \NEW (the marker of new lines) must start a line,
-- and must not stand between a command and its arguments.
local L = {
  {2, [[  % Pre-Start]]},
  {2, [[  \activity[role=HR Manager]{Find Computer and Keycard for new Hire}{computer}]]},
  {2, [[  \activity[role=HR Manager, right=0.8cm of computer]{Fill out contractual papers}{papers}]],
   6, [[  \activity[role=HR Manager, right=0.8cm of computer, pending]{Fill out contractual papers}{papers}]]},
  {2, [[  \activity[role=HR Manager, below=0.8cm of computer]{Find a trainer for new hire}{trainer}]]},
  {2, [[  \activity[role=HR Manager, below=0.8cm of papers]{Enter new hires information}{enter}]]},
  {2, [[  \activity[role=New Hire, right=1.6cm of papers]{Sign Contract}{sign}]]},
  {2, [[  \activity[role=Database, below=2.2cm of enter]{Update Database}{database}]],
   6, [[  \activity[role=Database, below=2.2cm of enter, excluded]{Update Database}{database}]]},
  {2, [[  % First day of new Hire]]},
  {2, [[  \activity[role=HR Manager, right=3cm of sign]{Introduce to Colleagues}{colleagues}]]},
  {2, [[  \activity[role=HR Manager, right=0.8cm of colleagues]{Receive Computer and Keycard}{keycard}]]},
  {2, [[  \activity[role=Trainer, below=0.8cm of keycard]{Introduce new hire to IT systems and work process}{it}]]},
  {2, [[  \activity[role=New Hire, right=0.8cm of keycard]{Begin Work}{begin}]]},
  {2, [[  % 3-week mark and 6 month review]]},
  {2, [[  \activity[role=HR Manager, below=1.8cm of it]{Performance interview with new Hire}{interview}]]},
  {2, [[  \activity[role=HR Manager, left=0.8cm of interview]{Update System with performance data}{perfdata}]]},
  {2, [[  \activity[role=HR Manager, below=1.8cm of interview]{Review of the 6 month period with new hire}{review}]]},
  {2, [[  \activity[role=HR Manager, left=0.8cm of review]{Update Database with Review Data}{reviewdata}]]},
  {2, [[  \activity[role=HR Manager, right=1.4cm of review]{Finish Onboarding}{finish}]],
   6, [[  \activity[role=HR Manager, right=1.4cm of review, pending]{Finish Onboarding}{finish}]]},
  {3, [[  % nestings: after their events, inner ones first]]},
  {3, [[  \nesting{Pre-Start}{prestart}{computer, papers, trainer, enter}]]},
  {3, [[  \nesting{First day of new Hire}{firstday}{colleagues, keycard, it, begin}]]},
  {3, [[  \nesting{3-week mark}{threeweeks}{perfdata, interview}]]},
  {3, [[  \nesting{6 month review}{sixmonths}{reviewdata, review}]]},
  {3, [[  \nesting{Responsibilities for new Hire}{responsibilities}{firstday, threeweeks, sixmonths, finish}]]},
  {4, [[  % conditions: \condition{from}{to}]]},
  {4, [[  \precondition{papers}{sign}]]},
  {4, [[  \condition{prestart}{firstday}]]},
  {4, [[  \condition{sign}{firstday}]]},
  {4, [[  \condition{keycard}{begin}]]},
  {4, [[  \condition{it}{begin}]]},
  {4, [[  \condition{firstday}{threeweeks}]]},
  {4, [[  \condition{threeweeks}{sixmonths}]]},
  {4, [[  \condition{sixmonths}{finish}]]},
  {5, [[  % responses]]},
  {5, [[  \response{begin}{interview}]]},
  {5, [[  \response{interview}{review}]]},
  {5, [[  % includes and responses]]},
  {5, [[  \include{enter}{database}  \response{enter}{database}]]},
  {5, [[  \include{perfdata}{database}  \response{perfdata}{database}]]},
  {5, [[  \include{reviewdata}{database}  \response{reviewdata}{database}]]},
  {5, [[  % excludes (a relation from an event to itself, too)]]},
  {5, [[  \exclude{database}{database}]]},
  {5, [[  \exclude{keycard}{keycard}]]},
  {5, [[  \exclude{sign}{papers}]]},
  {5, [[  \exclude{firstday}{sign}]]},
  {5, [[  \exclude{firstday}{prestart}]]},
  {5, [[  \exclude{threeweeks}{firstday}]]},
  {6, [[  % milestone]]},
  {6, [[  \milestone{database}{responsibilities}]]},
}
-- run from manuals/cookbook/examples: texlua onboarding.lua
local dir = ""
for step = 2, 6 do
  local out = { "\\begin{dcrgraph}" }
  for _, e in ipairs(L) do
    if e[1] <= step then
      local line, new = e[2], e[1] == step
      if e[3] and e[3] <= step then line = e[4]; new = new or e[3] == step end
      out[#out + 1] = new and ("\\NEW" .. line) or line
    end
  end
  out[#out + 1] = "\\end{dcrgraph}"
  local f = assert(io.open(dir .. "onboarding-" .. step .. ".tex", "wb"))
  f:write(table.concat(out, "\n") .. "\n")
  f:close()
end
print("ok")
