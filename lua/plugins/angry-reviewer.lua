return {
  'anufrievroman/vim-angry-reviewer',
  config = function()
    -- Set English dialect (either 'american' or 'british')
    vim.g.AngryReviewerEnglish = 'american'

    -- Set shortcut
    vim.keymap.set('n', '<leader>ar', ':AngryReviewer<CR>', { desc = 'Run Angry Reviewer' })
  end
}
