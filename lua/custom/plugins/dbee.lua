-- For now, I'm going to stick with dadbod,
-- but if the completion continues to improve I will probably switch
return {
  {
    "kndndrj/nvim-dbee",
    enabled = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    build = function()
      require("dbee").install()
    end,
    config = function()
      local source = require "dbee.sources"
      require("dbee").setup {
        sources = {
          source.MemorySource:new({
            ---@diagnostic disable-next-line: missing-fields
            {
              type = "postgres",
              name = "mixery",
              url = "postgresql://tjdevries:password@localhost:5432/mixery",
            },
          }, "mixery"),
        },
      }
      require "custom.dbee"
    end,
  },
}
