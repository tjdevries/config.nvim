require("luasnip.session.snippet_collection").clear_snippets "ocaml"

local ls = require "luasnip"

local s = ls.snippet
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("ocaml", {
  s("re", fmt("let {} = [%sedlex.regexp? {}]{}", { i(1), i(2), i(0) })),
})
