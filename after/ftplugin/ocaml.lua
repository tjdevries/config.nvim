local set = vim.opt_local

set.shiftwidth = 2

vim.keymap.set("n", "<space>cp", require("ocaml.mappings").dune_promote_file, { buffer = 0 })
vim.keymap.set("n", "<space>cd", require("ocaml.mappings").destruct, { buffer = 0 })
