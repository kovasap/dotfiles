import os
import socket
import shlex
import subprocess
import time
import types
from typing import List  # noqa: F401

from libqtile.command.base import expose_command
from libqtile import bar, hook, layout, widget
from libqtile import qtile
from libqtile.config import Click, Drag, Group, Key, KeyChord, Screen, Match
from libqtile.lazy import lazy
from libqtile.log_utils import logger

# If using pipx to install qtile, use `pipx inject qtile psutil xlib` to make
# sure these libraries are available.
# On systems where I cannot install psutil, this still allows qtile to run.
try:
  from libqtile.widget.graph import MemoryGraph
except ModuleNotFoundError:
  MemoryGraph = None
# On systems where I cannot install xlib, this still allows qtile to run.
try:
  from Xlib import display as xdisplay
except ModuleNotFoundError:
  xdisplay = None

# Log location is at ~/.local/share/qtile/qtile.log

@hook.subscribe.startup
def autostart():
    subprocess.call(os.path.expanduser('~/.config/qtile/autostart.sh'))

# I wish this worked... 
# @hook.subscribe.startup_complete
# def reset_monitors():
#     subprocess.call(['zsh', '-c', 'setup-monitors.bash forked &> ~/setup-monitors.log'])

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


# ----------------- Custom Group Logic ------------------------------------

def get_two_main_screens(qtile):
  second_screen_candidates = [
      s for s in qtile.screens if s != qtile.current_screen]
  return (
      qtile.current_screen,
      # TODO improve this:
      second_screen_candidates[-1] if second_screen_candidates else None
  )


def get_primary_secondary_groups(qtile, group_name):
  groups_by_name = {g.name: g for g in qtile.groups}
  return groups_by_name[group_name[0]], groups_by_name[group_name[0] + 'a']


# https://github.com/qtile/qtile/issues/1378#issuecomment-516111306
def group_to_screens(qtile, group_name):
  cur_screen, second_screen = get_two_main_screens(qtile)
  # If you want this fn to switch to the last group, uncomment this.
  # if group_name == cur_screen.group.name:
  #   group_name = cur_screen.previous_group.name
  primary_group, secondary_group = get_primary_secondary_groups(
      qtile, group_name)
  if group_name == cur_screen.group.name:
    swap_primary_secondary_screens(qtile)
  else:
    cur_screen.set_group(primary_group)
    if second_screen:
      second_screen.set_group(secondary_group)


def group_to_screen(qtile, group_name):
  cur_screen, second_screen = get_two_main_screens(qtile)
  primary_group, secondary_group = get_primary_secondary_groups(
      qtile, group_name)
  if group_name == cur_screen.group.name:
    cur_screen.set_group(secondary_group)
  else:
    cur_screen.set_group(primary_group)

def call_primary_or_secondary_group(qtile):
  """Makes it so that both primary and secondary groups are displayed on screens."""
  cur_screen, second_screen = get_two_main_screens(qtile)
  primary_group, secondary_group = get_primary_secondary_groups(
      qtile, cur_screen.group.name)
  cur_screen.set_group(primary_group)
  second_screen.set_group(secondary_group)

def swap_primary_secondary_screens(qtile):
  cur_screen, second_screen = get_two_main_screens(qtile)
  primary_group, secondary_group = get_primary_secondary_groups(
      qtile, cur_screen.group.name)
  if cur_screen.group.name == primary_group.name:
    cur_screen.set_group(secondary_group)
    if second_screen:
      second_screen.set_group(primary_group)
  else:
    cur_screen.set_group(primary_group)
    if second_screen:
      second_screen.set_group(secondary_group)


def window_to_group(qtile, n):
  cur_screen, _ = get_two_main_screens(qtile)
  primary_group, secondary_group = get_primary_secondary_groups(qtile, n)

  def cur_win_to_group(group_name):
    cur_screen.group.current_window.togroup(group_name, switch_group=False)

  if cur_screen.group.name == primary_group.name:
    cur_win_to_group(secondary_group.name)
  elif cur_screen.group.name == secondary_group.name:
    cur_win_to_group(primary_group.name)
  else:
    cur_win_to_group(n)


# --------------------------------------------------------------------------


mod = 'mod4'


