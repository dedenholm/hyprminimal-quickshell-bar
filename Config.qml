pragma Singleton

import Quickshell
import QtQuick

// ─────────────────────────────────────────────────────────────────
//  hyprminimal — user configuration
//  Edit this file to match your system. Nothing else should need
//  to change for a basic setup.
// ─────────────────────────────────────────────────────────────────

Singleton {
    id: config

    // ── Appearance ────────────────────────────────────────────────
    // Fonts must be installed on your system.
    // font1 is used for headings / workspace numbers / clock.
    // font2 is used for labels and values.
    // font3 is a fallback Nerd Font (used for icons if font1/font2
    //   don't include the required glyphs).
    property string font1:    "Eurostile"
    property string font2:    "Nudista Light"
    property string font3:    "GohuFont 14 Nerd Font Mono"
    property int    fontSize1: 18   // large (clock, workspace numbers)
    property int    fontSize2: 16   // regular (labels, values)

    property real  barOpacity:    0.8
    property color color1:        "#F0C674"    // accent / active
    property color color2:        "#7aa3fa"    // secondary accent
    property color foreground:    "#C5C8C6"
    property color weakforeground: "#51565A"
    property color colorMuted:    "#696969"
    // background is computed from barOpacity; override here if needed:
    property color background:    Qt.rgba(0.188, 0.188, 0.188, barOpacity)

    // ── Terminal emulator ─────────────────────────────────────────
    // Command used to open a terminal for spawned apps.
    // The trailing space + "-e" pattern is intentional.
    // Example for foot:    "foot -e "
    // Example for alacritty: "alacritty -e "
    property string terminal: "kitty -e "

    // ── Application commands ──────────────────────────────────────
    property string launcherCmd:       "rofi -show drun -location 1"
    property string powerMenuCmd:      "rofi -show power-menu -modi power-menu:rofi-power-menu -location 1"
    property string audioControlCmd:   "pavucontrol"
    property string resourceMonitorCmd: terminal + "btop"
    property string fetchCmd:          "fastfetch"   // runs in a new terminal window
    // Music player opened locally (left-click on MPD icon)
    property string musicPlayerCmd:    terminal + "rmpc"
    // Music player opened via remote / alternative client (right-click)
    property string musicPlayerCmdRemote: terminal + "ncmpcpp"

    // ── Custom toggle buttons (elements_Buttons) ──────────────────
    // The Buttons widget polls three toggleable states and can
    // switch them on/off. Each button reads a state file (0 or 1)
    // and runs a toggle script on click.
    //
    // Set `enabled: false` on any button you don't need — the widget
    // will gracefully hide that button.

    // Button 1 — speaker / amplifier
    property bool   btn1Enabled:      true
    property string btn1Label:        "speaker"
    property string btn1Icon:         " 󰴸 "
    // Path to local IPC state file (contains "0" or "1")
    property string btn1StateFile:    ""   // e.g. "/home/you/ipc/speaker_state"
    // Command to toggle (runs remotely if btn1Remote is true)
    property string btn1ToggleScript: ""   // e.g. "/home/you/scripts/speaker_toggle.sh"

    // Button 2 — lights
    property bool   btn2Enabled:      true
    property string btn2Label:        "lights"
    property string btn2Icon:         " 󱉕 "
    property string btn2StateFile:    ""   // e.g. "/home/you/ipc/lights_state"
    property string btn2ToggleScript: ""   // e.g. "/home/you/scripts/lights_toggle.sh"

    // Button 3 — oven / heat
    property bool   btn3Enabled:      true
    property string btn3Label:        "heat"
    property string btn3Icon:         " 󱩅 "
    property string btn3StateFile:    ""   // e.g. "/home/you/ipc/heat_state"
    property string btn3ToggleScript: ""   // e.g. "/home/you/scripts/heat_toggle.sh"

    // ── Remote SSH (optional, used by toggle buttons) ─────────────
    // If your toggle scripts live on a remote machine, set these.
    // Leave remoteHost empty to disable SSH and run scripts locally.
    property string remoteHost: ""    // e.g. "192.168.1.200"
    property int    remotePort: 22
    property string remoteUser: ""    // e.g. "you"
    // Remote paths for each toggle script (only used when remoteHost != "")
    property string btn1RemoteScript: ""  // e.g. "/home/you/scripts/speaker.sh"
    property string btn2RemoteScript: ""  // e.g. "/home/you/scripts/lights.sh"
    property string btn3RemoteScript: ""  // e.g. "/home/you/scripts/heat.sh"
    // Remote state files to read back after toggle
    property string btn1RemoteState:  ""  // e.g. "/home/you/ipc/speaker_state"
    property string btn2RemoteState:  ""  // e.g. "/home/you/ipc/lights_state"
    property string btn3RemoteState:  ""  // e.g. "/home/you/ipc/heat_state"

    // ── Clock formats ─────────────────────────────────────────────
    // Click the clock to toggle between the two formats.
    property string timeFormat1: "MMM d yyyy -- hh:mm:ss"
    property string timeFormat2: "hh:mm"

    // ── RSS launcher button ───────────────────────────────────────
    property bool   rssEnabled: true
    property string rssIcon:    " 󰑫 "
    property string rssCmd:     "fluent-reader"

    // ── Bar behaviour ─────────────────────────────────────────────
    property int barHeight:        40   // px
    property int hideDelayMs:     300   // ms before bar auto-hides
    property int enterDelayMs:     300   // ms before bar auto-hides
    property int exitTimerMs:    3000   // ms before bar dismisses after IPC show
}
