---------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------
--[[
    __                     __   _    __
   / /   ____  _________ _/ /  | |  / /___ ___________
  / /   / __ \/ ___/ __ `/ /   | | / / __ `/ ___/ ___/
 / /___/ /_/ / /__/ /_/ / /    | |/ / /_/ / /  (__  )
/_____/\____/\___/\__,_/_/     |___/\__,_/_/  /____/

--]]
local api = vim.api
local cwd = vim.loop.cwd
local has_lsp, lsp = pcall(require, 'lspconfig')
local has_lsp_util, lsputil = pcall(require, 'lspconfig/util')
---------------------------------------------------------------------------------------
--[[
    __
   / /   __  __  ____ _
  / /   / / / / / __ `/
 / /___/ /_/ / / /_/ /
/_____/\__,_/  \__,_/
--]]
--
local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

-- STORED IN MY .config/nvim/.langservers/
local sumneko_root_path = vim.fn.stdpath('config')..'/.langservers/sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

lsp.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  on_init = custom_init,
  on_attach = custom_attach,
  root_dir = function(fname)
    return lsputil.find_git_ancestor(fname) or
      lsputil.path.dirname(fname)
  end,
  --root_dir = vim.loop.cwd,
  --root_dir = util.root_pattern('.git') or cwd, --Not working
    capabilities = {
            textDocument = {
              completion = {
               completionItem = {
                 snippetSupport=true
               }
              }
            }
         },
         -- lsp_status.capabilities, --> REQUIRED FOR LSP STATUS..WROTE MY OWN
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                },
            },
        },
    },
}


