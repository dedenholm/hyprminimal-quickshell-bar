import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick
Item{
	implicitHeight: memInfo.implicitHeight
	implicitWidth: memInfo.implicitWidth
	RowLayout{
		id:memInfo	
		implicitHeight: memText.implicitHeight + memPrefix.implicitHeight
		implicitWidth: 	memText.implicitWidth + memPrefix.implicitWidth
		Text {
			id: memPrefix
			text:  "mem: "
			color: main.color2
			font {family: main.font2; pixelSize: main.fontSize2;	}
		}	
		Text {
			id: memText	
            		text:  memUsage + "/"+ memTotal +"GiB"
            		color: main.foreground
            		font { family: main.font2; pixelSize: main.fontSize2; }
        	}
	}
        
property string memUsage: ""
property string memTotal: ""

function timerPause() { 
        memTimer.running = false;
        //cpuTimer.repeat = false;
    }
    function timerRun() { 
        memTimer.running =true;
        memProc.running = true
        //cpuTimer.repeat = false;
    }


    Timer {
    id: memTimer
    interval: 400
    running: false
    repeat: true
    onTriggered: {
        memProc.running = true
    }
}
// Memory process
Process {
    id: memProc
    command: ["sh", "-c", "free -h | grep Mem"]
    stdout: SplitParser {
        onRead: data => {
            if (!data) return
            var parts = data.trim().split(/\s+/)
            var total = parts[1] 
            var used = parts[2] 
	    memUsage = used.toString().replace("Gi", "");  
	    memTotal = total.toString().replace("Gi", "");
        }
    }
    Component.onCompleted: running = true
}
}
