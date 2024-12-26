# exqudens-py-pytest

##### how-to-config

1. select one of presets as `<preset>` from output of `cmake --list-presets`:
    * `windows.ninja.python`
    * `linux.ninja.python`
    * `darwin.ninja.python`
2. `camke --preset <preset>`

##### how-to-vscode

1. follow `how-to-config` instructions
2. `camke --build --preset <preset> --target vscode`
