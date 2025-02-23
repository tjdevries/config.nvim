vim.cmd [[
  aunmenu   PopUp
  anoremenu PopUp.Inspect                 <Cmd>Inspect<CR>
  amenu     PopUp.-1-                     <Nop>
  anoremenu PopUp.Go\ to\ definition      <Cmd>lua vim.lsp.buf.definition()<CR>
  anoremenu PopUp.References              <Cmd>Telescope lsp_references<CR>
  nnoremenu PopUp.Back                    <C-t>
  amenu     PopUp.Open\ in\ web\ browser  gx
]]

local nvim_popupmenu_augroup = vim.api.nvim_create_augroup("nvim_popupmenu", { clear = true })
vim.api.nvim_create_autocmd("MenuPopup", {
  pattern = "*",
  group = nvim_popupmenu_augroup,
  desc = "Custom Setup",
  callback = function()
    vim.cmd [[
      " Urls
      amenu disable PopUp.Open\ in\ web\ browser

      " LSP
      amenu disable PopUp.Go\ to\ definition
      amenu disable PopUp.References
    ]]

    local urls = require("vim.ui")._get_urls()
    if vim.startswith(urls[1], "http") then
      vim.cmd [[amenu enable PopUp.Open\ in\ web\ browser]]
    end

    if vim.lsp.get_clients({ bufnr = 0 })[1] then
      vim.cmd [[anoremenu enable PopUp.Go\ to\ definition]]
      vim.cmd [[anoremenu enable PopUp.References]]
    end
  end,
})
