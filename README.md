# geometry

geometry is a minimalistic, fully customizable zsh prompt theme.

![geometry](screenshots/geometry.gif)

geometry starts small, with good defaults, and allows you to customize it at your own will. It can be as simple or complex as you like.

TODO: INDEX

## Installing

*K, I'm sold. Beam me up, Scotty.*

### antigen

Just add `antigen bundle frmendes/geometry` to your `.zshrc`.

### oh-my-zsh

Move `geometry.zsh` to `$HOME/.oh-my-zsh/custom/themes/geometry.zsh-theme` and
set `ZSH_THEME="geometry"` in your `.zshrc`.

### zplug

Add `zplug "frmendes/geometry"` to your `.zshrc`

## Dependencies

The symbol for rebasing comes from a [Powerline patched font](https://github.com/powerline/fonts). If you want to use it, you're going to need to install one from the font repo. The font used in the screenshots is [Roboto Mono](https://github.com/powerline/fonts/tree/master/RobotoMono). You can also try to [patch it yourself](https://github.com/powerline/fontpatcher).

You can also change the rebase symbol by setting the `GEOMETRY_SYMBOL_GIT_REBASE` variable.

## What it does

To allow a pleasant configuration and customization, geometry works with the concept of plugins.

By default, here's what it looks like:

![geometry](screenshots/geometry.png)

In a nutshell, it can:

- give you a custom, colorizable prompt symbol
- change the prompt symbol color according to the last command exit status
- make the prompt symbol color change with your hostname
- display current git branch, state and time since last commit
- tell you whether you need to pull, push or if you're mid-rebase
- display the number of conflicting files and total number of conflicts
- display the running time of long running commands
- set the terminal title to current command and directory
- make you the coolest hacker in the whole Starbucks

The right side prompt is print asynchronously, so you know it's going to be
fast™.

### Plugins

geometry has an internal plugin architecture. The default plugins are `exec_time` and `git`. But you can also enable a number of them just by setting the `GEOMETRY_PROMPT_PLUGINS` variable in your own configuration files:

```sh
GEOMETRY_PROMPT_PLUGINS=(virtualenv dockermachine)
```

*Note: if you're not sure where to put geometry configs, just add them to your `.zshrc`*

These plugins will load and display on the right prompt. You can check the
documentation and configuration for each specific plugin in the
[plugins](/plugins) directory.

geometry also supports your own custom plugins. See the plugin documentation for
instructions and examples.

### Prompt Configuration

geometry was built with easy configuration in mind. The best way to do so is by
[using environment variables](https://github.com/frmendes/dotfiles/blob/7f448626e1c6e9c0ab7b474c5ff2c1939b64b7d2/system/prompt.zsh#L18-L24).

Pretty much everything in geometry can be changed by setting a variable **before
you load the theme**.

The default options try to balance the theme in order to be both lightweight and contain useful features.

#### Symbols

There are a set of symbols available which you can override with environment variables.

```shell
GEOMETRY_SYMBOL_PROMPT="▲"                  # default prompt symbol
GEOMETRY_SYMBOL_PROMPT2="◇"                 # multiline prompts
GEOMETRY_SYMBOL_EXIT_VALUE="△"              # displayed when exit value is != 0
GEOMETRY_SYMBOL_ROOT="▲"                    # when logged in user is root
```

You can find symbol configuration for specific plugins under the
[plugins](/plugins) directory.

### Colors

The following color definitions are available for configuration:

```shell
GEOMETRY_COLOR_EXIT_VALUE="magenta" # prompt symbol color when exit value is != 0
GEOMETRY_COLOR_PROMPT="white" # prompt symbol color
GEOMETRY_COLOR_ROOT="red" # root prompt symbol color
GEOMETRY_COLOR_DIR="blue" # current directory color
```

You can find color configuration for specific plugins under the
[plugins](/plugins) directory.

#### Features

##### Async `RPROMPT`

geometry runs `RPROMPT` asynchronously to avoid blocking on costly operations. This is enabled by default but you can disable it by setting `PROMPT_GEOMETRY_GIT_ASYNC` to `false`

##### Randomly colorize prompt symbol

Your prompt symbol can change colors based on a simple hash of your hostname. To enable this, set `PROMPT_GEOMETRY_COLORIZE_SYMBOL` to `true`.

![colorized_symbol](screenshots/colorized_symbol.png)

##### Colorize prompt symbol when root

You can have your prompt symbol change color when running under the `root` user.

To activate this option, just set `PROMPT_GEOMETRY_COLORIZE_ROOT` to `true`. Both symbol and color can be customized by overriding the `GEOMETRY_SYMBOL_ROOT` and `GEOMETRY_COLOR_ROOT` variables.

Note that this option overrides the color hashing of your prompt symbol.

##### Display elapsed time for long-running commands

You can optionally show a time display for long-running commands
by setting the `PROMPT_GEOMETRY_EXEC_TIME` variable to `true`.

If enabled, this shows the elapsed time for commands running longer than 5 seconds. You can change this threshold by changing `PROMPT_GEOMETRY_COMMAND_MAX_EXEC_TIME` to the number of desired seconds.

![long_running](long_running.png)


## FAQs

**I found a bug. What do I do?**

Open an issue. There are probably more people with that very same problem so we like to keep everything documented in case someone else comes looking for a solution.

If you can provide info about your terminal, OS and zsh version it would be a great starting point. It would also be of great assistance if you are able to write steps to reproduce the issue.

**I have an idea for a feature, can I submit a PR?**

Please do. geometry is a work in progress, if you want to help improve it, your
idea is welcome. We're not looking to add a lot of default features to not
overload the theme. However, plugins are a great way of extending geometry
without overloading it. If you have an idea for a plugin, feel free to
submit it and we'll always give our best to provide constructive feedback and
help you improve.

**Is there anything specific I can do to help?**

There are always things we would like to improve. Feel free to jump in on any issue to tackle it or just to provide your feedback.

As for PRs, we are currently looking to improve performance.

If you want to help with plugins, we are looking to add Ruby and Node version displays.

**Where do I put my geometry configuration files?**

Well, anywhere in your `.zshrc` file should be fine, **as long as you define
variables before geometry is loaded**.

**My tab completion is weird.**

[Relevant xkcd](http://xkcd.com/1726/)

This is a [known problem](https://github.com/frmendes/geometry/issues/3#issuecomment-244875921) due to the use of unicode characters. It should be fixed right now. If it persists, update geometry and check if the terminal version reported by zsh matches your terminal emulator reported version. Please comment on that thread if any new issues arise.

**There are too many/few spaces after the symbol or the prompt**

You're probably using a different prompt character. zsh has a few issues
determining the length of the prompt and while it should work for most cases, if
you changed the symbol to a different character (an example would be:  ☁︎ ), some extra spaces show up after the prompt. That problem is [documented here](https://github.com/frmendes/geometry/issues/3#issuecomment-245571623) and there is no known fix for it except on a case-by-case basis. You can add or remove any extra space on the `prompt_geometry_render` function, on `geometry.zsh`. If you find a universal solution, feel free to make a PR for it.

**The prompt is slow on large repos**

This is also a known issue. Make sure you have `PROMPT_GEOMETRY_GIT_ASYNC` set to `true` to avoid long waiting times. If the problem persists, our recommendation would be to disable the git time checks by setting `PROMPT_GEOMETRY_GIT_TIME` to `false`.

**That's a neat font you have there. Can I have it?**

Sure. It's [Roboto Mono](https://fonts.google.com/specimen/Roboto+Mono). Don't forget to use the [powerline patched version](https://github.com/powerline/fonts/tree/master/RobotoMono) if you want to use the default rebase symbol.

## Maintainers

geometry is currently maintained by [frmendes](https://github.com/frmendes) and [desyncr](https://github.com/desyncr).

A big thank you to those who have previously [contributed](https://github.com/frmendes/geometry/graphs/contributors), [jedahan](https://github.com/jedahan) in particular.
