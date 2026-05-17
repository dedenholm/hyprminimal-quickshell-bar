pragma Singleton

import Quickshell
import QtQuick

// ─────────────────────────────────────────────────────────────────
//  hyprminimal — daniel's personal config
//  Rename to Config.qml to use.
// ─────────────────────────────────────────────────────────────────

Singleton {
    id: config

    // ── Appearance ────────────────────────────────────────────────
    property string font1:     "Eurostile"
    property string font2:     "Nudista Light"
    property string font3:     "GohuFont 14 Nerd Font Mono"
    property int    fontSize1: 18
    property int    fontSize2: 16

    property real  barOpacity:     0.8
    property color color1:         "#F0C674"
    property color color2:         "#7aa3fa"
    property color foreground:     "#C5C8C6"
    property color weakforeground: "#51565A"
    property color colorMuted:     "#696969"
    property color background:     Qt.rgba(0.188, 0.188, 0.188, barOpacity)

    // ── Terminal ──────────────────────────────────────────────────
    property string terminal: "kitty --class=qslaunch --config /home/daniel/.config/kitty/quickshelllaunch.conf -e "

    // ── Commands ──────────────────────────────────────────────────
    property string launcherCmd:          "rofi -show drun -location 1"
    property string powerMenuCmd:         "rofi -show power-menu -modi power-menu:rofi-power-menu -location 1"
    property string audioControlCmd:      "pavucontrol"
    property string resourceMonitorCmd:   terminal + "btop"
    property string fetchCmd:             "kitty --class=fastfetch --hold fastfetch"
    property string musicPlayerCmd:       "kitty --class=rmpc --config /home/daniel/.config/kitty/quickshelllaunch.conf -e rmpc"
    property string musicPlayerCmdRemote: terminal + "ncmpcpp"

    // ── Toggle button 1 — høyttaler (speaker) ────────────────────
    property bool   btn1Enabled:      true
    property string btn1Icon:         " 󰴸 "
    property string btn1StateFile:    "/home/daniel/mg09_1/IPC/hoyttaler_state"
    property string btn1ToggleScript: ""   // run via SSH only

    // ── Toggle button 2 — allelys (lights) ───────────────────────
    property bool   btn2Enabled:      true
    property string btn2Icon:         " 󱉕 "
    property string btn2StateFile:    "/home/daniel/mg09_1/IPC/allelys_state"
    property string btn2ToggleScript: ""   // run via SSH only

    // ── Toggle button 3 — ovn (oven/heat) ────────────────────────
    property bool   btn3Enabled:      true
    property string btn3Icon:         " 󱩅 "
    property string btn3StateFile:    ""   // state read from remote only
    property string btn3ToggleScript: ""   // run via SSH only

    // ── SSH (used by all three toggle buttons) ────────────────────
    property string remoteHost: "192.168.1.200"
    property int    remotePort: 1995
    property string remoteUser: "daniel"

    property string btn1RemoteScript: "/home/daniel/script/toggle/hoyttaler.sh"
    property string btn1RemoteState:  "/home/daniel/script/toggle/hoyttaler_state"

    property string btn2RemoteScript: "/home/daniel/script/toggle/allelys.sh"
    property string btn2RemoteState:  "/home/daniel/script/toggle/allelys_state"

    property string btn3RemoteScript: "/home/daniel/script/toggle/ovn.sh"
    property string btn3RemoteState:  "/home/daniel/script/toggle/ovn_state"

    // ── RSS launcher ──────────────────────────────────────────────
    property bool   rssEnabled: true
    property string rssIcon:    "  "
    property string rssCmd:     "fluent-reader"

    // ── Clock formats ─────────────────────────────────────────────
    property string timeFormat1: "MMM d yyyy -- hh:mm:ss"
    property string timeFormat2: "hh:mm"

    // ── Bar behaviour ─────────────────────────────────────────────
    property int barHeight:    40
    property int enterDelayMs: 303
    // Delay from mouse on top to bar shown.
    property int hideDelayMs: 300 // How long the bar stays visible after mouse leaves the bar
    property int exitTimerMs: 3000
}
