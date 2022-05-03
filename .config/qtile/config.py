import os
import re
import shlex
import subprocess
import types
from typing import List  # noqa: F401

from libqtile import bar, hook, layout, widget
from libqtile import qtile
from libqtile.config import Click, Drag, Group, Key, Screen, Match
from libqtile.lazy import lazy
from libqtile.log_utils import logger
from libqtile.widget.graph import MemoryGraph
from Xlib import display as xdisplay

# Log location is at ~/.local/share/qtile/qtile.log


# Get colors from currently active kitty terminal theme
colors = {}
theme_filepath = None
with open(os.path.expanduser('~/.config/kitty/kitty.conf'), 'r') as f:
  for line in f:
    if line.startswith('include') and 'theme' in line:
      theme_filepath = os.path.join(
          os.path.expanduser('~/.config/kitty'), line.split()[1])
if theme_filepath:
  with open(theme_filepath, 'r') as f:
    for line in f:
      colors[line.split()[0]] = line.split()[1].upper()


mod = "mod4"


def hard_restart(qt):
  qt.cmd_restart()


# See https://github.com/qtile/qtile/blob/master/libqtile/xkeysyms.py for
# reference.
keys = [
    Key([mod], "k",
        lazy.layout.up().when(layout='monadtall'),
        lazy.layout.up().when(layout='monadthreecol'),
        lazy.layout.up().when(layout='max'),
        lazy.layout.left().when(layout='2cols'),
        lazy.layout.left().when(layout='3cols')),
    Key([mod], "j",
        lazy.layout.down().when(layout='monadtall'),
        lazy.layout.down().when(layout='monadthreecol'),
        lazy.layout.down().when(layout='max'),
        lazy.layout.right().when(layout='2cols'),
        lazy.layout.right().when(layout='3cols')),
    Key([mod, 'control'], "k",
        lazy.layout.up().when(layout='2cols'),
        lazy.layout.up().when(layout='3cols')),
    Key([mod, 'control'], "j",
        lazy.layout.down().when(layout='2cols'),
        lazy.layout.down().when(layout='3cols')),

    # Skip managed ignores groups already on a screen.
    Key([mod], "h",
        lazy.screen.prev_group(skip_managed=True)),
    Key([mod], "l",
        lazy.screen.next_group(skip_managed=True)),

    Key([mod], "period", lazy.prev_screen()),
    Key([mod], "comma", lazy.next_screen()),
    Key([mod, "shift"], "period", lazy.swap_screens()),
    Key([mod, "shift"], "comma", lazy.swap_screens()),

    Key([mod, "shift"], "h", lazy.layout.swap_left()),
    Key([mod, "shift"], "l", lazy.layout.swap_right()),
    Key([mod, "shift"], "j",
        lazy.layout.shuffle_down().when(layout='monadtall'),
        lazy.layout.shuffle_down().when(layout='monadthreecol'),
        lazy.layout.swap_column_left().when(layout='2cols'),
        lazy.layout.swap_column_left().when(layout='3cols')),
    Key([mod, "shift"], "k",
        lazy.layout.shuffle_up().when(layout='monadtall'),
        lazy.layout.shuffle_up().when(layout='monadthreecol'),
        lazy.layout.swap_column_right().when(layout='2cols'),
        lazy.layout.swap_column_right().when(layout='3cols')),

    Key([mod], "equal", lazy.layout.grow()),
    Key([mod], "minus", lazy.layout.shrink()),
    Key([mod], "m", lazy.layout.maximize()),
    Key([mod], "n", lazy.layout.minimize()),
    # Key([mod, "control"], "h", lazy.layout.grow_left()),
    # Key([mod, "control"], "l", lazy.layout.grow_right()),

    Key([], "XF86AudioRaiseVolume",
        lazy.spawn("amixer sset Master 5%+")),
    Key([], "XF86AudioLowerVolume",
        lazy.spawn("amixer sset Master 5%-")),
    Key([], "XF86AudioMute",
        lazy.spawn("amixer sset Master toggle")),

    Key([], "XF86MonBrightnessUp", lazy.spawn("brightness.sh up")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightness.sh down")),

    # Run this command to make an image file from the screenshot:
    # xclip –selection clipboard –t image/png –o > /tmp/nameofyourfile.png
    Key([], 'Print', lazy.spawn(
        ["bash", "-c",
         # https://github.com/naelstrof/maim/issues/182
         "pkill compton; "
         "maim -s | tee ~/clipboard.png | xclip -selection clipboard -t image/png; "
         # This part is not working for some reason at the moment.  I think it
         # works when i switch away from the image clipboard content and back
         # to it with copyq.
         ])),
         # "xclip –selection clipboard –t image/png –o > ~/clipboard.png"])),
        # lazy.spawn("scrot -s -e 'mv $f ~/pictures/screenshots/'")),

    # , ((0, xK_Print), spawn "scrot -e 'mv $f ~/pictures/screenshots/'")

    # Switch window focus to other pane(s) of stack
    # Key([mod], "space", lazy.layout.next()),

    # Swap panes of split stack
    # Key([mod, "shift"], "space", lazy.layout.rotate()),

    Key([mod], "t", lazy.window.toggle_floating()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack 
    # Key([mod], "z", lazy.layout.toggle_split()),
    # Key([mod, "control"], "z", lazy.layout.swap_column_left()),

    Key([mod], "z", lazy.spawn(
        # 'kitty bash --init-file <(echo "~/bin/chrome-history.zsh 2;bash")')),
        "kitty zsh -c '~/bin/chrome-history.zsh 2;read'")),

    Key([mod], "c", lazy.spawn('copyq next')),
    Key([mod], "v", lazy.spawn('copyq previous')),
    Key([mod, 'control'], "c", lazy.spawn('copyq menu')),

    Key([mod, 'control'], "w", lazy.spawn([
        "/bin/zsh", "-c", "~/bin/setup-monitors.bash forked &> ~/setup-monitors.log"])),
    Key([mod, 'control'], "e", lazy.spawn([
        "/bin/zsh", "-c", "~/bin/setup-monitors.bash forked rotated &> ~/setup-monitors.log"])),

    Key([mod], "Escape", lazy.spawn("screensaver.sh")),
    Key([mod, 'shift'], "Escape", lazy.spawn("systemctl suspend")),
    Key([mod], "Return", lazy.spawn("kitty")),
    Key([mod, 'shift', 'control'], "Return", lazy.spawn(
        "kitty zsh -c 'cmatrix -u 10 -s; zsh -i'")),
    Key([mod, 'shift'], "Return",
        lazy.spawn("kitty env RUN='cd $(< ~/lastdir)' zsh")),
    Key([mod], "backslash", lazy.spawn("google-chrome")),
    Key([mod], "y", lazy.spawn("kitty /bin/zsh -c dl-and-play-yt.bash")),

    Key([mod], "b", lazy.spawn("nvim-textarea.bash")),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "x", lazy.window.kill()),

    Key([mod, "control"], "z", lazy.spawn([
        "bash", "-c", "pkill compton; run-compton.bash"])),

    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "t", lazy.function(hard_restart)),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "space", lazy.spawn("j4-dmenu-desktop")),
]