# Options at https://dunst-project.org/documentation/#COLORS
notify_opts = (
    '-t 1500 '
    f'-h string:bgcolor:{colors["background"]} '
    f'-h string:frcolor:{colors["background"]} '
    f'-h string:fgcolor:{colors["foreground"]} '
)
notify_vol_cmd = (
    f'notify-send -h string:x-dunst-stack-tag:vol {notify_opts} '
    '"volume $(amixer get Master | egrep -o \'\\[(.*)\')"')
notify_brightness_cmd = (
    f'notify-send -h string:x-dunst-stack-tag:brt {notify_opts} '
    '"brightness $(cat /sys/class/backlight/intel_backlight/brightness)"')


def spawn_multi_cmd(*args):
  return lazy.spawn(['zsh', '-c', '; '.join(args)])


keys = []

group_letters = 'jluymnei'
groups = []
for n in group_letters:
  groups.append(Group(n))
  groups.append(Group(n + 'a'))
  keys.extend([
      # mod1 + letter of group = switch to group
      Key([mod], n, lazy.function(group_to_screens, n)),
      Key([mod, 'control'], n, lazy.function(group_to_screen, n)),

      # mod1 + shift + letter of group = move focused window to group
      # Key([mod, 'shift'], n, lazy.window.window_to_group(n, switch_group=False)),
      Key([mod, 'shift'], n, lazy.function(window_to_group, n)),
  ])

def movescreens(qtile, offset):
  # Make it so that when we are moving screens we are always doing so with a
  # group pair.
  try:
    call_primary_or_secondary_group(qtile)
  except Exception:
    # If this breaks, proceed anyway
    pass
  group_names = [g.name for g in groups]
  screen_group_names = [s.group.name for s in qtile.screens]
  screens_wrap = (group_names[-1] in screen_group_names
                  and group_names[0] in screen_group_names)
  # Sort the screens so that we don't move one screens group onto the other
  # before we get the chance to move its group!
  for screen in sorted(
      qtile.screens,
      key=lambda s: group_names.index(s.group.name),
      reverse=(offset < 0 if screens_wrap else offset > 0)):
    group_idx = (
        (group_names.index(screen.group.name) + offset) % len(group_names))
    next_group_name = group_names[group_idx]
    # logger.error(f'pre {group_names.index(screen.group.name)} group index {group_idx} offset {offset}')
    # logger.error(f'cur_name {screen.group.name} new_name {next_group_name}')
    for group in qtile.groups:
      if group.name == next_group_name:
        screen.set_group(group)
        break

def window_to_paired_group(qtile):
  cur_screen, _ = get_two_main_screens(qtile)
  if len(cur_screen.group.name) == 2:
    target_group_name = cur_screen.group.name[0]
  else:
    target_group_name = cur_screen.group.name + 'a'
  cur_screen.group.current_window.togroup(target_group_name, switch_group=False)

def window_to_paired_group_then_swap(qtile):
  window_to_paired_group(qtile)
  swap_primary_secondary_screens(qtile)

def window_to_adjacent_group_pair(qtile, offset):
  cur_screen, _ = get_two_main_screens(qtile)
  cur_group_letter = cur_screen.group.name[0]
  cur_group_idx = group_letters.index(cur_group_letter) 
  next_group_idx = cur_group_idx + offset
  if next_group_idx >= len(group_letters):
    next_group_idx = next_group_idx - len(group_letters)
  elif next_group_idx < 0:
    next_group_idx = len(group_letters) + next_group_idx
  next_group_letter = group_letters[next_group_idx]
  cur_screen.group.current_window.togroup(next_group_letter, switch_group=False)
  movescreens(qtile, offset * 2)

def get_float_drag_position(qtile):
  # TODO make it so that this code always ensures that the mouse cursor is in
  # the floating window when dragging, preferring to not move the window to the
  # mouse cursor location, but doing so if necessary
  cur_window = qtile.current_screen.group.current_window
  return (qtile.core.get_mouse_position()[0] - 200,
          qtile.core.get_mouse_position()[1] - 200)

