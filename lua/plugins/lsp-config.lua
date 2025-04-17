return {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "jose-elias-alvarez/null-ls.nvim",
        "nvim-lua/plenary.nvim",
        "ray-x/lsp_signature.nvim",
    },
    config = function()

        local servers = {
            "clangd",
            "lua_ls",
            "ruff",
            "jedi_language_server"
        }
        local lspconfig = require("lspconfig")
        require('mason').setup()
        local mason_lspconfig = require 'mason-lspconfig'
        mason_lspconfig.setup {
            ensure_installed = servers,
        }

        local function on_attach(client, bufnr)
            -- Set up buffer-local keymaps (vim.api.nvim_buf_set_keymap()), etc.
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
            vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "single" })<CR>', opts)
            vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "single" })<CR>', opts)
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
        end

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "single",
        })

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
            border = "single",
        })

        vim.diagnostic.config({
            virtual_text = false,
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
        local capabilities = require'cmp_nvim_lsp'.default_capabilities(vim.lsp.protocol.make_client_capabilities())
        local lspconfig = require('lspconfig')
        local util = require('lspconfig/util')

        for _, server in ipairs(servers) do
            server = vim.tbl_get(lspconfig, server)
            server.setup{
                on_attach = on_attach,
                capabilities = capabilities
            }
        end

        require('mason-lspconfig').setup_handlers({
            function(server)
                lspconfig[server].setup({
                    on_attach = on_attach,
                    capabilities = capabilities
                })
            end,
        })
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
