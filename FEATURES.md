# Features

## Walkthrough Video Script

### Feature by Feature

 - Hello!

#### MonadTall Layout

 - Qtile is a tiling window manager
 - Open and close some windows
 - Used to use Xmonad, used to it
 - Can swap primary column
 - Can send window to primary and back
 - Almost always in tile mode, but can float windows as well

#### Picom

 - Talk about picom, turn it on/off, show config file
   - Transparency
   - Animations
   - Selective Dimming

#### Qtile Workspaces

 - Many pairs of workspaces, used per "project"
 - I find usually I like to have one workspace for primary interaction, and a
   secondary for reference material or to dump windows I don't use often.
 - Can jump to primary by pressing mod+key
 - Can click to go to specific workspace
 - Can cycle through
 - Can bring windows along for the ride when cycling (also via mouse)
 - Can swap easily - super nice when on a single screen like a laptop
 - Can send windows back and forth

#### Qtile Bar

(go through rest of the bar widgets and click on them)


### Website Editing

1. I want to make some updates to my website, specifically the keyboard layout
   page.
1. Open website in Chrome.
   - Alternatively, use fzf chrome history shortcut
1. Open terminal to website dir
1. Talk about QTile's tiling, show different layouts
1. Start editing website in vim
   - Talk about neovim at a high level
   - Talk about one sentence per line formatting
   - Do some copy pasting and talk about clipboard manager, point it out in
     QTile bar
1. Now I want to preview my changes
1. Open new terminal with hugo command
   - Talk about command line completion and history searching
1. Use kitty kitten to open localhost url
1. Note that the workspace is getting crowded.
1. Send the hugo window to the '1a' workspace
1. Talk about my QTile workspace system
1. Go back to the split window with my local website and neovim
   - Talk about compton for transparency and for selective dimming of the
     usually mostly white chrome window 1.
1. Now talk about editing keyboard layouts at my special modifier keys (e.g.
   alt-h for backspace).


### Ways to Record

 - https://obsproject.com/download#linux

## By Program

### Keyboard/Writing

 - Colemak/Dvorak
 - Dictation into Google doc

### QTile

 - Everything is a hotkey!
 - Right click on desktop menu
 - Top bar, element by element
 - Workspaces for different projects
 - Cycling window layouts
 - Clipboard manager, with top bar integration
  - Everything sends to single clipboard, even over ssh
 - Selective window dimming and transparency
 - Resolution and rotation script
 - Bash script hotkeys
   - Example: download youtube shortcut

### Kitty

 - Terminal Emulator
 - Hotkeys to copy lines, open urls
 - Hotkey to open output in vim
 - icat for viewing images
 - Copy/paste over ssh via X11 forwarding

### Zsh

 - Last command autocompletion (shadow autofill)
 - Fzf history search
 - Custom prompt (p10k)
 - Vi mode cursor

### NeoVim

 - Completion based on words in buffers
 - TODO populate a list here of my most used hotkeys: https://www.reddit.com/r/vim/comments/vodi0q/any_way_to_track_usage_of_commandhotkey_usage/

### Chrome

 - Vimium C
 - Fzf history search
