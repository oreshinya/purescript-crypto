{ name = "crypto"
, dependencies =
  [ "assert", "console", "effect", "functions", "node-buffer", "psci-support" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
