vim.lsp.config("intelephense", {
  settings = {
    intelephense = {
      files = {
        maxSize = 100000000, -- set to (100MB) / default is 1000000 (1MB)
      },
      format = {
        enable = false,
      },
      exclude = {
        -- Symfony specific
        "**var/**",
        -- Default excludes
        "**/.git/**",
        "**/.svn/**",
        "**/.hg/**",
        "**/CVS/**",
        "**/.DS_Store/**",
        "**/node_modules/**",
        "**/bower_components/**",
        "**/vendor/**/{Tests,tests}/**",
        "**/.history/**",
        "**/vendor/**/vendor/**",
      },
      telemetry = {
        enabled = false,
      },
    },
  },
})

return {}
