-- Minimal no-op Lua filter placeholder for Pandoc

-- This filter currently passes content through unchanged.
-- You can extend it later to transform callouts/boxes.

return {
  {
    Str = function(el)
      return el -- no modification
    end
  }
}