mouse = [
    # Drag floating layouts.
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
    # Rearrange and resize windows with mouse wheel
    # For MonadTall layout
    Click([mod], 'Button4', lazy.layout.grow()),
    Click([mod], 'Button5', lazy.layout.shrink()),
    Click([mod, "shift"], "Button5", lazy.layout.shuffle_down()),
    Click([mod, "shift"], "Button4", lazy.layout.shuffle_up()),
    # For Columns Layouts
    Click([mod], 'Button4', lazy.layout.grow_left()),
    Click([mod], 'Button5', lazy.layout.grow_right()),
    Click([mod, 'control'], 'Button4', lazy.layout.grow_up()),
    Click([mod, 'control'], 'Button5', lazy.layout.grow_down()),
]

group_names = list("asdfqwer1234567")
groups = [Group(i) for i in group_names]


# https://github.com/qtile/qtile/issues/1378#issuecomment-516111306
def toscreen(qtile, group_name):
  if group_name == qtile.current_screen.group.name:
    return qtile.current_screen.set_group(
        qtile.current_screen.previous_group)
  for i, group in enumerate(qtile.groups):
    if group_name == group.name:
      return qtile.current_screen.set_group(qtile.groups[i])


for i in groups:
  keys.extend([
      # mod1 + letter of group = switch to group
      Key([mod], i.name, lazy.function(toscreen, i.name)),

      # mod1 + shift + letter of group = move focused window to group
      Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=False)),
  ])

