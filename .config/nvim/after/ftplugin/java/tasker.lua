local overseer = require("overseer")
overseer.register_template({
  name = "Gradle: run",
  builder = function()
    return {
      cmd = { "./gradlew" },
      args = { "run" },
      components = { "default" },
    }
  end,
  condition = {
    callback = function()
      return vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1
    end,
  },
})
overseer.register_template({
  name = "Gradle: bootRun",
  builder = function()
    return {
      cmd = { "./gradlew" },
      args = { "bootRun" },
      components = { "default" },
    }
  end,
  condition = {
    callback = function()
      return vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1
    end,
  },
})

overseer.register_template({
  name = "Maven: spring-boot:run",
  builder = function()
    return {
      cmd = { "mvn" },
      args = { "spring-boot:run" },
      components = { "default" },
    }
  end,
  condition = {
    callback = function()
      return vim.fn.filereadable("pom.xml") == 1
    end,
  },
})
