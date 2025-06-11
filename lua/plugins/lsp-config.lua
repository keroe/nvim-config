return {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
        "neovim/nvim-lspconfig",
        "williamboman/mason.nvim",
        "jose-elias-alvarez/null-ls.nvim",
        "ray-x/lsp_signature.nvim",
    },
    config = function()
        local servers = {
            "clangd",
            "lua_ls",
            "ruff",
            "jedi_language_server"
        }
        require('mason').setup()
        local mason_lspconfig = require 'mason-lspconfig'
        mason_lspconfig.setup {
            ensure_installed = servers,
            automatic_enable = false
        }

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('my.lsp', {}),
            callback = function(args)
                local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
                local bufnr = args.buf
                local opts = { noremap = true, silent = true }
                vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "<C-k>", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
                vim.api.nvim_buf_set_keymap(bufnr, "v", "<C-k>", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
                -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>s", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
                -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
                -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "[d",
                    '<cmd>lua vim.diagnostic.goto_prev({ border = "single" })<CR>', opts)
                vim.api.nvim_buf_set_keymap(bufnr, "n", "]d",
                    '<cmd>lua vim.diagnostic.goto_next({ border = "single" })<CR>', opts)
                -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
                vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]

                require 'lsp_signature'.on_attach({
                    bind = true,
                    floating_window_above_cur_line = true,
                    max_width = 120,
                    hi_parameter = 'Cursor',
                    hint_enable = false,
                    handler_opts = {
                        border = 'single'
                    }
                }, bufnr)
                if client:supports_method('textDocument/implementation') then
                    -- Create a keymap for vim.lsp.buf.implementation ...
                end
                -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
                if client:supports_method('textDocument/completion') then
                    -- Optional: trigger autocompletion on EVERY keypress. May be slow!
                    -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
                    -- client.server_capabilities.completionProvider.triggerCharacters = chars
                    vim.lsp.completion.enable(false, client.id, args.buf, { autotrigger = true })
                end
                -- Auto-format ("lint") on save.
                -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
                if not client:supports_method('textDocument/willSaveWaitUntil')
                    and client:supports_method('textDocument/formatting') then
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                        buffer = args.buf,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                        end,
                    })
                end
                if client:supports_method('textDocument/hover') then
                    vim.api.nvim_create_autocmd('CursorHold', {
                        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                        buffer = args.buf,
                        callback = function()
                            require('hover').hover()
                        end,
                    })
                end
                if client:supports_method('textDocument/signatureHelp') then
                    vim.api.nvim_create_autocmd('CursorHold', {
                        group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                        buffer = args.buf,
                        callback = function()
                            vim.lsp.buf.signature_help()
                        end,
                    })
                end
            end,
        })

        vim.diagnostic.config({
            virtual_text = true,
            signs = true, --disable signs here to customly display them later
            update_in_insert = true,
            underline = true,
            severity_sort = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "single",
                source = "always",
                header = "Diagnostics:",
                -- prefix = function (d, i, win_total)
                --     local highlight = 'DiagnosticSignHint'
                --     if d.severity == 1 then
                --         highlight = 'DiagnosticSignError'
                --     elseif d.severity == 2 then
                --         highlight = 'DiagnosticSignWarn'
                --     elseif d.severity == 3 then
                --         highlight = 'DiagnosticSignInfo'
                --     end
                --     return i .. '. ', highlight
                -- end,
            }
        })
        vim.lsp.enable(servers)

        local null_ls = require 'null-ls'
        local sources = {
            null_ls.builtins.diagnostics.phpcs.with({
                extra_args = { '--standard=psr12' },
                diagnostics_format = "#{m}"
            })
        }

        require 'null-ls'.setup({ sources = sources })
    end,
}
