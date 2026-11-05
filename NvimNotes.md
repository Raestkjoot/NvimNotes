# Neovim Notes

Start neovim with the command `nvim`. Optionally, add a filename `nvim <filename>`.

You might see a startup help page, but you can always just start typing by pressing `i` to enter insert mode.

To enter commands press `:`
- save: `:w`
- quit: `:q`
- save and quit: `:wq`
- quit without saving: `:q!
- `:e <file>` edit file

## Modes
- `i` Insert before cursor
- `I` Insert at line start
- `a` Insert after cursor
- `A` Insert at line end
- `o` New line below, insert
- `O` New line above, insert

- `v` Visual (character)
- `V` Visual (line)
- `Ctrl+v` Visual (block)
- `:` Command mode
- `:!<command>` To enter an external command
- `Esc` Return to normal
- `R` Replace mode

## Navigation
- Move with hjkl: `h` (left)  `j` (down)  `k` (down)  `l` (right)
- `w / W` Next word / WORD (Skip punctuation)
- `b / B` Previous word / WORD (Skip punctuation)
- `e / E` End of word / WORD (Skip punctuation)
- `0 / ^` Line start / first non-blank
- `$` Line end
- `f<char> / F<char>` Find moves the cursor onto the next occurrence of char / moves backwards
- `t<char> / T<char>` Till moves the cursor to just before the next occurrence of char / moves backwards
- `; / ,` Repeat last `f t F T` motion in the same / opposite direction
- `gg / G` File start / file end
- `:<N>` Go to line number N
- `%` Jump to matching bracket
- `{ / }` Prev / next blank line (paragraph)
- `Ctrl+d / Ctrl+u` Half-page down / up
- `Ctrl+f / Ctrl+b` Full-page down / up
- `H / M / L` Jump to top, middle or end of the visible screen
- `/<text> / ?<text>` Search for text / search backwards
- `* / #` Search for word under cursor
- `n / N` Next / previous match
- `:noh` Clear search highlight

### Navigation Hierarchy
1. Whole file: `gg`, `G`, `/<pattern>`
2. Multiple lines: `ctrl+d` `ctrl+u`, `<num>j`, `<num>k`
3. Line anchor: `0`, `^`, `$`
4. Same line: `f<char>`, `t<char>`, `;`, `,`
5. Nearby words: `w`, `b`, `e`

### Marks and Jumps
- `m<a-z>` Set local mark
- `m<A-Z>` Set global mark
- `'<mark>` Jump to mark line
- `''` Jump to last position
- `Ctrl+o / Ctrl+i` Jump back / forward in history
- `:marks` List all marks

## Editing
- `x` Delete character
- `dd / D` Delete line / to end of line
- `yy` Yank line
- `p / P` Paste after / before cursor
- `u` Undo
- `Ctrl+r` Redo
- `cc / C` Change line / to end of line
- `r` Replace single character
- `J` Join line below to current
- `.` Repeat last change
- `> / <` Indent / un-indent
- `gu / gU / ~` Lowercase / uppercase / toggle
- `Ctrl+w` Delete previous word
- `Ctrl+` Delete to start of line

### Changing Multiple Occurences
`*cgn.`: We can `*` to start looking for occurences, then `c` to change and `gn` to go next, write in what you want instead and use `.` to repeat. To go back you can use `#` or `N`.

### Repeated Motions
Motions can be repeated by prepending with a number. The format for *change* commands is:

`operator number motion`
- Operator: What to do (`c`, `d`, `y`, `v`, `gu`, `gU`, `~`, `>`, `<`)
- Number: Optional count to repeat the motion
- Motion: How we move over the text
For example `d2w` will delete until the next word twice.

### Text Objects
Operations can also be applied to different text objects. The format is 

`Operator <i/a> object`
- `w` Inner / around word
- `s` Inner / around sentence
- `p` Inner / around paragraph
- `"` Inner / around double quotes
- `'` Inner / around single quotes
- `(` Inner / around parentheses
- `[` Inner / around brackets
- `{` Inner / around braces
- `t` Inner / around HTML tags
For example: `diw` to delete a word.

## Config
The config file is in `~/.config/nvim/init.lua`

