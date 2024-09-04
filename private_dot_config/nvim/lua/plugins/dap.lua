return {
    "rcarriga/nvim-dap-ui",
    dependencies = {
        "mfussenegger/nvim-dap",
        "mxsdev/nvim-dap-vscode-js",
        "nvim-neotest/nvim-nio",
    },
    enabled = not vim.g.vscode,
    config = function()
        local dap, dapui = require("dap"), require("dapui")

        dapui.setup()

        -- setup adapters
        require('dap-vscode-js').setup({
            node_path = 'node',
            debugger_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter',
            debugger_cmd = { 'js-debug-adapter' },
            adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
        })

        function Debug_continue()
            if vim.fn.filereadable(".vscode/launch.json") == 1 then
                require("dap.ext.vscode").load_launchjs(nil, {
                    ["codelldb"] = { "c", "cpp", "rust" },
                })
            end
            require("dap").continue()
        end

        vim.api.nvim_set_keymap('n', '<F5>', '<Cmd>lua Debug_continue()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<F9>', '<Cmd>lua require"dap".toggle_breakpoint()<CR>',
            { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<F10>', '<Cmd>lua require"dap".step_over()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<F11>', '<Cmd>lua require"dap".step_into()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<F12>', '<Cmd>lua require"dap".step_out()<CR>', { noremap = true, silent = true })
        vim.api.nvim_set_keymap('n', '<Leader>tf', '<Cmd>lua require("dapui").float_element() <CR>',
            { noremap = true, silent = true })

        vim.api.nvim_set_keymap('n', '<Leader>tt', '<Cmd>lua require("dapui").toggle() <CR>',
            { noremap = true, silent = true })

        dap.adapters.codelldb = {
            type = "server",
            -- host = '127.0.0.1',
            port = "${port}",
            executable = {
                command = vim.fn.stdpath('data') .. '/mason/packages/codelldb/codelldb',
                args = { "--port", "${port}" },
            },
        }

        local exts = {
            'javascript',
            'typescript',
            'javascriptreact',
            'typescriptreact',
            -- using pwa-chrome
            'vue',
            'svelte',
        }

        dap.adapters.godot = {
            type = "server",
            host = '127.0.0.1',
            port = 6006,
        }

        dap.configurations.gdscript = {
            {
                type = "godot",
                request = "launch",
                name = "Launch scene",
                project = "${workspaceFolder}",
                launch_scene = true,
            },
        }

        for i, ext in ipairs(exts) do
            dap.configurations[ext] = {
                {
                    type = 'pwa-node',
                    request = 'launch',
                    name = 'Launch Current File (pwa-node)',
                    cwd = vim.fn.getcwd(),
                    args = { '${file}' },
                    sourceMaps = true,
                    protocol = 'inspector',
                },
                {
                    type = 'pwa-node',
                    request = 'launch',
                    name = 'Launch Current File (pwa-node with ts-node)',
                    cwd = vim.fn.getcwd(),
                    runtimeArgs = { '--loader', 'ts-node/esm' },
                    runtimeExecutable = 'node',
                    args = { '${file}' },
                    sourceMaps = true,
                    protocol = 'inspector',
                    skipFiles = { '<node_internals>/**', 'node_modules/**' },
                    resolveSourceMapLocations = {
                        "${workspaceFolder}/**",
                        "!**/node_modules/**",
                    },
                },
                {
                    type = 'pwa-node',
                    request = 'launch',
                    name = 'Launch Current File (pwa-node with deno)',
                    cwd = vim.fn.getcwd(),
                    runtimeArgs = { 'run', '--inspect-brk', '--allow-all', '${file}' },
                    runtimeExecutable = 'deno',
                    attachSimplePort = 9229,
                },
                {
                    type = 'pwa-node',
                    request = 'launch',
                    name = 'Launch Test Current File (pwa-node with jest)',
                    cwd = vim.fn.getcwd(),
                    runtimeArgs = { '${workspaceFolder}/node_modules/.bin/jest' },
                    runtimeExecutable = 'node',
                    args = { '${file}', '--coverage', 'false' },
                    rootPath = '${workspaceFolder}',
                    sourceMaps = true,
                    console = 'integratedTerminal',
                    internalConsoleOptions = 'neverOpen',
                    skipFiles = { '<node_internals>/**', 'node_modules/**' },
                },
                {
                    type = 'pwa-node',
                    request = 'launch',
                    name = 'Launch Test Current File (pwa-node with vitest)',
                    cwd = vim.fn.getcwd(),
                    program = '${workspaceFolder}/node_modules/vitest/vitest.mjs',
                    args = { '--inspect-brk', '--threads', 'false', 'run', '${file}' },
                    autoAttachChildProcesses = true,
                    smartStep = true,
                    console = 'integratedTerminal',
                    skipFiles = { '<node_internals>/**', 'node_modules/**' },
                },
                {
                    type = 'pwa-node',
                    request = 'launch',
                    name = 'Launch Test Current File (pwa-node with deno)',
                    cwd = vim.fn.getcwd(),
                    runtimeArgs = { 'test', '--inspect-brk', '--allow-all', '${file}' },
                    runtimeExecutable = 'deno',
                    attachSimplePort = 9229,
                },
                {
                    type = 'pwa-chrome',
                    request = 'attach',
                    name = 'Attach Program (pwa-chrome = { port: 9222 })',
                    program = '${file}',
                    cwd = vim.fn.getcwd(),
                    sourceMaps = true,
                    port = 9222,
                    webRoot = '${workspaceFolder}',
                },
                {
                    type = 'pwa-node',
                    request = 'attach',
                    name = 'Attach Program (pwa-node)',
                    cwd = vim.fn.getcwd(),
                    processId = require('dap.utils').pick_process,
                    skipFiles = { '<node_internals>/**' },
                },
            }
        end
        require("overseer").enable_dap()
    end
}
