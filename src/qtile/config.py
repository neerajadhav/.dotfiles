# Import necessary modules
from libqtile import bar, layout, widget, extension, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
import os
import subprocess

# don't forget to `chmod +x autostart.sh`
@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~")
    subprocess.call([home + "/.config/qtile/autostart.sh"])

mod = "mod4"
mod = "mod4"
mod = "mod4"
mod1 = "alt"
mod2 = "control"
browser = "brave"
terminal = "alacritty -o font.size=8"
fileManager = "thunar"
editor = "code"

keys = [
    # Switch between windows in current stack pane
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Up", lazy.layout.up()),
    # Move windows up or down in the stack
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
    # Resize windows
    Key([mod], "Left", lazy.layout.grow_left()),
    Key([mod], "Right", lazy.layout.grow_right()),
    Key([mod, "shift"], "Left", lazy.layout.shrink_left()),
    Key([mod, "shift"], "Right", lazy.layout.shrink_right()),
    # Switch window focus to other pane(s) of the stack
    Key([mod], "space", lazy.layout.next()),
    # Swap panes of split stack
    Key([mod, "shift"], "space", lazy.layout.rotate()),
    # Toggle between different layouts
    Key([mod], "Tab", lazy.next_layout()),
    # Kill focused window
    Key([mod], "q", lazy.window.kill()),
    # Restart Qtile
    Key([mod, "control"], "r", lazy.restart()),
    # Logout/Shutdown
    Key([mod, "control"], "q", lazy.shutdown()),
    # Spawn terminal
    Key([mod], "Return", lazy.spawn(terminal)),
    # Spawn browser
    Key([mod], "b", lazy.spawn(browser)),
    # Spawn editor
    Key([mod], "e", lazy.spawn(editor)),
    # Spawn fileManager
    Key([mod], "f", lazy.spawn(fileManager)),
    # Toggle between different screen configurations (if you have multiple monitors)
    Key([mod], "x", lazy.to_screen(0)),
    Key([mod], "y", lazy.to_screen(1)),
    # Increase volume
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -q sset Master 5%+")),
    # Decrease volume
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -q sset Master 5%-")),
    # Toggle mute
    Key([], "XF86AudioMute", lazy.spawn("amixer -q sset Master toggle")),
    # Increase brightness
    Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight -inc 10")),
    # Decrease brightness
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -dec 10")),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key(
        ["mod4"],
        "d",
        lazy.run_extension(
            extension.DmenuRun(
                dmenu_prompt="Run:",
                dmenu_font="Ubuntu mono",
                dmenu_lines=10,
            )
        ),
    ),
    Key(
        [mod],
        "p",
        lazy.run_extension(
            extension.CommandSet(
                commands={
                    "shutdown": "shutdown now",
                    "reboot": "reboot",
                    "logout": "qtile cmd-obj -o cmd -f shutdown",
                },
                dmenu_prompt="Power:",
                dmenu_font="Ubuntu mono",
                dmenu_lines=10,
            )
        ),
    ),
]

group_names = [
    ("1", {"layout": "monadtall"}),
    ("2", {"layout": "max"}),
    ("3", {"layout": "monadtall"}),
    ("4", {"layout": "monadtall"}),
    ("5", {"layout": "monadtall"}),
    ("6", {"layout": "monadtall"}),
    ("7", {"layout": "monadtall"}),
    ("8", {"layout": "monadtall"}),
    ("9", {"layout": "monadtall"}),
]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )

layout_theme = {
    "border_width": 3,
    "margin": 10,
    "border_focus": "ffffff",
    "border_normal": "cccccc",
}

layouts = [
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    # layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(**layout_theme),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    layout.TreeTab(**layout_theme),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="sans",
    fontsize=12,
    padding=5,
)
extension_defaults = widget_defaults.copy()

volume_widget = widget.Volume(
    emoji=False,
    update_interval=0.1,
    fmt="Vol: {}",
)

battery_widget = widget.Battery(
    energy_now_file="energy_now",
    energy_full_file="energy_full",
    power_now_file="power_now",
    charge_char="⚡",
    discharge_char="",
    update_delay=0.1,
    format="Bat: {char}{percent:2.0%}",
)

logo_widget = widget.Image(
    filename="~/.config/qtile/garuda.png",
    scale="False",
    margin=6,
    mouse_callbacks={
        "Button1": lazy.run_extension(
            extension.DmenuRun(
                dmenu_prompt="Run:",
                dmenu_font="Ubuntu mono",
                dmenu_lines=10,
            )
        ),
    },
)

screens = [
    Screen(
        top=bar.Bar(
            [
                logo_widget,
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                volume_widget,
                battery_widget,
                widget.Systray(),
                widget.Clock(format="%d-%m-%Y %a %I:%M %p"),
            ],
            24,
            margin = [10, 10, 0, 10],
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