To add line numbers we can use the command `vim.opt.number = true`. Because we can easily jump number of lines with commands such as `10j`, it is nice to know where the relative line number. The command for relative line numbers is `vim.opt.relativenumber = true`.
By setting both to be true, we get relative numbers, while we also get the actual line number of the line we are currently on.

By default the tab size is pretty large. We can change this with `vim.opt.tabstop = 3`, this will make a tab be 3 characters wide. There is a different setting for tab width for some specific vim functions, to make these automatically match the tabstop size, we can set it to zero `vim.opt.shiftwidth = 0`. Finally, we can make tabs automatically expand to spaces (or not) with the command `vim.opt.expandtab = true`.

## Splits & Windows
- `Ctrl+w s` Horisontal split
- `Ctrl+w v` Vertical split
- `Ctrl+w h/j/k/l` Move between splits
- `Ctrl+w q` Close split

### Resizing windows
- `Ctrl+w <` Make window narrower
- `Ctrl+w >` Make window wider
- `Ctrl+w +` Make window taller
- `Ctrl+w -` Make window shorter
- `Ctrl+w =` Make windows equal

Each of these will modify the size by 1, which is not a lot. Prefix with a count to resize by more than one. E.g. to widen by 20, input `20 Ctrl+w >`

# Plugins

## Oil
[oil.nvim](https://github.com/stevearc/oil.nvim)

A file explorer that lets you edit your filesystem like a normal Neovim buffer. It doesn't work like regular file trees that stay on the side and open the files in another view. Instead, it overlays the view where it will open the file, which works well with neovim and multiview editing.

### Setup
The most bare-bones way to install it is as a native package, not using a plugin manager. Clone the repository into Neovim's native pack directory
```
git clone --depth=1 https://github.com/stevearc/oil.nvim.git \
  "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/oil/start/oil.nvim
```

Then, add `require("oil").setup()` to the init.lua file. Now we can open oil with the command `:Oil`. I like to open it as a floating window, so I will add a key to the vim keymap that will do just that. 
```
vim.keymap.set("n", "-", require("oil").open_float, { desc = "Open oil in float" })
```
This lets me open oil with the `-` key from anywhere.

To add a keybind that is specific to Oil, we can use its setup function.
```
require("oil").setup({ keymaps = { ["<Space>"] = "actions.select" } })
```
This lets us use `space` to enter files and directories.

### Usage
- `-` - Open the parent directory of the current file.
- `nvim .` - We can start Neovim in some directory like this and it will open it with Oil.
- `g.` - Toggle hidden files (with Oil open).

The cool thing with Oil is that editing your file tree works just like regular text edits in Neovim.
- **Create:** Create a file by adding a new line with `o` and writing the file name.
- **Delete:** Delete a file with the vim command `dd`.
- **Move:** After deleting, paste it with `p`.
- **Copy:** Copy by yanking the line `V` then `y`, then paste the line with `p`.
- **Save:** Save the changes you've made to the file tree with `:w`.
- **Discard:** If you want to discard your changes, then quit without writing `:q!`.
- **Select:** Select a file or directory with `enter` or, if you've bound it, `space`.

# Keybinds
## Caps-Lock to Escape and Control
The escape key is very important in vim, but it is one of the furthest keys from the home row. Meanwhile, caps-lock is one of the least important keys and it sits at one of the best positions right next to the homerow. 

We can use [keyd](https://github.com/rvaiya/keyd) to rebind our caps-lock key at the kernel level.
1. Install and start keyd (e.g `sudo systemctl enable keyd --now`)

2. Put the following in `/etc/keyd/default.conf`:

```
[ids]

*

[main]

# Maps capslock to escape when pressed and control when held.
capslock = overload(control, esc)

# Remaps the escape key to capslock
esc = capslock
```

3. Run `sudo keyd reload` to reload the config set.

## Jump to empty line
Vim has jump to previous/next empty line bound to `{ / }` by default, which makes sense on a US keyboard layout, but on a scandinavian layout it's pretty difficult to use. So I've rebound it to `shift + j / k`, which overwrites some existing keybinds, but it's probably fine.
```
vim.keymap.set({ "n", "v" }, "K", "{")
vim.keymap.set({ "n", "v" }, "J", "}")
```

## Move line
I've added `alt + j / k` to move a line up and down.
```
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
```
