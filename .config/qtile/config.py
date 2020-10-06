# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
import os
import subprocess
from typing import List  # noqa: F401

from Xlib import display as xdisplay
import shlex

from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.lazy import lazy
from libqtile import layout, bar, widget, hook

# Log location is at ~/.local/share/qtile/qtile.log
from libqtile.log_utils import logger


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
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "j", lazy.layout.down()),

    # Skip managed ignores groups already on a screen.
    Key([mod], "h", lazy.screen.prev_group(skip_managed=True, skip_empty=True)),
    Key([mod], "l", lazy.screen.next_group(skip_managed=True, skip_empty=True)),

    Key([mod], "comma", lazy.prev_screen()),
    Key([mod], "period", lazy.next_screen()),
    Key([mod], "x", lazy.swap_screens()),

    Key([mod, "shift"], "h", lazy.layout.swap_left()),
    Key([mod, "shift"], "l", lazy.layout.swap_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),

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

    # ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s -e 'mv $f ~/pictures/screenshots/'")
    # , ((0, xK_Print), spawn "scrot -e 'mv $f ~/pictures/screenshots/'")

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next()),

    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate()),

    Key([mod], "t", lazy.window.toggle_floating()),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split()),

    Key([mod], "c", lazy.spawn('copyq next')),
    Key([mod], "v", lazy.spawn('copyq previous')),
    Key([mod], "b", lazy.spawn('copyq menu')),

    Key([mod], "Escape", lazy.spawn("screensaver.sh")),
    Key([mod, 'shift'], "Escape", lazy.spawn("systemctl suspend")),
    Key([mod], "Return", lazy.spawn("kitty")),
    Key([mod, 'shift'], "Return",
        lazy.spawn("kitty /bin/zsh -c -i sd")),
    Key([mod], "backslash", lazy.spawn("google-chrome")),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout()),
    Key([mod], "w", lazy.window.kill()),

    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "t", lazy.function(hard_restart)),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "r", lazy.spawn("j4-dmenu-desktop")),
]

groups = [Group(i) for i in "asdfuiop"]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen()),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=False)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
    ])

layout_theme = {
    "border_width": 2,
    "fullscreen_border_width": 2,
    "max_border_width": 2,
    "margin": 3,
    "border_focus": colors['color10'],
    "border_normal": colors['background'],
}

class CustomMonadTall(layout.MonadTall):
    def configure(self, client, screen):
        """Position client based on order and sizes."""
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
            if 'kitty' in client.window.get_wm_class():
                px = self.group.qtile.color_pixel(colors['color2'])
            else:
                px = self.group.qtile.color_pixel(self.border_focus)
        else:
            px = self.group.qtile.color_pixel(self.border_normal)

        # single client - fullscreen
        if len(self.clients) == 1:
            client.place(
                self.group.screen.dx,
                self.group.screen.dy,
                self.group.screen.dwidth - 2 * self.single_border_width,
                self.group.screen.dheight - 2 * self.single_border_width,
                self.single_border_width,
                px,
                margin=self.single_margin,
            )
            client.unhide()
            return
        cidx = self.clients.index(client)
        self._configure_specific(client, screen, px, cidx)
        client.unhide()

layouts = [
    # This max_ratio is just enough for a 80-char wide vim window on a 1080p
    # screen.
    CustomMonadTall(ratio=0.67, min_secondary_size=100, **layout_theme),
    layout.Max(**layout_theme),
    # layout.Stack(num_stacks=2, **layout_theme),
    # Try more layouts by unleashing below layouts.
    # layout.Bsp(),
    # layout.Columns(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()

graph_args = dict(
    samples=100,
    graph_color=colors['color2'],
    fill_color=colors['color2'] + '.3',
    border_color=colors['background'] + '.5',
    width=40,
)

def qdirstat_callback(qt):
    logger.warning('qditstating')
    return subprocess.Popen('qdirstat', shell=True)


def get_widgets():
    return [
        widget.CurrentLayout(),
        widget.GroupBox(),
        widget.WindowName(),
        widget.TextBox(" | ", name="separator"),
        widget.Clipboard(max_width=50, timeout=None),
        widget.TextBox(" | ", name="separator"),
        widget.TextBox("CPU", name="cpu_label"),
        widget.CPUGraph(**graph_args),
        widget.TextBox("Mem", name="memory_label"),
        widget.MemoryGraph(**graph_args),
        widget.TextBox("Net", name="net_label"),
        widget.NetGraph(**graph_args),
        widget.TextBox(" | ", name="separator"),
        widget.DF(mouse_callbacks={'Button1': qdirstat_callback},
                  format='{uf}/{s}{m} free on {p}',
                  visible_on_warn=False),
        # TODO figure out why this doesn't work
        # widget.HDDBusyGraph(**graph_args),
        widget.TextBox(" | ", name="separator"),
        widget.TextBox("Vol", name="volume_label"),
        widget.Volume(),
        widget.TextBox(" | ", name="separator"),
        widget.Battery(format='Bat {percent:2.0%} {char}{watt:.1f}W',
                       charge_char='+', discharge_char='-',
                       update_interval=15,  # seconds
                       ),
        widget.TextBox(" | ", name="separator"),
        widget.Backlight(format='Brt {percent: 2.0%}',
                         backlight_name='intel_backlight'),
        widget.TextBox(" | ", name="separator"),
        widget.Systray(),
        widget.Clock(format='%Y-%m-%d %a %I:%M %p'),
    ]

bar_config = dict(
    size=24,
    opacity=0.8
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
    except Exception as e:
        # always setup at least one monitor
        return 1
    else:
        return num_monitors

num_monitors = get_num_monitors()

screens = [Screen(top=bar.Bar(get_widgets(), **bar_config))]

if num_monitors > 1:
    for m in range(num_monitors - 1):
        screens.append(
            Screen(top=bar.Bar(get_widgets(), **bar_config))
        )
logger.warning(screens)

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

@hook.subscribe.client_new
def floating_dialogs(window):
    # logger.warning(str(window.window.get_wm_class()))
    # logger.warning(str(window.window.get_name()))
    # logger.warning(str(window.window.get_wm_type()))
    if 'Godot' == window.window.get_wm_class()[1]:
        window.floating = True

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    {'wmclass': 'confirm'},
    {'wmclass': 'dialog'},
    {'wmclass': 'download'},
    {'wmclass': 'error'},
    {'wmclass': 'file_progress'},
    {'wmclass': 'notification'},
    {'wmclass': 'splash'},
    {'wmclass': 'toolbar'},
    {'wname': 'meet.google.com is sharing a window.'},
    {'wmclass': 'confirmreset'},  # gitk
    {'wmclass': 'makebranch'},  # gitk
    {'wmclass': 'maketag'},  # gitk
    {'wname': 'branchdialog'},  # gitk
    {'wname': 'pinentry'},  # GPG key password entry
    {'wmclass': 'ssh-askpass'},  # ssh-askpass
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
