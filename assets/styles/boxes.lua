-- Pandoc Lua filter for chain-gang-book
-- Substitutes {{author}}, {{author-initials}}, and {{edition}} from metadata (common.yml).
-- Callouts/boxes can be added here later.

local stringify = pandoc.utils.stringify

local function meta_text(meta, key)
  if not meta[key] then
    return ""
  end
  return stringify(meta[key])
end

-- Longer placeholders first so {{author}} does not run before {{author-initials}}.
local function apply_placeholders(text, replacements)
  for _, r in ipairs(replacements) do
    if r.value ~= "" then
      text = text:gsub(r.pattern, r.value)
    end
  end
  return text
end

function Pandoc(doc)
  local replacements = {
    { pattern = "{{author%-initials}}", value = meta_text(doc.meta, "author-initials") },
    { pattern = "{{author}}", value = meta_text(doc.meta, "author") },
    { pattern = "{{edition}}", value = meta_text(doc.meta, "edition") },
  }

  return doc:walk({
    Str = function(el)
      el.text = apply_placeholders(el.text, replacements)
      return el
    end
  })
end
