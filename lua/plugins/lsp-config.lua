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
            vim.lsp.enable('pyright')
            vim.lsp.enable('clangd')
            vim.lsp.enable('lua_ls')
            vim.lsp.enable('ruff')


            -- Diagnostics
            vim.keymap.set("n", "<leader>cf", vim.diagnostic.open_float, { desc = "Open diagnostics float" })
            vim.keymap.set("n", "<leader>cn", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
            vim.keymap.set("n", "<leader>cN", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
            vim.keymap.set("n", "<leader>cl", vim.diagnostic.setloclist, { desc = "Show diagnstics list" })

            vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
            vim.keymap.set("n", "<leader>cl", vim.lsp.buf.references, { desc = "List all references" })
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Trigger code actions" })
            vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
        end,
    },
}
