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
            close_if_last_window = true,
            window = {
                position = "right",
                width = 40,
                mapping_options = {
                    noremap = true,
                    nowait = true,
                },
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
                follow_current_file = {
                    enabled = false, -- This will find and focus the file in the active buffer every time
                    --               -- the current file is changed while the tree is open.
                    leave_dirs_open = false, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
                },
                group_empty_dirs = false, -- when true, empty folders will be grouped together
                -- in whatever position is specified in window.position
                -- "open_current",  -- netrw disabled, opening a directory opens within the
                -- window like netrw would, regardless of window.position
                -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
                use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
                -- instead of relying on nvim autocmd events.
            },
            nesting_rules = {},
            filesystem = {
                hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
                filtered_items = {
                    visible = false, -- when true, they will just be displayed differently than normal items
                    hide_dotfiles = true,
                    hide_gitignored = true,
                    hide_hidden = true, -- only works on Windows for hidden files/directories
                    hide_by_name = {
                        "node_modules",
                        "devel",
                        "logs",
                        "log",
                        "install",
                        "build",
                        "wandb",
                    },
                    hide_by_pattern = { -- uses glob style patterns
                        "*.meta",
                        --"*/src/*/tsconfig.json",
                        "agent_file*.sh",
                        "*.ckpt"
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
            },
        })

         vim.api.nvim_create_autocmd("User", {
            pattern = "NeoTreeBufferLeave",
            callback = function()
                local shown_buffers = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    shown_buffers[vim.api.nvim_win_get_buf(win)] = true
                end
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if not shown_buffers[buf]
                        and vim.api.nvim_buf_get_option(buf, 'buftype') == 'nofile'
                        and vim.api.nvim_buf_get_option(buf, 'filetype') == 'neo-tree'
                    then
                        vim.api.nvim_buf_delete(buf, { force = true })
                    end
                end
            end,
        })

        vim.keymap.set("n", "<leader>nb", ":Neotree filesystem reveal right<CR>", {})
        vim.keymap.set("n", "<leader>nc", ":Neotree close<CR>", {})
        vim.keymap.set("n", "<leader>nf", ":Neotree buffers reveal float<CR>", {})
    end
}
