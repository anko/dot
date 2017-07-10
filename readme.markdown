# dots

Here are my [dotfiles][wp-dotfiles].

I prefer absolutely minimal program output, and am always ready to remap my
muscle memory to save a few keystrokes, or decipher 6-pixel tall fonts just to
fit another terminal on screen.  If that sounds like fun to you, maybe you'll
find something here you can use.

Organisation:

 - [`files/`](files/) contains dotfiles.  Their purposes should be clear from
   the filename.
 - [`script/`](script/) contains scripts I find useful enough to keep in my
   `$PATH`.  No binaries, just text stuff.

## The install script

Chances are you'd want to use [one of many other—probably better—ways to
scatter your dotfiles](https://wiki.archlinux.org/index.php/Dotfiles), but this
is my way.

The `./install` script symlinks stuff from `file/` to the places specified in
it.  *Be careful*, for it wields the `--force`.  If unsure, run `./install
--dry-run` first, and it will tell you what it *would have done*, instead of
doing it.

The `install` requires these programs:

 - `zsh` to run the script,
 - `curl` to download `plug.vim`,
 - `nvim` to run plug.vim to install plugins, and
 - `git` for plug.vim to download plugins

[wp-dotfiles]: https://en.wikipedia.org/wiki/Hidden_file_and_hidden_directory#Unix_and_Unix-like_environments
