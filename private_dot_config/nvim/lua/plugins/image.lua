return {
    "3rd/image.nvim",
    build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    opts = {
        backend = "kitty",
        processor = "magick_cli",
        integrations = {
            markdown = {
                enabled = true,
                clear_in_insert_mode = false,
                download_remote_images = false,
                only_render_image_at_cursor = true,
                floating_windows = true,               -- if true, images will be rendered in floating markdown windows
                filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
            },
            neorg = {
                enabled = false,
                filetypes = { "norg" },
            },
            typst = {
                enabled = false,
            },
            html = {
                enabled = false,
            },
            css = {
                enabled = false,
            },
        },
        max_width = 1000,
        max_height = 1000,
    }
}
