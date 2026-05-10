import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import ".."


Item {
  id: tempInfo

    width: 80
    implicitHeight: temp.implicitHeight

    //implicitWidth: temp.implicitWidth
    property string chargeState: ""
    property int batteryPerc: 0
    property string upowerList: ""
    property string bat1: ""
    property bool batPresent: true
    property int tempSensorCount: 0
    property int totalTemp: 0
    property real finalTemp
    
    function runTemp() {

              tempInfo.finalTemp = tempInfo.totalTemp 
              tempInfo.totalTemp = 0
              tempInfo.tempSensorCount = 0
              tempProc.running = true


    }
    function timerPause() { 
        tempLoop.running = false;
        //cpuTimer.repeat = false;
    }
    function timerRun() { 

        tempLoop.running =true;
        //tempProc.running = true
        runTemp()
        //cpuTimer.repeat = false;
    }

        RowLayout {
     id: temp 
     
     spacing: 0
    // width: 110

      //implicitWidth:  tempTextPrefix.implicitWidth + tempText.implicitWidth
      //implicitHeight: tempTextPrefix.implicitHeight + tempText.implicitHeight
      //Text {text: temp.implicitWidth}      
      Item{}
      Text {
        id:tempTextPrefix      
        text:"temp"
        color: main.color2
        Layout.fillWidth: false
        font { family: main.font2; pixelSize: main.fontSize2}
      } 
      Text {
        id:tempText 
        text: ": " + tempInfo.finalTemp +"°C"
        color: main.foreground
        Layout.fillWidth: false
      font { family: main.font2; pixelSize: main.fontSize2}
    }

    }
    Timer {
      id: tempLoop
      interval:600
      repeat: true
      running: false
      onTriggered: {tempInfo.runTemp();
                            
                    }
    }
    
    
    Process {
      id:tempProc
      running: true
      property string scriptPath: Qt.resolvedUrl("hwmonscript.sh").toString().replace("file://", "")
      
      command: ["sh", "-c", scriptPath ]

      stdout: SplitParser {
                  id: tempData
		  onRead: data => {
			var readout = data.trim().split(/\s+/)
			var temp = parseInt(readout[1])
			tempInfo.tempSensorCount = tempInfo.tempSensorCount + 1
                    	tempInfo.totalTemp = (tempInfo.totalTemp + temp) / tempInfo.tempSensorCount
                  }
                }

              }
    
}




