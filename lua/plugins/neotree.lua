return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            default_component_configs = {
                window = {
                    position = "left",
                    width = 40,
                    mapping_options = {
                        noremap = true,
                        nowait = true,
                    },
                    nesting_rules = {},
                    filesystem = {
                        filtered_items = {
                            visible = false, -- when true, they will just be displayed differently than normal items
                            hide_dotfiles = true,
                            hide_gitignored = true,
                            hide_hidden = true, -- only works on Windows for hidden files/directories
                            hide_by_name = {
                                --"node_modules",
                                --"devel/",
                                --"logs/",
                                --"build/"
                            },
                            hide_by_pattern = { -- uses glob style patterns
                                --"*.meta",
                                --"*/src/*/tsconfig.json",
                            },
                            always_show = { -- remains visible even if other settings would normally hide it
                                --".gitignored",
                            },
                            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
                                --".DS_Store",
                                --"thumbs.db"
                            },
                            never_show_by_pattern = { -- uses glob style patterns
                                --".null-ls_*",
                            },
                        },
                        follow_current_file = {
                            enabled = false, -- This will find and focus the file in the active buffer every time
                            --               -- the current file is changed while the tree is open.
                            leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
                        },
                        group_empty_dirs = false, -- when true, empty folders will be grouped together
                        hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
                        -- in whatever position is specified in window.position
                        -- "open_current",  -- netrw disabled, opening a directory opens within the
                        -- window like netrw would, regardless of window.position
                        -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
                        use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
                        -- instead of relying on nvim autocmd events.
                        window = {
                            mappings = {
                                ["<bs>"] = "navigate_up",
                                ["."] = "set_root",
                                ["H"] = "toggle_hidden",
                                ["/"] = "fuzzy_finder",
                                ["D"] = "fuzzy_finder_directory",
                                ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
                                -- ["D"] = "fuzzy_sorter_directory",
                                ["f"] = "filter_on_submit",
                                ["<c-x>"] = "clear_filter",
                                ["[g"] = "prev_git_modified",
                                ["]g"] = "next_git_modified",
                                ["o"] = { "show_help", nowait=false, config = { title = "Order by", prefix_key = "o" }},
                                ["oc"] = { "order_by_created", nowait = false },
                                ["od"] = { "order_by_diagnostics", nowait = false },
                                ["og"] = { "order_by_git_status", nowait = false },
                                ["om"] = { "order_by_modified", nowait = false },
                                ["on"] = { "order_by_name", nowait = false },
                                ["os"] = { "order_by_size", nowait = false },
                                ["ot"] = { "order_by_type", nowait = false },
                                -- ['<key>'] = function(state) ... end,
                            },
                            fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
                                ["<down>"] = "move_cursor_down",
                                ["<C-n>"] = "move_cursor_down",
                                ["<up>"] = "move_cursor_up",
                                ["<C-p>"] = "move_cursor_up",
                                -- ['<key>'] = function(state, scroll_padding) ... end,
                            },
                        }
                    }
                }
            }
        })

        vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
        vim.keymap.set("n", "<leader>nb", ":Neotree filesystem reveal right<CR>", {})
        vim.keymap.set("n", "<leader>nc", ":Neotree close<CR>", {})
        vim.keymap.set("n", "<leader>nf", ":Neotree buffers reveal float<CR>", {})
    end
}