mouse = [
    # Drag windows around.
    Drag([mod], 'Button1', lazy.window.set_position_floating(),
         start=lazy.function(get_float_drag_position)),
    Click([mod], 'Button1', lazy.window.enable_floating()),
    Click([mod], 'Button3', lazy.window.disable_floating()),
    Drag([mod], 'Button2', lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Drag([mod, 'control'], 'Button3', lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    # Rearrange and resize windows with mouse wheel
    # For MonadTall layout
    Click([mod], 'Button4', lazy.layout.grow()),
    Click([mod], 'Button5', lazy.layout.shrink()),
    Click([mod, 'control'], 'Button5', lazy.layout.shuffle_down_wraparound()),
    Click([mod, 'control'], 'Button4', lazy.layout.shuffle_up_wraparound()),
    Click([mod], 'Button9', lazy.function(window_to_paired_group)),
    Click([mod], 'Button8', lazy.function(swap_primary_secondary_screens)),
]


# Key name reference:
# https://github.com/qtile/qtile/blob/master/libqtile/backend/x11/xkeysyms.py
keys.extend([
    Key([mod], 't', lazy.group.next_window()),
    Key([mod, 'control'], 't', lazy.group.prev_window()),

    Key([mod], 's', lazy.layout.shuffle_up_wraparound()),
    Key([mod, 'control'], 's', lazy.layout.shuffle_down_wraparound()),

    Key([mod], 'Tab', lazy.prev_screen()),

    Key([mod], 'a', lazy.function(window_to_paired_group)),
    Key([mod, 'control'], 'a', lazy.function(window_to_paired_group_then_swap)),

    Key([mod], 'g', lazy.layout.flip()),

    # Cycle through groups on all screens at once (like on chromeos)
    Key([mod], 'f', lazy.function(movescreens, -2)),
    Key([mod], 'Left', lazy.function(movescreens, -2)),
    Key([mod], 'p', lazy.function(movescreens, 2)),
    Key([mod], 'Right', lazy.function(movescreens, 2)),

    # Carry a window to the next group pairing
    Key([mod], 'r', lazy.function(window_to_adjacent_group_pair, 1)),
    Key([mod], 'x', lazy.function(window_to_adjacent_group_pair, -1)),

    Key([mod], 'q', lazy.function(swap_primary_secondary_screens)),

    # Skip managed ignores groups already on a screen.
    # Key([mod], 'o', lazy.screen.toggle_group()),
    Key([mod], 'comma', lazy.layout.grow()),
    Key([mod], 'period', lazy.layout.shrink()),
    Key([mod], 'bracketright', lazy.layout.maximize()),
    Key([mod], 'bracketleft', lazy.layout.minimize()),

    Key([mod], 'b', lazy.window.kill()),
    Key([mod], 'BackSpace', lazy.window.kill()),

    # This part is not working for some reason at the moment.  I think it
    # works when i switch away from the image clipboard content and back
    # to it with copyq.
    # 'xclip –selection clipboard –t image/png –o > ~/clipboard.png'])),
    # Take an entire screenshot:
    # lazy.spawn('scrot -s -e 'mv $f ~/pictures/screenshots/'')
    Key([mod],
        'space',
        lazy.widget['keyboardlayout'].next_keyboard(),
        desc='Next keyboard layout.'),
    Key([mod, 'control'], 'space', lazy.hide_show_bar(), desc='Hides the bar'),

    Key([mod], 'slash', lazy.spawn("kitty zsh -c 'chrome-history.zsh'")),
    Key([mod, 'control'], 'slash',
        lazy.spawn("kitty zsh -c 'chrome-history.zsh 1'")),
    Key([mod], 'c', lazy.spawn('copyq next')),
    Key([mod], 'd', lazy.spawn('copyq previous')),
    Key([mod], 'v', lazy.spawn('copyq menu')),
    Key([mod], 'z',
        spawn_multi_cmd(
            'setup-monitors.bash forked &> ~/setup-monitors.log')),
    Key([mod, 'control'], 'z',
        spawn_multi_cmd(
            'setup-monitors.bash forked rotated &> ~/setup-monitors.log')),
    Key([mod], 'Escape', lazy.spawn('screensaver.sh')),

    # Key([mod], 'u', lazy.spawn('kitty /bin/zsh -c dl-and-play-yt.bash')),
    Key([mod], 'o', lazy.spawn('nvim-textarea.bash')),

    # Open text prompt to open any program on the system
    Key([mod], 'grave', lazy.spawn('j4-dmenu-desktop')),
    # Open xmenu for a visual way to open programs
    Key([mod], 'Delete', lazy.spawn('run-xmenu.sh')),
    # Open programs with a keychord
    KeyChord([mod], 'w', [
        Key([mod], 't', lazy.spawn("kitty env RUN='cd $(< ~/lastdir)' zsh")),
        Key([mod], 'c', lazy.spawn('google-chrome-stable')),
        Key([mod], 'f', lazy.spawn('thunar')),
        Key([mod], 's', lazy.spawn('steam')),
        Key([mod], 'g', lazy.spawn('strawberry')),
    ]),

    # If this binding is changed, make sure to also change the reference to it
    # in setup-monitors.bash.
    Key([mod, 'shift'], 'Escape', lazy.function(lambda qt: qt.restart())),
    Key([mod, 'control'], 'Escape',lazy.restart()),
    Key([mod, 'control'], 'Tab', lazy.shutdown()),

    # Audio
    Key([], 'XF86AudioRaiseVolume',
        spawn_multi_cmd('amixer sset Master 5%+', notify_vol_cmd)),
    Key([], 'XF86AudioLowerVolume',
        spawn_multi_cmd('amixer sset Master 5%-', notify_vol_cmd)),
    Key([], 'XF86AudioMute',
        spawn_multi_cmd('amixer sset Master toggle', notify_vol_cmd)),
    # This is way harder than it should be
    # Key([mod],
    #     'leftsinglequotemark',  # 'XF86AudioPlay',
    #     lazy.spawn('clementine --play-pause')),
    # Key([mod],
    #     'thorn',  # 'XF86AudioPrev',
    #     lazy.spawn('clementine --previous')),
    # Key([mod],
    #     'rightsinglequotemark',  # 'XF86AudioNext',
    #     lazy.spawn('clementine --next')),

    # Brightness
    Key([], 'XF86MonBrightnessUp',
        spawn_multi_cmd('brightness.sh up', notify_brightness_cmd)),
    Key([], 'XF86MonBrightnessDown',
        spawn_multi_cmd('brightness.sh down', notify_brightness_cmd)),

    # Run this command to make an image file from the screenshot:
    # xclip –selection clipboard –t image/png –o > /tmp/nameofyourfile.png
    Key(
        [],
        'Print',
        spawn_multi_cmd(
            # https://github.com/naelstrof/maim/issues/182
            'pkill picom',
            'maim -s | tee ~/clipboard.png | '
            'xclip -selection clipboard -t image/png; ')),   
])

# @hook.subscribe.client_focus
# def client_focused(client):
#     client.bring_to_front()
# 
# @hook.subscribe.client_mouse_enter
# def client_mouse_enter(client):
#   client.group.focus(client)
# 
# @hook.subscribe.current_screen_change
# def screen_change():
#   cur_window = qtile.current_screen.group.current_window
#   cur_window.group.focus(cur_window)

follow_mouse_focus = True

layout_theme = {
    'border_width': 2,
    'fullscreen_border_width': 2,
    'max_border_width': 2,
    'margin': 3,
    'border_focus': colors['color10'],
    'border_normal': colors['background'],
}


# TODO get this to work to fix border coloring
def custom_configure_layout(self, client, screen_rect):
  """Position client based on order and sizes."""
  logger.warning('config')

  self.screen_rect = screen_rect

  # if no sizes or normalize flag is set, normalize
  if not self.relative_sizes or self.do_normalize:
    self.normalize(False)

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
    new_client_position='after_current',
    # Strangely, change_size works for secondary window changes in pixels, and
    # change_ratio works for main window changes in percent of size.
    change_size=60, **layout_theme)
# See https://stackoverflow.com/a/46757134
# custom_monad_3col.configure = custom_configure_layout.__get__(
#     custom_monad_3col, layout.MonadThreeCol)


class CustomMonadTall(layout.MonadTall):

  @expose_command()
  def shuffle_up_wraparound(self):
      """Shuffle the client up the stack, or all the way around if at the end"""
      idx = self.clients._current_idx
      if idx > 0:
        new_idx = idx - 1
      else:
        new_idx = len(self.clients.clients) - 1
      self.clients.clients[idx], self.clients.clients[new_idx] = (
          self.clients.clients[new_idx], self.clients.clients[idx])
      self.clients.current_index = new_idx
      self.group.layout_all()
      self.group.focus(self.clients.current_client)

  @expose_command()
  def shuffle_down_wraparound(self):
      """Shuffle the client down the stack, or all the way around if at the end"""
      idx = self.clients._current_idx
      if idx + 1 < len(self.clients):
        new_idx = idx + 1
      else:
        new_idx = 0 
      self.clients.clients[idx], self.clients.clients[new_idx] = (
          self.clients.clients[new_idx], self.clients.clients[idx])
      self.clients.current_index = new_idx
      self.group.layout_all()
      self.group.focus(self.clients.current_client)

  # This is an attempt to solve the problem where when dragging a window
  # between different screens, the window appears behind existing windows on
  # the screen already.
  # def add_client(self, client) -> None:  # type: ignore[override]
  #     "Add client to layout"
  #     self.clients.add_client(client, client_position=self.new_client_position)
  #     self.do_normalize = True
  #     self.focus(client)
  #     client.bring_to_front()


custom_monad_tall = CustomMonadTall(
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
    # layout.Max(**layout_theme),
    # layout.Floating(**layout_theme),
    # layout.Zoomy(
    #   columnwidth=20,
    #   **layout_theme),
    # custom_monad_3col,
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
    foreground=colors['color8'],
)


if MemoryGraph is not None:
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
    "ifconfig | grep wl | awk '{print $1}' | tr -d :",
    shell=True, capture_output=True).stdout.decode('utf-8').strip()


