# geometry

![geometry logo by @MarioRicalde](images/branding/readme-logo.png)

> a minimalistic, fully customizable zsh prompt theme

geometry starts small, with reasonable defaults, and allows you to customize it at your own will.
It can be as simple or complex as you like.

If you have a question, suggestion, or request please [open an issue][] and be sure to check out [our contribution guide][]

## What it does

![animation of git features](./images/screencasts/git.svg)

All geometry does is run simple functions to customize the left and right prompts.

We bundle a few useful functions to start with, that can:

- give you a custom colored prompt symbol
- change the prompt symbol color according to the last command exit status
- make the prompt symbol color change with your hostname
- display current git branch, state and time since latest commit
- tell you whether you need to pull, push or if you're mid-rebase
- display the number of conflicting files and the total number of conflicts
- display if there is a stash
- display the running time of long-running commands
- set the terminal title to current command and directory
- make you the coolest hacker in the whole Starbucks

The right side prompt prints asynchronously, so you know it's going to be fast™.

Geometry also has a secondary prompt that shows up when pressing enter with an empty command, which you can configure with `GEOMETRY_INFO`.

## Installing

tool          | add to `.zshrc`
--------------|--------------------------------------
[zr][]        | `zr load geometry-zsh/geometry`
[zplug][]     | `zplug "geometry-zsh/geometry"`
[antigen][]   | `antigen theme geometry-zsh/geometry`
**manually**  | `source geometry/geometry.zsh` (after `git clone https://github.com/geometry-zsh/geometry`)

## Functions

![animation of prompt customization](./images/screencasts/functions.svg)

Geometry has very little architecture. Three environment variables define what is shown on the left, right, and on enter - `GEOMETRY_PROMPT`, `GEOMETRY_RPROMPT`, and `GEOMETRY_INFO`.

Most of these functions only show up if it makes sense to (for example, `geometry_git` only shows up if in a git repository).

To customize the prompt, just add any function to any of the `GEOMETRY_PROMPT`, `GEOMETRY_RPROMPT`, or `GEOMETRY_INFO` variables:

```sh
GEOMETRY_PROMPT=(geometry_status geometry_path) # redefine left prompt
GEOMETRY_RPROMPT+=(geometry_exec_time pwd)      # append exec_time and pwd right prompt
```

Please check out and share third-party functions on our [functions wiki page][]

For more details on how to create a function, check out [our contribution guide][]

If you prefer a two-line prompt, try `GEOMETRY_PROMPT+=(geometry_newline)`

## Configuration

You can configure everything in geometry by defining a variable.

The default configuration tries to balance the theme to be both lightweight and contain useful features.

Here we highlight some of the more commonly customized variables, but to see all of them, look in the function definitions inside the [functions directory](/function).

### general

```shell
GEOMETRY_SEPARATOR=" "    # use ' ' to separate function output
```

### geometry_status

```shell
GEOMETRY_STATUS_SYMBOL="▲"             # default prompt symbol
GEOMETRY_STATUS_SYMBOL_ERROR="△"       # displayed when exit value is != 0
GEOMETRY_STATUS_COLOR_ERROR="magenta"  # prompt symbol color when exit value is != 0
GEOMETRY_STATUS_COLOR="default"        # prompt symbol color
GEOMETRY_STATUS_COLOR_ROOT="red"       # root prompt symbol color
```

### geometry_exitcode
This renders the exit code of the previous function if it is not success.

```shell
GEOMETRY_EXITCODE_COLOR="red" # exit code color
```

### geometry_git

The git function is one of the most developed plugins in geometry.
**We recommend installing `rg` or `ag` for the best performance with `geometry_git`**.
If you want to customize what is shown, instead of using `geometry_git`, feel free to use the helper functions `geometry_git_{symbol, branch, conflicts, time, stashes & status}`. You may also want to use `geometry::git_wrapper` to have the nice `::` joining.

```shell
GEOMETRY_GIT_SYMBOL_REBASE="\uE0A0" # set the default rebase symbol to the powerline symbol 
GEOMETRY_GIT_SYMBOL_STASHES=x       # change the git stash indicator to `x`
GEOMETRY_GIT_COLOR_STASHES=blue     # change the git stash color to blue
GEOMETRY_GIT_GREP=ack               # define which grep-like tool to use (By default it looks for rg, ag and finally grep)
GEOMETRY_GIT_NO_COMMITS_MESSAGE=""  # hide the 'no commits' message in new repositories
GEOMETRY_GIT_TIME_DETAILED=true     # show full time (e.g. `12h 30m 53s`) instead of the coarsest interval (e.g. `12h`)
```
### geometry_vi

Adds a customizable vi mode indicator to the prompt which displays
whether the shell is in insert or normal mode. ZSH can be configured
to use vi-like bindings by calling `bindkey -v` either at the command
line or in your `.zshrc`.

```shell
GEOMETRY_VI_INSERT_MODE="<INSERT>"  # The textual indicator for insert-mode.
GEOMETRY_VI_INSERT_COLOR=yellow     # The color of the insert-mode indicator.
GEOMETRY_VI_NORMAL_MODE="<NORMAL>"  # The textual indicator for normal-mode.
GEOMETRY_VINORMAL_COLOR=white       # The color of the normal-mode indicator.
```

![git_conflicts](/images/screenshots/git_conflicts.png)

## Hostname based colors
Geometry provides a generic function (`geometry::hostcolor`) for setting any color based on hostname. The color is calculated as the sum of each character converted to an integer. For example the hostname 'abc' generates a value of 294.

By default the colors 1-9 and 17-230 are used as colors depending on what the environment supports. The calculated value is then modded by the size of the color list to choose a value. This value will be consistent given the same hostname.

These colors can be overridden by setting variables.

```shell
GEOMETRY_HOST_COLORS=({1..7})  # Only use the colors 1-7
GEOMETRY_HOST_COLOR=4          # Override the color for a specific host. 
``` 
![colorize](/images/screenshots/colorize.png)

## Thanks

geometry is maintained by [frm](https://github.com/frm), [desyncr](https://github.com/desyncr) and [jedahan](https://github.com/jedahan).

Thank you [MarioRicalde](https://github.com/MarioRicalde) for the lovely logos and branding.

A big thank you to the dozens of [additional contributors](https://github.com/geometry-zsh/geometry/graphs/contributors).

[functions wiki page]: https://github.com/geometry-zsh/geometry/wiki/functions
[open an issue]: https://github.com/geometry-zsh/geometry/issues/new
[zr]: https://github.com/jedahan/zr
[zplug]: https://github.com/zplug/zplug
[antigen]: https://github.com/zsh-users/antigen
[our contribution guide]: contributing.md
