import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Hyprland
import ".."

// Toggle-button strip.
// All paths and SSH details come from Config.qml — edit that file,
// not this one.
Item {
    id: buttons
    implicitWidth:  buttonIcons.width
    implicitHeight: buttonIcons.height

    property bool btn1Status: false
    property bool btn2Status: false
    property bool btn3Status: false

    // ── Helpers ──────────────────────────────────────────────────────
    function timerPause() { statusCheckLoop.running = false }
    function timerRun()   {
        statusCheckLoop.running = true
        btn1StatusCheck.running = true
        btn2StatusCheck.running = true
        btn3StatusCheck.running = true
    }

    // Build the shell command for reading a state file.
    // If a remoteHost is configured, reads via SSH; otherwise reads locally.
    function readStateCmd(stateFile, remoteStatePath) {
        if (Config.remoteHost !== "" && remoteStatePath !== "") {
            return "ssh -p " + Config.remotePort + " " +
                   Config.remoteUser + "@" + Config.remoteHost +
                   " cat " + remoteStatePath
        }
        return "cat " + stateFile
    }

    // Build the shell command for toggling a button and reading the new state.
    function toggleCmd(toggleScript, remoteScript, remoteStatePath) {
        if (Config.remoteHost !== "" && remoteScript !== "") {
            return "ssh -p " + Config.remotePort + " " +
                   Config.remoteUser + "@" + Config.remoteHost +
                   " '" + remoteScript + " && cat " + remoteStatePath + "'"
        }
        return toggleScript
    }

    Component.onCompleted: { initDelay.running = true }

    // ── Status-check processes ────────────────────────────────────────
    Process {
        id: btn1StatusCheck
        command: ["sh", "-c", buttons.readStateCmd(Config.btn1StateFile, Config.btn1RemoteState)]
        stdout: SplitParser {
            onRead: data => {
                if (data == 0) buttons.btn1Status = false
                if (data == 1) buttons.btn1Status = true
            }
        }
    }
    Process {
        id: btn2StatusCheck
        command: ["sh", "-c", buttons.readStateCmd(Config.btn2StateFile, Config.btn2RemoteState)]
        stdout: SplitParser {
            onRead: data => {
                if (data == 0) buttons.btn2Status = false
                if (data == 1) buttons.btn2Status = true
            }
        }
    }
    Process {
        id: btn3StatusCheck
        command: ["sh", "-c", buttons.readStateCmd(Config.btn3StateFile, Config.btn3RemoteState)]
        stdout: SplitParser {
            onRead: data => {
                if (data == 0) buttons.btn3Status = false
                if (data == 1) buttons.btn3Status = true
            }
        }
    }

    // ── Toggle processes ─────────────────────────────────────────────
    Process {
        id: btn1Toggle
        command: ["sh", "-c", buttons.toggleCmd(Config.btn1ToggleScript, Config.btn1RemoteScript, Config.btn1RemoteState)]
        stdout: SplitParser {
            onRead: data => {
                if (data == 0) buttons.btn1Status = false
                if (data == 1) buttons.btn1Status = true
            }
        }
    }
    Process {
        id: btn2Toggle
        command: ["sh", "-c", buttons.toggleCmd(Config.btn2ToggleScript, Config.btn2RemoteScript, Config.btn2RemoteState)]
        stdout: SplitParser {
            onRead: data => {
                if (data == 0) buttons.btn2Status = false
                if (data == 1) buttons.btn2Status = true
            }
        }
    }
    Process {
        id: btn3Toggle
        command: ["sh", "-c", buttons.toggleCmd(Config.btn3ToggleScript, Config.btn3RemoteScript, Config.btn3RemoteState)]
        stdout: SplitParser {
            onRead: data => {
                if (data == 0) buttons.btn3Status = false
                if (data == 1) buttons.btn3Status = true
            }
        }
    }

    // ── Timers ───────────────────────────────────────────────────────
    Timer {
        id: initDelay
        interval: 200
        running: false
        repeat: false
        onTriggered: {
            btn1StatusCheck.running = true
            btn2StatusCheck.running = true
            btn3StatusCheck.running = true
        }
    }
    Timer {
        id: statusCheckLoop
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            btn1StatusCheck.running = true
            btn2StatusCheck.running = true
            btn3StatusCheck.running = true
        }
    }

    // ── UI ───────────────────────────────────────────────────────────
    RowLayout {
        id: buttonIcons
        spacing: 0

        // Button 1
        Text {
            id: btn1Icon
            visible: Config.btn1Enabled
            text: Config.btn1Icon
            color: buttons.btn1Status ? main.color1 : main.colorMuted
            font { family: main.font1; pixelSize: 18 }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    btn1Toggle.running = true
                    buttons.btn1Status = !buttons.btn1Status
                }
            }
        }

        Item { width: 10; visible: Config.btn1Enabled }

        // Button 2
        Text {
            id: btn2Icon
            visible: Config.btn2Enabled
            text: Config.btn2Icon
            color: buttons.btn2Status ? main.color1 : main.colorMuted
            font { family: main.font2; pixelSize: 18 }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    btn2Toggle.running = true
                    buttons.btn2Status = !buttons.btn2Status
                }
            }
        }

        Item { width: 10; visible: Config.btn2Enabled }

        // Button 3
        Text {
            id: btn3Icon
            visible: Config.btn3Enabled
            text: Config.btn3Icon
            color: buttons.btn3Status ? main.color1 : main.colorMuted
            font { family: main.font2; pixelSize: 18 }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    btn3Toggle.running = true
                    buttons.btn3Status = !buttons.btn3Status
                }
            }
        }

        Item { width: 10; visible: Config.btn3Enabled }

        // RSS launcher
        Text {
            id: rssIcon
            visible: Config.rssEnabled
            text: Config.rssIcon
            color: "#ffffff"
            font { family: main.font2; pixelSize: 18 }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Quickshell.execDetached({ command: ["sh", "-c", Config.rssCmd] })
            }
        }

        Item { width: 10 }
    }
}
