return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    auto_trigger = true,
                    keymap = {
                        accept = "<Tab>",
                        accept_word = "<S-Tab>",
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<M-e>",
                    },
                },
                filetypes = {
                    yaml = true,
                    markdown = true,
                    gitcommit = true,
                    gitrebase = true,
                    cvs = true,
                    ["."] = true,
                },
            })
        end,

    },
    {
        "folke/which-key.nvim",
        dependencies = {
            "echasnovski/mini.icons",
            "nvim-tree/nvim-web-devicons",
        },
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 200
        end,
        opts = {},
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    {
        "saghen/blink.compat",
        version = "*",
        opts = {},
    },
    { "micangl/cmp-vimtex" },
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = {
            "L3MON4D3/LuaSnip",
            "saghen/blink.compat",
            "micangl/cmp-vimtex",
        },
        opts = {
            keymap = {
                preset = "none",
                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-e>"] = { "hide" },
                ["<CR>"] = { "accept", "fallback" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<C-k>"] = { "select_prev", "fallback" },
            },
            snippets = { preset = "luasnip" },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                per_filetype = {
                    tex = { "vimtex", "snippets", "buffer" },
                },
                providers = {
                    vimtex = {
                        name = "vimtex",        -- matches cmp-vimtex source name
                        module = "blink.compat.source",
                        transform_items = function(_, items)
                            local seen = {}
                            local deduped = {}
                            for _, item in ipairs(items) do
                                if not seen[item.label] then
                                    seen[item.label] = true
                                    table.insert(deduped, item)
                                end
                            end
                            return deduped
                        end,
                    },
                },
            },
            completion = {
                documentation = {
                    auto_show = true,
                    window = { border = "rounded" },
                },
                menu = {
                    border = "rounded",
                    draw = {
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "source_name" },
                        },
                    },
                },
            },
            appearance = {
                nerd_font_variant = "mono",
            },
        },
    },
}
