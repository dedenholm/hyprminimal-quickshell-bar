import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Hyprland
//

//https://www.tonybtw.com/tutorial/quickshell/
Item {
    id: cpuInfo
    property int cpuUsage: 0
    property int memUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0
    width: 60
    //implicitWidth: cpuText.width
    implicitHeight: cpuText.height
    function timerPause() { 
        cpuTimer.running = false;
        //cpuTimer.repeat = false;
    }
    function timerRun() { 
        cpuTimer.running =true;
        cpuProc.running = true
        //cpuTimer.repeat = false;
    }

    Timer {
      id: cpuTimer
      interval: 500        // Every 2 seconds
      running: false        // Start immediately
      repeat: true          // Keep going forever
      onTriggered: {cpuProc.running = true;}
    }
Process {
    id: cpuProc
    command: ["sh", "-c", "head -1 /proc/stat"]
    stdout: SplitParser {
        onRead: data => {
            if (!data) return
            var p = data.trim().split(/\s+/)
            var idle = parseInt(p[4]) + parseInt(p[5])
            var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
            if (cpuInfo.lastCpuTotal > 0) {
                cpuInfo.cpuUsage = Math.round(100 * (1 - (idle - cpuInfo.lastCpuIdle) / (total - cpuInfo.lastCpuTotal)))
            }
            cpuInfo.lastCpuTotal = total
            cpuInfo.lastCpuIdle = idle
        }
    }
    //////////////////Component.onCompleted: running = true
  }
  RowLayout {
    anchors.centerIn: parent
    Layout.rightMargin: 50
    implicitHeight: cpuPrefix.implicitHeight + cpuValue.implicitHeight
    implicitWidth: cpuPrefix.implicitWidth  + cpuValue.implicitWidth
    spacing: 0
    id: cpuText
    Text {
    	id: cpuPrefix
      	text: "cpu"
      	color:main.color2
        font {family: main.font1; pixelSize: main.fontSize2;}
     }
     Text {
         id:cpuValue
         text: ": " + cpuUsage + "%"
         color: main.foreground
         font { family: main.font2; pixelSize: main.fontSize2;}
      }

    }	
      MouseArea {
	anchors.fill: parent
	cursorShape: Qt.PointingHandCursor
	onClicked:  Quickshell.execDetached({command: ["sh", "-c", main.resourceMonitorCmd]})
	}
}


