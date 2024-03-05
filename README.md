These are my git aliases.

- Three letter base command for most things, two letter base for some things
- Additional letters are additional options
- Prefix with f for commands that use fzf
- Don't stray too far from the original git commands
- Don't make it too easy to do dumb stuff
- Aliases don't save you time if you never use the command

### Installation

Just `source` the file `my_git_aliases.plugin.zsh` somewhere in your setup.

Alternatively, if you use a plugin manager like [zgen](https://github.com/tarjoilija/zgen), this is as easy as adding `zgen load hauntsaninja/my_git_aliases` in the right place.

Several of the more complicated aliases use [pyp](https://github.com/hauntsaninja/pyp). Install it using `pip install pypyp`.

If you use the `fzf` aliases, you'll need [fzf](https://github.com/junegunn/fzf).

Some aliases use [git-revise](https://github.com/mystor/git-revise).
