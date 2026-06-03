local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local spec = {
    { import = 'plugins' },
    -- { import = "plugins.optional" } -- enable all optional plugins
    { import = "plugins.optional.roslyn" },
    -- { import = "plugins.optional.rest-kulala" },
    -- { import = "plugins.optional.typescript" },

}




require("lazy").setup({
    spec = spec,
    checker = { enable = true },
    rocks = {
        enabled = false,
    },
})