def movescreens(qtile, offset):
  screen_group_names = [s.group.name for s in qtile.screens]
  screens_wrap = (group_names[-1] in screen_group_names
                  and group_names[0] in screen_group_names)
  # Sort the screens so that we don't move one screens group onto the other
  # before we get the chance to move its group!
  for screen in sorted(
      qtile.screens,
      key=lambda s: group_names.index(s.group.name),
      reverse=(offset != 1 if screens_wrap else offset == 1)):
    group_idx = (
        (group_names.index(screen.group.name) + offset) % len(group_names))
    next_group_name = group_names[group_idx]
    # logger.error(f'pre {group_names.index(screen.group.name)} group index {group_idx} offset {offset}')
    # logger.error(f'cur_name {screen.group.name} new_name {next_group_name}')
    for group in qtile.groups:
      if group.name == next_group_name:
          screen.set_group(group)
          break

# Cycle through groups on all screens at once (like on chromeos)
keys.append(Key([mod, "control"], "l", lazy.function(movescreens, 1)))
keys.append(Key([mod, "control"], "h", lazy.function(movescreens, -1)))
# Switch multiple windows to screens at once.
keys.append(Key([mod, "control"], "1",
                lazy.group["s"].toscreen(0),
                lazy.group["d"].toscreen(1),
                ))
keys.append(Key([mod, "control"], "2",
                lazy.group["f"].toscreen(0),
                lazy.group["q"].toscreen(1),
                ))
keys.append(Key([mod, "control"], "3",
                lazy.group["w"].toscreen(0),
                lazy.group["e"].toscreen(1),
                ))
keys.append(Key([mod, "control"], "4",
                lazy.group["2"].toscreen(0),
                lazy.group["3"].toscreen(1),
                ))

layout_theme = {
    "border_width": 2,
    "fullscreen_border_width": 2,
    "max_border_width": 2,
    "margin": 3,
    "border_focus": colors['color10'],
    "border_normal": colors['background'],
}


# TODO get this to work to fix border coloring
def custom_configure_layout(self, client, screen_rect):
  """Position client based on order and sizes."""
  logger.warning('config')

  self.screen_rect = screen_rect

  # if no sizes or normalize flag is set, normalize
  if not self.relative_sizes or self.do_normalize:
    self.cmd_normalize(False)

  # if client not in this layout
  if not self.clients or client not in self.clients:
    client.hide()
    return

  # determine focus border-color
  if client.has_focus:
    # Make kitty window border darker in color, since kitty windows
    # are not dimmed by compton.
    # TODO make this work for the Monad3Col layout, not sure why it doesn't
    # work now
    if 'kitty' in client.window.get_wm_class():
      px = colors['color2']
    else:
      px = self.border_focus
  else:
    px = self.border_normal

  # single client - fullscreen
  if len(self.clients) == 1:
    client.place(
        self.screen_rect.x,
        self.screen_rect.y,
        self.screen_rect.width - 2 * self.single_border_width,
        self.screen_rect.height - 2 * self.single_border_width,
        self.single_border_width,
        px,
        margin=self.single_margin,
    )
    client.unhide()
    return
  cidx = self.clients.index(client)
  self._configure_specific(client, screen_rect, px, cidx)
  client.unhide()


