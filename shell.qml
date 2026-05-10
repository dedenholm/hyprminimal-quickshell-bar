//@ pragma UseQApplication
//@ pragma RespectSystemStyle
import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "elements" as Elements

Scope {
    id: main

    property bool  menuOpen: false
    property bool  pinBar:   false

    // ── Proxy Config properties so elements can keep using `main.*` ──
    property string font1:         Config.font1
    property string font2:         Config.font2
    property string font3:         Config.font3
    property int    fontSize1:     Config.fontSize1
    property int    fontSize2:     Config.fontSize2
    property real   opacity:       Config.barOpacity
    property color  color1:        Config.color1
    property color  color2:        Config.color2
    property color  background:    Config.background
    property color  foreground:    Config.foreground
    property color  weakforeground: Config.weakforeground
    property color  colorMuted:    Config.colorMuted

    property string launcherCmd:        Config.launcherCmd
    property string powerMenuCmd:       Config.powerMenuCmd
    property string resourceMonitorCmd: Config.resourceMonitorCmd
    property string fetchCmd:           Config.fetchCmd
    property string musicPlayerCmd:     Config.musicPlayerCmd
    property string musicPlayerCmdRemote: Config.musicPlayerCmdRemote
    property string audioControlCmd:    Config.audioControlCmd
    property string terminal:           Config.terminal

    // ── Process management helpers ───────────────────────────────────
    function processPause() {
        cpuElement.timerPause();
        playerctlElement.timerPause();
        tempElement.timerPause();
        memoryElement.timerPause();
        buttonsElement.timerPause();
    }
    function processRun() {
        cpuElement.timerRun();
        playerctlElement.timerRun();
        tempElement.timerRun();
        memoryElement.timerRun();
        buttonsElement.timerRun();
    }

    // ── Timers ───────────────────────────────────────────────────────
    Timer {
        id: hideTimer
        interval: Config.hideDelayMs
        repeat: false
        onTriggered: {
            if (!main.menuOpen && !barMouseArea.containsMouse && !main.pinBar) {
                bar.visible = false;
                processPause();
            }
        }
    }
    Timer {
        id: exitTimer
        interval: Config.exitTimerMs
        repeat: false
        onTriggered: {
            if (!main.pinBar) {
                bar.visible = false;
                root.visible = true;
                hideTimer.stop();
            }
        }
    }

    // ── IPC ──────────────────────────────────────────────────────────
    IpcHandler {
        target: "panelshow"
        function showPanel() {
            bar.visible = true;
            root.visible = false;
            exitTimer.start();
        }
        function hidePanel() {
            bar.visible ? hideTimer.start() : exitTimer.stop();
            root.visible = true;
        }
        function pinPanel() {
            main.pinBar = !main.pinBar;
        }
    }

    // ── Invisible hover-trigger strip at top of screen ───────────────
    PanelWindow {
        id: root
        implicitWidth: bar.implicitWidth
        implicitHeight: 2
        color: Qt.rgba(0, 0, 0, 0)
        exclusiveZone: 0
        anchors { left: true; right: true; top: true }

        MouseArea {
            height: root.height
            width: root.width
            hoverEnabled: true
            onEntered: {
                hideTimer.stop();
                bar.visible = true;
                main.processRun();
                root.visible = false;
            }
        }
    }

    // ── Bar ──────────────────────────────────────────────────────────
    PanelWindow {
        id: bar
        exclusiveZone: 37
        visible: false
        implicitHeight: Config.barHeight
        color: main.background
        anchors { top: true; left: true; right: true }

        MouseArea {
            id: barMouseArea
            height: bar.height
            width: bar.width
            hoverEnabled: true
            onExited: {
                hideTimer.start();
                root.visible = true;
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignVCenter
            width: bar.width

            // Left section: logo + workspaces
            RowLayout {
                id: leftBar
                height: parent.height
                Layout.fillWidth: true
                spacing: 0
                Layout.alignment: Qt.AlignLeft
                Elements.ArchLogo {}
                Elements.Workspaces {}
            }

            Item { width: 550 }

            // Centre section: player + audio
            RowLayout {
                id: centerBar
                height: bar.height
                Layout.alignment: Qt.AlignLeft
                spacing: 20
                Elements.Playerctl { id: playerctlElement }
                Elements.Divider {}
                Elements.Audio {}
            }

            // Right section: buttons + stats + clock + tray
            RowLayout {
                Layout.rightMargin: 30
                Layout.fillWidth: false
                Layout.alignment: Qt.AlignRight
                layoutDirection: Qt.LeftToRight
                Item { Layout.fillWidth: true }

                Elements.Buttons  { id: buttonsElement }
                Elements.Divider {}
                Elements.Memory   { id: memoryElement }
                Elements.Divider {}
                Elements.Temp     { id: tempElement }
                Elements.Divider {}
                Elements.Cpu      { id: cpuElement }
                Elements.Divider {}
                Elements.ClockWidget {}
                Elements.SysTray { Layout.leftMargin: 10 }
            }
        }
    }
}
