return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
        },
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local on_attach = function(client, bufnr)
                vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]]
            end
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local lspconfig = require("lspconfig")
            require('mason').setup()
            local mason_lspconfig = require 'mason-lspconfig'
            mason_lspconfig.setup {
                ensure_installed = {
                    "pyright",
                    "clangd",
                    "lua_ls",
                    "ruff",
                    }
            }
            lspconfig.clangd.setup({
                capabilities = capabilities,
            })
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
            })
            lspconfig.html.setup({
                capabilities = capabilities,
            })
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })
            lspconfig.pyright.setup({
                capabilities = capabilities,
            })
            lspconfig.ruff.setup({
                on_attach = on_attach,
                init_options = {
                    settings = {
                        -- Any extra CLI arguments for `ruff` go here.
                        args = {},
                    }
                }
            })

            -- Diagnostics
            vim.keymap.set("n", "<leader>cf", vim.diagnostic.open_float, { desc = "Open diagnostics float" })
            vim.keymap.set("n", "<leader>cn", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
            vim.keymap.set("n", "<leader>cN", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
            vim.keymap.set("n", "<leader>cl", vim.diagnostic.setloclist, { desc = "Show diagnstics list" })

            vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover information" })
            vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
            vim.keymap.set("n", "<leader>cl", vim.lsp.buf.references, { desc = "List all references" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Trigger code actions" })
            vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
        end,
    },
}
