# Neovim Notes

Start neovim with the command `nvim`. Optionally, add a filename `nvim <filename>`.

You might see a startup help page, but you can always just start typing by pressing `i` to enter insert mode.

To enter commands press `:`
- save: `:w`
- quit: `:q`
- save and quit: `:wq`
- quit without saving: `:q!`

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
- `&` Jump to matching bracket
- `{ / }` Prev / next blank line (paragraph)
- `Ctrl+d / Ctrl+v` Half-page down / up
- `Ctrl+f / Ctrl+b` Full-page down / up
- `/<text>` Search for text

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

Motions can be repeated by prepending with a number. The format for *change* commands is:

`operator number motion`
- Operator: What to do (`c`, `d`, `y`, `v`, `gu`, `gU`, `~`, `>`, `<`)
- Number: Optional count to repeat the motion
- Motion: How we move over the text
For example `d2w` will delete until the next word twice.

