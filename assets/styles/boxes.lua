-- Pandoc Lua filter for chain-gang-book
-- Substitutes {{author}}, {{author-initials}}, and {{edition}} from metadata.
-- {{edition}} uses paperback-edition when show-print-isbn is true.
-- {{print-isbn-block}} is replaced only when show-print-isbn is true
-- (make paperback passes that flag) so Kindle/EPUB title pages stay ISBN-free.
-- Callouts/boxes can be added here later.

local stringify = pandoc.utils.stringify

local function meta_text(meta, key)
  if not meta[key] then
    return ""
  end
  return stringify(meta[key])
end

local function meta_true(meta, key)
  local v = meta[key]
  if v == nil then
    return false
  end
  if type(v) == "boolean" then
    return v
  end
  local s = stringify(v):lower()
  return s == "true" or s == "yes"
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
  local show_print_isbn = meta_true(doc.meta, "show-print-isbn")
  local isbn = meta_text(doc.meta, "paperback-isbn")
  local imprint = meta_text(doc.meta, "paperback-imprint")
  local edition = meta_text(doc.meta, "edition")
  if show_print_isbn then
    local paperback_edition = meta_text(doc.meta, "paperback-edition")
    if paperback_edition ~= "" then
      edition = paperback_edition
    end
  end

  local replacements = {
    { pattern = "{{author%-initials}}", value = meta_text(doc.meta, "author-initials") },
    { pattern = "{{author}}", value = meta_text(doc.meta, "author") },
    { pattern = "{{edition}}", value = edition },
  }

  return doc:walk({
    Str = function(el)
      el.text = apply_placeholders(el.text, replacements)
      return el
    end,
    Para = function(el)
      if stringify(el):match("{{print%-isbn%-block}}") then
        if not show_print_isbn or isbn == "" then
          return {}
        end
        local blocks = { pandoc.Para({ pandoc.Str("ISBN: " .. isbn) }) }
        if imprint ~= "" then
          table.insert(blocks, pandoc.Para({ pandoc.Str("Imprint: " .. imprint) }))
        end
        return blocks
      end
    end,
  })
end
