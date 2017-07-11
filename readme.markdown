![dots][header-image]

 - [`file/`](file/) contains my [dotfiles][wiki-dotfiles].
 - [`script/`](script/) contains scripts I keep in my [`$PATH`][wiki-path].

I aggressively minimise visual output and keystrokes, even at the expense of
nobody else being able to use my computer, and having to memorise a hundred
shortcuts.  This is all hyper-optimised for *me specifically*, but feel free to
take what you find useful.

## The install script

This is my way to scatter my dotfiles onto a new system.  You may prefer one of
[many other ways][archwiki-dotfiles].

The `./install.zsh` has a [DSL][wiki-dsl] expressing how each conf file location on the
system should be generated.  Most are just instructions to symlink them to a
`file/` here.  The script wields the `--force`, so be careful.  If unsure, run
`./install.zsh --dry-run` first.

The install requires—

 - `zsh` to run the script,
 - `curl` to download `plug.vim`,
 - `nvim` to run plug.vim to install plugins, and
 - `git` for plug.vim to download plugins


[archwiki-dotfiles]: https://wiki.archlinux.org/index.php/Dotfiles
[header-image]: https://user-images.githubusercontent.com/5231746/28067800-b22aaeea-663a-11e7-8938-ee799ab1eef8.png
[wiki-dotfiles]: https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory#Unix_and_Unix-like_environments
[wiki-dsl]: https://en.wikipedia.org/wiki/Domain-specific_language
[wiki-path]: https://en.wikipedia.org/wiki/PATH_(variable)
