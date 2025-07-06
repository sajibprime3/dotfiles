return {
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
        -- description = { enabled = true },
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
