require("luasnip.session.snippet_collection").clear_snippets "elixir"

local ls = require "luasnip"

local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("elixir", {
  s("el", fmt("<%= {} %>{}", { i(1), i(0) })),
  s("ei", fmt("<%= if {} do %>{}<% end %>{}", { i(1), i(2), i(0) })),
})
