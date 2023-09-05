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


# Define mod key (Windows key)
mod = "mod4"
mod = "mod4"
mod1 = "alt"
mod2 = "control"
browser = "brave"
terminal = "alacritty -o font.size=8"
fileManager = "thunar"
editor = "code"

colors = [
    ["#282c34", "#282c34"],
    ["#1c1f24", "#1c1f24"],
    ["#dfdfdf", "#dfdfdf"],
    ["#ff6c6b", "#ff6c6b"],
    ["#98be65", "#98be65"],
    ["#da8548", "#da8548"],
    ["#51afef", "#51afef"],
    ["#c678dd", "#c678dd"],
    ["#46d9ff", "#46d9ff"],
    ["#a9a1e1", "#a9a1e1"],
]

# Define key bindings
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
    Key([mod], "w", lazy.window.kill()),
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
    # Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key(
        ["mod4"],
        "d",
        lazy.run_extension(
            extension.DmenuRun(
                dmenu_prompt="Run:",
                dmenu_font="Ubuntu mono",
                foreground=colors[2],
                background=colors[0],
                selected_background=colors[2],
                selected_foreground=colors[2],
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
                foreground=colors[2],
                background=colors[0],
                selected_background=colors[2],
                selected_foreground=colors[2],
                dmenu_lines=10,
            )
        ),
    ),
]

# Define groups
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

for i, (name, kwargs) in enumerate(group_names, 1):
    keys.extend(
        [
            # Switch to group
            Key([mod], str(i), lazy.group[name].toscreen()),
            # Send window to group
            Key([mod, "shift"], str(i), lazy.window.togroup(name)),
        ]
    )

# Define widget settings
widget_defaults = dict(
    font="mononoki Nerd Font",
    fontsize=12,
    padding=3,
)

extension_defaults = widget_defaults.copy()

# Define floating layouts
floating_layout = layout.Floating(
    float_rules=[
        {"wmclass": "confirm"},
        {"wmclass": "dialog"},
        {"wmclass": "download"},
        {"wmclass": "error"},
        {"wmclass": "file_progress"},
        {"wmclass": "notification"},
        {"wmclass": "splash"},
        {"wmclass": "toolbar"},
        {"wmclass": "confirmreset"},
        {"wmclass": "makebranch"},
        {"wmclass": "maketag"},
        {"wname": "branchdialog"},
        {"wname": "pinentry"},
        {"wname": "ssh-askpass"},
    ]
)

# Define mouse bindings
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# Define floating window settings
floating_layout = layout.Floating(
    float_rules=[
        # Add your custom rules here
    ],
    border_focus="#ff0000",
)

# Modify the widget.Volume() widget
volume_widget = widget.Volume(
    emoji=False,
    update_interval=0.1,
    fmt="Vol: {}",
    foreground=colors[9],
    background=colors[0],
)

battery_widget = widget.Battery(
    energy_now_file="energy_now",
    energy_full_file="energy_full",
    power_now_file="power_now",
    charge_char="⚡",
    discharge_char="",
    update_delay=0.1,
    format="Bat: {char}{percent:2.0%}",
    foreground=colors[4],
    background=colors[0],
)

separator = widget.Sep(
    linewidth=0,
    padding=6,
    foreground=colors[2],
    background=colors[0],
)

# Define the bar
screens = [
    Screen(
        top=bar.Bar(
            [
                separator,
                widget.Image(
                    filename="~/.config/qtile/garuda.png",
                    scale="False",
                    margin=6,
                    foreground=colors[2],
                    background=colors[0],
                    mouse_callbacks={
                        "Button1": lazy.run_extension(
                            extension.DmenuRun(
                                dmenu_prompt="Run:",
                                dmenu_font="Ubuntu mono",
                                foreground=colors[2],
                                background=colors[0],
                                selected_background=colors[2],
                                selected_foreground=colors[2],
                                dmenu_lines=10,
                            )
                        ),
                    },
                ),
                separator,
                widget.GroupBox(
                    font="Ubuntu Bold",
                    fontsize=9,
                    margin_y=3,
                    margin_x=0,
                    padding_y=5,
                    padding_x=3,
                    borderwidth=3,
                    active=colors[2],
                    inactive=colors[7],
                    rounded=False,
                    highlight_color=colors[1],
                    highlight_method="line",
                    this_current_screen_border=colors[6],
                    this_screen_border=colors[4],
                    other_current_screen_border=colors[6],
                    other_screen_border=colors[4],
                    foreground=colors[2],
                    background=colors[0],
                ),
                widget.TextBox(
                    text="|",
                    font="Ubuntu Mono",
                    background=colors[0],
                    foreground="474747",
                    padding=2,
                    fontsize=14,
                ),
                widget.CurrentLayoutIcon(
                    custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
                    foreground=colors[2],
                    background=colors[0],
                    padding=0,
                    scale=0.5,
                ),
                widget.CurrentLayout(
                    foreground=colors[2], background=colors[0], padding=5
                ),
                widget.TextBox(
                    text="|",
                    font="Ubuntu Mono",
                    background=colors[0],
                    foreground="474747",
                    padding=2,
                    fontsize=14,
                ),
                widget.WindowName(
                    foreground=colors[6], background=colors[0], padding=0
                ),
                separator,
                volume_widget,
                separator,
                battery_widget,
                separator,
                widget.Backlight(
                    backlight_name="amdgpu_bl1",
                    foreground=colors[2],
                    background=colors[1],
                    fmt="Lit: {} ",
                ),
                widget.Clock(
                    format="%d-%m-%Y %a %I:%M %p",
                    foreground=colors[8],
                    background=colors[1],
                ),
            ],
            24,
        ),
    ),
]

# Define layouts
layout_theme = {
    "border_width": 2,
    "margin": 8,
    "border_focus": colors[7],
    "border_normal": colors[0],
}

layouts = [
    layout.MonadTall(**layout_theme),
    layout.TreeTab(
        font="Ubuntu",
        fontsize=10,
        sections=["FIRST", "SECOND", "THIRD", "FOURTH"],
        section_fontsize=10,
        border_width=2,
        bg_color="1c1f24",
        active_bg="c678dd",
        active_fg="000000",
        inactive_bg="a9a1e1",
        inactive_fg="1c1f24",
        padding_left=0,
        padding_x=0,
        padding_y=5,
        section_top=10,
        section_bottom=20,
        level_shift=8,
        vspace=3,
        panel_width=200,
    ),
    # layout.Floating(),
    # layout.Bsp(),
    # layout.RatioTile(**layout_theme),
    # layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    # layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.Tile(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

# Define Qtile config
# Replace 'mod' and keybindings with your preferred settings
# Customize layouts, groups, and widgets as needed
# Add autostart commands, floating window rules, etc.
# Save this file as ~/.config/qtile/config.py
