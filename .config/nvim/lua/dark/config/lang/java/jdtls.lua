-- File types that signify a Java project's root directory. This will be
-- used by eclipse to determine what constitutes a workspace
local root_markers = { "gradlew", "mvnw", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local lombok = vim.fn.glob("$MASON/share/jdtls/lombok.jar")
local launcher = vim.fn.glob("$MASON/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
local shared_config_path = vim.fn.glob("$MASON/share/jdtls/config")
local configuration = vim.fn.stdpath("cache") .. "/jdtls/config"
local data = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name

local get_plugins = function(pattern)
  return vim.split(vim.fn.glob(pattern, true), "\n")
end
local java_debug_bundle =
  get_plugins("$MASON/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar")
local java_test_bundle = get_plugins("$MASON/packages/java-test/extension/server/*.jar")

local bundle_builder = require("dark.util.bundle").builder
bundle_builder:add_plugin(java_debug_bundle):add_plugin(java_test_bundle)

-- stylua: ignore
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client ~= nil and client.name == "jdtls" then
      local bufnr = args.buf
      vim.keymap.set("n", "<leader>tt", function() require("jdtls").test_class() end, { desc = "Run test current buffer" })
      vim.keymap.set("n", "<leader>tr", function() require("jdtls").test_nearest_method() end, { desc = "Run Nearest test method"})
    end
  end,
})

return {
  init_options = {
    bundles = bundle_builder.get_plugin(),
  },
  cmd = {
    -- Passing Args with Java(executable) is easier and cleaner.
    -- You can directly call Jdtls too, see below.
    "java", -- Required Minimum Java version 21.
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dosgi.checkConfiguration=true",
    "-Dosgi.sharedConfiguration.area=" .. shared_config_path,
    "-Dosgi.sharedConfiguration.area.readOnly=true",
    "-Dosgi.configuration.cascaded=true",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx4g", -- Maximum Heap size. Set to 4GB.
    "--add-modules=ALL-SYSTEM",
    "--add-opens",
    "java.base/java.util=ALL-UNNAMED",
    "--add-opens",
    "java.base/java.lang=ALL-UNNAMED",
    -- If you use lombok, Specify where the lombok.jar is.
    "-javaagent:" .. lombok,

    -- The jar file is located where jdtls was installed. This will need to be updated
    -- to the location where you installed jdtls
    "-jar",
    launcher,

    -- The configuration for jdtls is also placed where jdtls was installed. This will
    -- need to be updated depending on your environment
    "-configuration",
    configuration,

    -- Use the workspace_folder defined above to store data for this project
    "-data",
    data,
    -- Jdtls directly.
    -- "jdtls",
    -- "-configuration",
    -- configuration,
    -- "-data",
    -- data,
    -- "--jvm-arg=-javaagent:" .. lombok,
    -- "--jvm-arg=-Xbootclasspath/a:" .. lombok,
  },
  settings = {
    java = {
      configuration = {
        runtimes = {
          {
            name = "OpenJDK Runtime Environment Temurin-[sdkman-current]",
            path = "/usr/local/sdkman/candidates/java/current",
          },
        },
      },
      -- Enable downloading archives from eclipse automatically
      eclipse = {
        downloadSource = true,
      },
      -- Enable downloading archives from maven automatically
      maven = {
        downloadSources = true,
      },
      -- Enable method signature help
      signatureHelp = {
        enabled = true,
        description = { enabled = true },
      },
      -- Use the fernflower decompiler when using the javap command to decompile byte code back to java code
      contentProvider = {
        preferred = "fernflower",
      },
      -- Setup automatical package import oranization on file save
      saveActions = {
        organizeImports = true,
      },
      -- Customize completion options
      completion = {
        -- When using an unimported static method, how should the LSP rank possible places to import the static method from
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        -- Set the order in which the language server should organize imports
        importOrder = {
          "#",
          "java",
          "jakarta",
          "javax",
          "com",
          "org",
        },
      },
      sources = {
        -- How many classes from a specific package should be imported before automatic imports combine them all into a single import
        organizeImports = {
          starThreshold = 9999,
          staticThreshold = 9999,
        },
      },
      -- How should different pieces of code be generated?
      codeGeneration = {
        -- When generating toString use a json format
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
        -- When generating hashCode and equals methods use the java 7 objects method
        hashCodeEquals = {
          useJava7Objects = true,
        },
        -- When generating code use code blocks
        useBlocks = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      -- enable inlay hints for parameter names,
      inlayHints = {
        parameterNames = {
          enabled = "all",
        },
      },
    },
  },
}
