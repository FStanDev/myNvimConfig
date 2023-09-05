local options = {
  ensure_installed = { "lua","rust","svelte","html","typescript" },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },

  auto_install = true,
  rust = {
    enable = true
  },

  svelte = {
    enable = true,
  }
}

return options