def get_widgets(systray=False):
  return [
      widget.TextBox('<->', name='swap windows',
                     markup=False,
        foreground=colors['color3'],
        mouse_callbacks={'Button1': lambda: swap_primary_secondary_screens(qtile)}),
      widget.GroupBox(disable_drag=True,
                      highlight_method='line',
                      highlight_color=['000000', colors['color2']],
                      this_screen_border=colors['color10'],
                      this_current_screen_border=colors['color2'],
                      active=colors['color7']),
      widget.TextBox('|<-', name='move window left',
                     markup=False,
        foreground=colors['color3'],
        mouse_callbacks={'Button1': lambda: window_to_adjacent_group_pair(qtile, -1)}),
      widget.TextBox('->|', name='move window right',
                     markup=False,
        foreground=colors['color3'],
        mouse_callbacks={'Button1': lambda: window_to_adjacent_group_pair(qtile, 1)}),
      # widget.CurrentLayoutIcon(
      #     # custom_icon_paths=[os.path.expanduser('~/.config/qtile/icons')],
      #     scale=0.8,),
      widget.WindowName(
        mouse_callbacks={'Button3': lambda: qtile.spawn(os.path.expanduser('~/bin/run-xmenu.sh'))}),
      widget.TextBox('X',
                     foreground=colors['color1'],
                     mouse_callbacks={'Button1': lazy.window.kill()}),
      widget.TextBox(' | ', name='separator'),
      widget.Clipboard(
        foreground=colors['color2'],
        mouse_callbacks={'Button3': lambda: qtile.spawn('copyq menu')},
        max_width=50, timeout=None),
      widget.TextBox(' | ', name='separator'),
      widget.TextBox('CPU', name='cpu_label',
                     foreground=colors['color8'],
                     mouse_callbacks={'Button1': lambda: qtile.spawn("kitty zsh -c 'htop'")}),
      widget.CPUGraph(mouse_callbacks={'Button1': lambda: qtile.spawn("kitty zsh -c 'htop'")}, **graph_args),
      widget.ThermalSensor(tag_sensor='Tdie', threshold=85,
                           foreground=colors['color8'],
                           mouse_callbacks={'Button1': lambda: qtile.spawn("kitty zsh -c 'sensors; zsh'")}
                           ),
      widget.TextBox(' | ', name='separator'),
      widget.TextBox('Mem',
                     foreground=colors['color8'],
                     name='memory_label',
                     mouse_callbacks={'Button1': lambda: qtile.spawn("kitty zsh -c 'htop'")})
      ] + ([ColoredMemoryGraph(mouse_callbacks={'Button1': lambda: qtile.spawn("kitty zsh -c 'htop'")}, **graph_args)] if MemoryGraph is not None else []) + [
      # widget.TextBox('Net', name='net_label'),
      # widget.NetGraph(**graph_args),
      widget.TextBox(' | ', name='separator'),
      widget.DF(
          foreground=colors['color8'],
          mouse_callbacks={'Button1': lambda: qtile.spawn('qdirstat')},
          format='{uf}/{s}{m} free on {p}',
          visible_on_warn=False),
      # TODO figure out why this doesn't work
      # widget.HDDBusyGraph(**graph_args),
      # widget.TextBox(' | ', name='separator'),
      # # widget.Image(filename='~/.config/qtile/icons/volume-icon.png',
      # #              margin_y=4),
      # widget.TextBox('vol:', name='volume_label'),
      # widget.Volume(fmt='{}'),
      ] + ([
      widget.TextBox(' | ', name='separator'),
      # widget.Image(filename='~/.config/qtile/icons/battery-icon.png'),
      widget.TextBox('bat:', name='battery_label'),
      widget.Battery(
          format='{percent:2.0%} {char}{watt:.1f}W',
          charge_char='+',
          discharge_char='-',
          update_interval=15,  # seconds
      ),
      ] if socket.gethostname() != 'frostyarch' else []) + [
      # widget.TextBox(' | ', name='separator'),
      # # widget.Image(filename='~/.config/qtile/icons/brightness-icon.png',
      # #              margin_x=1,
      # #              margin_y=4.5),
      # widget.TextBox('brt:', name='brightness_label'),
      # widget.Backlight(format='{percent: 2.0%}',
      #                  backlight_name='intel_backlight'),
      # widget.TextBox(' | ', name='separator'),
      # Am currently using nm-applet instead.
      # Requires
      # sudo apt install libiw-dev
      # pip install iwlib
      # widget.Wlan(
      #     interface=wireless_interface,
      #     format=' {essid} {quality}%',
      #     mouse_callbacks=dict(
      #         Button1=lambda: qtile.spawn('gnome-control-center network'))),
      widget.TextBox(' | ', name='separator'),
      widget.KeyboardLayout(
          foreground=colors['color8'],
          # Colemak is useful on a normal keyboard (like a laptop keyboard).
          configured_keyboards=(['us colemak_dh', 'us']
                                if socket.gethostname() != 'frostyarch' else 
                                ['us', 'us colemak_dh']),
          display_map={
              'us': 'qw',
              'us colemak_dh': 'cl'
          }),
      widget.TextBox(' | ', name='separator'),
  ] + ([widget.Systray()] if systray else []) + [
      widget.TextBox(' | ', name='separator'),
      widget.Clock(
        format='%Y-%m-%d %a %I:%M %p'),
  ]