custom_monad_3col = layout.MonadThreeCol(
    ratio=0.67, min_secondary_size=100, main_centered=False,
    new_client_position="after_current",
    # Strangely, change_size works for secondary window changes in pixels, and
    # change_ratio works for main window changes in percent of size.
    change_size=60, **layout_theme)
# See https://stackoverflow.com/a/46757134
# custom_monad_3col.configure = custom_configure_layout.__get__(
#     custom_monad_3col, layout.MonadThreeCol)


custom_monad_tall = layout.MonadTall(
    # This max_ratio is just enough for a 80-char wide vim window on a 1080p
    # screen.
    ratio=0.67, min_secondary_size=100,
    # Strangely, change_size works for secondary window changes in pixels, and
    # change_ratio works for main window changes in percent of size.
    change_size=60, **layout_theme)
# Another way to override the method, not currently working
# custom_monad_tall.configure = types.MethodType(
#     custom_configure_layout, custom_monad_tall)


layouts = [
    custom_monad_tall,
    layout.Max(**layout_theme),
    custom_monad_3col,
    # layout.Columns(name='2cols', num_columns=2, **layout_theme),
    # layout.Columns(name='3cols', num_columns=3, **layout_theme),
    # layout.Stack(name='2stack', num_stacks=2, **layout_theme),
    # layout.Stack(name='3stack', num_stacks=3, **layout_theme),
    # Try more layouts by unleashing below layouts.
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='FiraCode Bold',
    fontsize=12,
    padding=2,
    foreground=colors['color7'],
)
extension_defaults = widget_defaults.copy()

graph_args = dict(
    samples=100,
    graph_color=colors['color2'],
    fill_color=colors['color2'] + '.3',
    border_color=colors['background'] + '.5',
    width=40,
)


class ColoredMemoryGraph(MemoryGraph):
  """Shows the memory graph in red if above 80%."""

  def update_graph(self):
    val = self._getvalues()
    mem = val['MemTotal'] - val['MemFree'] - val['Buffers'] - val['Cached']
    if mem / val['MemTotal'] > 0.8:
      self.graph_color = colors['color1']
      self.fill_color = colors['color1'] + '.3'
    else:
      self.graph_color = colors['color2']
      self.fill_color = colors['color2'] + '.3'
    super().update_graph()


wireless_interface = subprocess.run(
    "ifconfig | grep wlp | awk '{print $1}' | tr -d :",
    shell=True, capture_output=True).stdout.decode('utf-8').strip()


def get_widgets():
  return [
      widget.GroupBox(
          disable_drag=True,
          highlight_method='line',
          highlight_color=['000000', colors['color2']],
          this_screen_border=colors['color10'],
          this_current_screen_border=colors['color2'],
          active=colors['color7']),
      widget.CurrentLayoutIcon(
          # custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
          scale=0.8,
      ),
      widget.WindowName(),
      widget.TextBox(" | ", name="separator"),
      widget.Clipboard(max_width=50, timeout=None),
      widget.TextBox(" | ", name="separator"),
      widget.TextBox("CPU", name="cpu_label"),
      widget.CPUGraph(**graph_args),
      widget.TextBox("Mem", name="memory_label"),
      ColoredMemoryGraph(**graph_args),
      widget.TextBox("Net", name="net_label"),
      widget.NetGraph(**graph_args),
      widget.TextBox(" | ", name="separator"),
      widget.DF(
          mouse_callbacks={'Button1': lambda: qtile.cmd_spawn('qdirstat')},
          format='{uf}/{s}{m} free on {p}',
          visible_on_warn=False),
      # TODO figure out why this doesn't work
      # widget.HDDBusyGraph(**graph_args),
      widget.TextBox(" | ", name="separator"),
      # widget.Image(filename='~/.config/qtile/icons/volume-icon.png',
      #              margin_y=4),
      widget.TextBox("vol:", name="volume_label"),
      widget.Volume(fmt='{}'),
      widget.TextBox(" | ", name="separator"),
      # widget.Image(filename='~/.config/qtile/icons/battery-icon.png'),
      widget.TextBox("bat:", name="battery_label"),
      widget.Battery(format='{percent:2.0%} {char}{watt:.1f}W',
                     charge_char='+', discharge_char='-',
                     update_interval=15,  # seconds
                     ),
      widget.TextBox(" | ", name="separator"),
      # widget.Image(filename='~/.config/qtile/icons/brightness-icon.png',
      #              margin_x=1,
      #              margin_y=4.5),
      widget.TextBox("brt:", name="brightness_label"),
      widget.Backlight(format='{percent: 2.0%}',
                       backlight_name='intel_backlight'),
      widget.TextBox(" | ", name="separator"),
      # Requires
      # sudo apt install libiw-dev
      # pip install iwlib
      widget.Wlan(
          interface=wireless_interface,
          format=' {essid} {quality}%',
          mouse_callbacks={
              'Button1': lambda: qtile.cmd_spawn('gnome-control-center network')}),
      widget.TextBox(" | ", name="separator"),
      widget.Systray(),
      widget.Clock(format='%Y-%m-%d %a %I:%M %p'),
  ]


