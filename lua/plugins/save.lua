return {
    'boorboor/save.nvim' -- Add to your plugin list
    ,
    config = function()
        require('save').setup {
            change_mode_mapping = '<F4>'
        }
    end
}
