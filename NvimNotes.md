# Neovim Notes

Start neovim with the command `nvim`. Optionally, add a filename `nvim <filename>`.

You might see a startup help page, but you can always just start typing by pressing `i` to enter insert mode.

To enter commands press `:`
- save: `:w`
- quit: `:q`
- save and quit: `:wq`
- quit without saving: `:q!`
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
- `Ctrl+w` (While in insert mode) Delete previous word
- `Ctrl+u` (While in insert mode) Delete to start of line

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

# Config
The config file is in `~/.config/nvim/init.lua`

To add line numbers we can use the command `vim.opt.number = true`. Because we can easily jump number of lines with commands such as `10j`, it is nice to know where the relative line number. The command for relative line numbers is `vim.opt.relativenumber = true`.
By setting both to be true, we get relative numbers, while we also get the actual line number of the line we are currently on.

By default the tab size is pretty large. We can change this with `vim.opt.tabstop = 3`, this will make a tab be 3 characters wide. There is a different setting for tab width for some specific vim functions, to make these automatically match the tabstop size, we can set it to zero `vim.opt.shiftwidth = 0`. Finally, we can make tabs automatically expand to spaces (or not) with the command `vim.opt.expandtab = true`.

## Plugins

### Oil
[oil.nvim](https://github.com/stevearc/oil.nvim)

A file explorer that lets you edit your filesystem like a normal Neovim buffer. It doesn't work like regular file trees that stay on the side and open the files in another view. Instead, it overlays the view where it will open the file, which works well with neovim and multiview editing.

**Setup:**
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

Another thing I've added now. The confirmation box gets annoying for simple edits, so I disabled it.
```
    skip_confirm_for_simple_edits = true,
    delete_to_trash = true,
```

**Usage:**
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

### Telescope
[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)

A highly extendable fuzzy finder. Use to quickly search for and open a file from the current directory, including sub-directories.

**Setup:**
Telescope needs plenary as a dependancy, so we clone both into a new telescope directory in the `pack/telescope/start/` directory, so Neovim loads them automatically on startup
```
git clone --depth=1 https://github.com/nvim-lua/plenary.nvim.git \
  "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/telescope/start/plenary.nvim

git clone --depth=1 https://github.com/nvim-telescope/telescope.nvim.git \
  "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/telescope/start/telescope.nvim
```

We can also clone the native sorter to make it faster. Note that it requires cmake and GCC or Clang.
```
git clone --depth=1 https://github.com/nvim-telescope/telescope-fzf-native.nvim.git \
  "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/telescope/start/telescope-fzf-native.nvim
cd "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/telescope/start/telescope-fzf-native.nvim && make
```

We include telescope in the init.lua file
```
local builtin = require('telescope.builtin')
```

We add these keymaps
```
vim.keymap.set('n', '<C-p>', telescope.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<C-S-t>', telescope.live_grep, { desc = 'Grep' })
vim.keymap.set('n', '<leader>fb', telescope.buffers, { desc = 'Buffers' })
```    

Finally, we add this to include the optional native sorter
```
require("telescope").load_extension("fzf")
```

**Usage:**
To search and open a file, press `Ctrl+p` type the name until it shows up, then press enter to open.

## Keybinds
### Caps-Lock to Escape and Control
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

### Jump to empty line
Vim has jump to previous/next empty line bound to `{ / }` by default, which makes sense on a US keyboard layout, but on a scandinavian layout it's pretty difficult to use. So I've rebound it to `shift + j / k`, which overwrites some existing keybinds, but it's probably fine.
```
vim.keymap.set({ "n", "v" }, "K", "{")
vim.keymap.set({ "n", "v" }, "J", "}")
```

### Move line
I've added `alt + j / k` to move a line up and down.
```
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
```

# Plugin Manager (Lazy)
[lazy.nvim](https://github.com/folke/lazy.nvim)

Once you reach the 2-3 plugins mark, it's time to consider using a package manager. Lazy manages installing, updating and setting up plugins for you.

We can write some code to check if lazy is installed and install it if it is not. Replace everything in `init.lua` with this
```lua
vim.g.mapleader = " "  -- must be set before lazy loads

require("config.options")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  checker = { enabled = false },
  change_detection = { notify = false },
})

require("config.keymaps")
```

Then add a `lua` directory with `plugins` and `config` sub-directories
```
~/.config/nvim/
├── init.lua
└── lua/
    ├── config/
    │   ├── options.lua
    │   └── keymaps.lua
    └── plugins/
        ├── oil.lua
        ├── telescope.lua
```

In `options.lua` we will add our vim options
```lua
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 3
vim.opt.shiftwidth = 0 -- 0 = match tabstop
vim.opt.expandtab = true
vim.opt.breakindent = false
vim.opt.cindent = true
```

In keymaps we add our custom keymaps
```lua
vim.keymap.set({ "n", "v" }, "J", "}", { desc = "Jump to previous empty line" })
vim.keymap.set({ "n", "v" }, "K", "{", { desc = "Jump to next empty line" })

vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
```

Now, lets add our plugins. To maintain an easy overview, we seperate each plugin's setup into single files. First, Oil.
```lua
return {
  "stevearc/oil.nvim",
  lazy = false, -- lets Oil handle `nvim some/dir`
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    keymaps = {
       ["<Space>"] = { "actions.select", nowait = true },
    },
  },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
  },
}
```

Finally, telescope:
```lua
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    { "<C-p>",      function() require("telescope.builtin").find_files() end, desc = "Find files" },
    { "<C-S-t>",    function() require("telescope.builtin").live_grep() end,  desc = "Grep" },
    { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "Buffers" },
  },
  config = function()
    require("telescope").load_extension("fzf")
  end,
}
```

If you have the plugins installed already, delete them to avoid having duplicates. Then restart nvim and let lazy initialize.

## neo-tree
[neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)

I find it quite nice to be able to get an overview of my project layout with a file tree on the side. Neo-tree is a tree structure viewer that works for files, git, etc.

To add neo-tree to your plugins, create a `neo-tree.lua` file in your `/plugins` folder and add the basic neo-tree setup
```lua
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false, -- neo-tree will lazily load itself
  }
}
```

I have customized mine a bit:
- An event for resizing when nvim starts
- Close if neo-tree is the last window
- `<O>` open in file explorer
- `<space>` opens a file or folder
- `<l>` opens a file or folder
- `<h>` closes the current folder
- `<.>` disabled since I tend to miss-click it when going for `<->`
- `<->` go up once.

I also made sure that it opens on the left-hand side on startup, but only if I open a folder. If I open a file, neo-tree does not start, which also means nvim opens slightly faster for simple one-file edits.
```lua
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    opts = {
      event_handlers = {
         {
            event = "neo_tree_window_after_open",
            handler = function()
               vim.schedule(function()
                  require("config.layout").on_open()
               end)
            end,
         },
      },
      close_if_last_window = true,
      filesystem = {
        hijack_netrw_behavior = "disabled", -- let Oil own directory buffers
      },
      commands = {
        reveal_in_files = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          if node.type == "file" then
            vim.fn.jobstart({ "dolphin", "--select", path }, { detach = true })
          else
            vim.ui.open(path)
          end
        end,
      },
      window = {
        width = 25,
        mappings = {
          ["O"] = "reveal_in_files",
          ["<space>"] = { "open", nowait = true },
          ["l"] = "open",
          ["h"] = "close_node",
          ["."] = "none", -- disable set_root because it's close to -
          ["-"] = function(state)
             local node = state.tree:get_node()
             local parent_id = node:get_parent_id()
             if parent_id then
                require("neo-tree.ui.renderer").focus_node(state, parent_id)
             end
          end,
        },
      },
    },
    lazy = false,
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          local arg = vim.fn.argv(0)
          if arg == "" then return end
          local is_dir = vim.startswith(arg, "oil://") or vim.fn.isdirectory(arg) == 1
          if not is_dir then return end
          vim.schedule(function()
            vim.cmd("Neotree show left")
          end)
        end,
      })
    end,
  }
}

```

I made it so the neo-tree panel resizes when the console window resizes past a certain threshold. I handle this in a new layout file `lua/config/layout.lua`
```lua
local THRESHOLD = 150 -- columns
local WIDE, NARROW = 35, 20 -- WIDE should match window.width in neo-tree opts
local shrunk = false

local function tree_win()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "neo-tree" then
      return win
    end
  end
end

local function adjust()
  local win = tree_win()
  if not win then
    shrunk = false -- tree closed, so start fresh when it's reopened
    return
  end

  local narrow = vim.o.columns < THRESHOLD
  if narrow and not shrunk then
    vim.api.nvim_win_set_width(win, NARROW)
    shrunk = true
  elseif not narrow and shrunk then
    vim.api.nvim_win_set_width(win, WIDE)
    shrunk = false
  end
end

vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("ResponsiveLayout", { clear = true }),
  callback = adjust,
})

return {
  -- called whenever neo-tree opens: it opens at full width, so reset and re-check
  on_open = function()
    shrunk = false
    adjust()
  end,
}
```

Finally, we load this file in `init.lua`
```lua
require("config.layout")
```

With that, the neo-tree panel will resize to a `NARROW` (20) when the window is smaller than the threshold `THRESHOLD` (150) and vice-versa for `WIDE` (35).

## Toggleterm
[toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim)

I wanted a terminal that I could have in a panel on the right side of my layout and could toggle depending on the size of the terminal. Enter toggleterm. I also added some niceities, like leaving the terminal with `esc` and making sure it doesn't keep nvim running if it's the last panel together with neo-tree.

`lua/plugin/toggleterm.lua`
```lua
config = function(_, opts)
  require("toggleterm").setup(opts)

  vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "term://*toggleterm#*",
    callback = function(ev)
      vim.keymap.set("t", "<Esc>", [[<C-\><C-n><C-w>p]], { buffer = ev.buf, desc = "Leave terminal" })
    end,
  })

  vim.cmd("ToggleTerm")
  vim.cmd("wincmd p")
end,
```

I also added `lua/config/autoquit.lua` to be able to quit when it and neo-tree are the two last panels. At this point, the configs are getting a bit complicated, they are all in the config folder, so you can check them out there. Just be aware that from now the notes won't explain every implementation detail, only how to use it.

- `Ctrl+w+l` to navigate to the right panel where the terminal is.
- `i` to enter insert mode in the terminal and input commands.
- `Esc` to exit edit mode in the terminal and go back to the open buffer.
