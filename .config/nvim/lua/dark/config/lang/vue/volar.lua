return {
  filetypes = { "typescript", "javascript", "vue", "json" },
  init_options = {
    vue = {
      -- Use Volar's built-in support for tailwind
      serverFeatures = {
        semanticTokens = true,
        completion = true,
        diagnostic = true,
      },
    },
  },
  -- handlers = {
  --   ["textDocument/completion"] = function(...)
  --     return
  --   end, -- disables completion
  -- },
  settings = {
    vue = {
      experimental = {
        templateInterpolationService = true,
      },
    },
  },
  on_init = function(client)
    client.handlers["tsserver/request"] = function(_, result, context)
      local clients = vim.lsp.get_clients({ bufnr = context.bufnr, name = "vtsls" })
      if #clients == 0 then
        vim.notify("Could not find `vtsls` lsp client, required by `vue_ls`.", vim.log.levels.ERROR)
        return
      end
      local ts_client = clients[1]
      local param = unpack(result)
      local id, command, payload = unpack(param)
      ts_client:exec_cmd({
        title = "vue_request_forward", -- You can give title anything as it's used to represent a command in the UI, `:h Client:exec_cmd`
        command = "typescript.tsserverRequest",
        arguments = {
          command,
          payload,
        },
      }, { bufnr = context.bufnr }, function(_, r)
        local response_data = { { id, r.body } }
        ---@diagnostic disable-next-line: param-type-mismatch
        client:notify("tsserver/response", response_data)
      end)
    end
  end,
}
