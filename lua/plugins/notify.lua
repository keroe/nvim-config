return {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
             vim.notify.setup({
        top_down = false
      })
    end,
}