bar_config = dict(
    size=24,
    opacity=0.8,
    background=colors['color16']
)


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
      if hasattr(monitor, 'preferred'):
        preferred = monitor.preferred
      elif hasattr(monitor, 'num_preferred'):
        preferred = monitor.num_preferred
      if preferred:
        num_monitors += 1
  except Exception:
    # always setup at least one monitor
    return 1
  else:
    return num_monitors


num_monitors = get_num_monitors()
logger.warning(f'num_monitors: {num_monitors}')
num_monitors = 3  # TODO remove this hack that fixes bars not being present on all monitors

bars = [bar.Bar(get_widgets(systray=True), **bar_config)]
screens = [Screen(top=bars[0])]

if num_monitors > 1:
  for m in range(num_monitors - 1):
    bars.append(bar.Bar(get_widgets(), **bar_config))
    screens.append(Screen(top=bars[-1]))


# I think this is a fix for some utf8 locale issues.
# If you find this later commented out and everything is working just delete
# it.
# @hook.subscribe.startup
# def _():
#   for b in bars:
#     b.window.window.set_property(
#         'WM_NAME', 'qtile_bar', type='UTF8_STRING', format=8)


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
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
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
        Match(title='Tempo Launcher'),
        Match(title='meet.google.com is sharing a window.'),
        # Match(title='nvim-textarea'),
        Match(wm_class='confirmreset'),  # gitk
        Match(wm_class='makebranch'),  # gitk
        Match(wm_class='maketag'),  # gitk
        Match(title='branchdialog'),  # gitk
        Match(title='pinentry'),  # GPG key password entry
        Match(wm_class='ssh-askpass'),  # ssh-askpass
    ],
    border_focus=colors['color11'],
)
# auto_fullscreen = True
focus_on_window_activation = 'smart'

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = 'LG3D'
