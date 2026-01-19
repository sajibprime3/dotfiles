local M = {}

local bundle_list = {}

--Metatable
local bundle_mt = {
  __index = {
    ---@param plugin table|string
    add_plugin = function(self, plugin)
      vim.list_extend(bundle_list, type(plugin) == "table" and plugin or { plugin })
      return self
    end,
    get_plugin = function()
      return bundle_list
    end,
  },
}

M.builder = setmetatable({}, bundle_mt)

return M
