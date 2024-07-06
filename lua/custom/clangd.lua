local M = {}

M.flags = {}

local boot_stdlib_dir = "/home/tjdevries/boot/go-api-gate/backend/cmd/compiler-c-api/stdlib/"
table.insert(M.flags, string.format("--extra-arg=-I%s", boot_stdlib_dir))

return M
