-- Turn fenced divs (::: {.walkthrough title="..."}) into coloured tcolorbox environments in LaTeX/PDF.
local labels = {refresher = "Refresher", example = "Example", why = "Why?",
                deeper = "Optional, going deeper", keyidea = "Key idea", walkthrough = "Walkthrough",
                practice = "In practice", incode = "In code", wrong = "What can go wrong", history = "History", study = "What this study adds"}
function Div(el)
  for cls, label in pairs(labels) do
    if el.classes:includes(cls) and FORMAT:match("latex") then
      local t = el.attributes.title and (label .. ": " .. el.attributes.title) or label
      table.insert(el.content, 1, pandoc.RawBlock("latex", "\\begin{" .. cls .. "box}{" .. t .. "}"))
      table.insert(el.content, pandoc.RawBlock("latex", "\\end{" .. cls .. "box}"))
      return el
    end
  end
end
