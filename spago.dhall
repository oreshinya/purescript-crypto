{ name = "crypto"
, dependencies =
  [ "assert"
  , "console"
  , "effect"
  , "foldable-traversable"
  , "functions"
  , "node-buffer"
  , "nullable"
  , "psci-support"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
