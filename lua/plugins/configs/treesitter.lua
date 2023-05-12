local options = {
  ensure_installed = { "lua","rust","svele","python","typescript" },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },
  python = {
    enable = true
  },
  svelte = {
      enable = true,
      parser_config = {
        tags = {
          style = { "scoped" },
          script = { "contextual_keyword" },
        },
      },
  },
  rust = {
    enable = true,
  },
}

return options