bar_config = dict(
    size=24,
    opacity=0.8,
    background=colors['color16']

)


# Restart qtile when a new monitor is plugged in.
# @hook.subscribe.screen_change
# def restart_on_randr(qtile, ev):
#     qtile.cmd_restart()

# def run(cmdline):
#     subprocess.Popen(shlex.split(cmdline))
#
# @hook.subscribe.startup
# def startup():
#     run("~kovas/bin/setup-monitors.bash")

def get_monitors():
  display = xdisplay.Display()
  screen = display.screen()
  resources = screen.root.xrandr_get_screen_resources()
  return [display.xrandr_get_output_info(output, resources.config_timestamp)
          for output in resources.outputs]


# See https://github.com/qtile/qtile/wiki/screens
def get_num_monitors():
  num_monitors = 0
  try:
    for monitor in get_monitors():
      preferred = False
      if hasattr(monitor, "preferred"):
        preferred = monitor.preferred
      elif hasattr(monitor, "num_preferred"):
        preferred = monitor.num_preferred
      if preferred:
        num_monitors += 1
  except Exception:
    # always setup at least one monitor
    return 1
  else:
    return num_monitors


num_monitors = get_num_monitors()

bars = [bar.Bar(get_widgets(), **bar_config)]
screens = [Screen(top=bars[0])]

if num_monitors > 1:
  for m in range(num_monitors - 1):
    bars.append(bar.Bar(get_widgets(), **bar_config))
    screens.append(Screen(top=bars[-1]))


@hook.subscribe.startup
def _():
  for b in bars:
    b.window.window.set_property(
        'WM_NAME', 'qtile_bar', type='UTF8_STRING', format=8)


@hook.subscribe.client_new
def floating_dialogs(window):
  # logger.warning(str(window.window.get_wm_class()))
  # logger.warning(str(window.window.get_name()))
  # logger.warning(str(window.window.get_wm_type()))
  window_names = {'meet.google.com is sharing your screen.'}
  window_classes = {'Godot'}
  wclass = (window.window.get_wm_class()[1]
            if len(window.window.get_wm_class()) >= 2
            else '')
  if (wclass in window_classes or window.window.get_name() in window_names):
    window.floating = True


dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirm'),
    Match(wm_class='dialog'),
    Match(wm_class='download'),
    Match(wm_class='error'),
    Match(wm_class='file_progress'),
    Match(wm_class='notification'),
    Match(wm_class='splash'),
    Match(wm_class='toolbar'),
    Match(title='meet.google.com is sharing a window.'),
    Match(title='nvim-textarea'),
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    Match(wm_class='ssh-askpass'),  # ssh-askpass
])
auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
