---@class LanguageModule
return {
  ensure_installed = { "roslyn" },
  enable = true,
  setup = function()
    -- make sure you also enable roslyn in lazy.lua
  end
}
