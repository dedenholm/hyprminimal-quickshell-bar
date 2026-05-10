import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import ".."


Item {
    id: batInfo
    Layout.leftMargin:0
    implicitHeight: batText.implicitHeight
    implicitWidth: batText.implicitWidth
    property string chargeState: ""
    property int batteryPerc: 0
    property string upowerList: ""
    property string bat1: ""
    property bool batPresent: true
    RowLayout {
      id: batText
      implicitWidth: batPercText.implicitWidth +batPrefix.implicitWidth + chargePrefix.implicitWidth
      implicitHeight:batPercText.implicitHeight + batPrefix.implicitHeight + chargePrefix.implicitHeight
      spacing: 0
            
      Text {
        id: chargePrefix
        text: batInfo.chargeState
        color: main.color1
        font {family: main.font2; pixelSize: main.fontSize2}
      }
      Text {
        padding: 0

        id: batPrefix
        text: "bat"
        font { family: main.font2; pixelSize: main.fontSize2}
        color: main.color2
        
    // When empty → invisible → takes no layout space
    visible: text.length > 0

    // When empty → width/height = 0
      }

      Text {
        id:batPercText      
        text:": "+ batInfo.batteryPerc +"%"
        color: main.foreground

      font { family: main.font2; pixelSize: main.fontSize2}
      }
    }
    Timer {
      id: batLoop
      interval:2000
      repeat: true
      running: true
      onTriggered: batProc.running =true
    }
    Timer {
      id: slowDown
      interval:500
      repeat:true
      onTriggered: {

              batInfo.chargeState= batInfo.bat1
       // var batData = bat
        //batInfo.chargeState = "ha"

      }
    }
    
    Process {
      id:batProc
      running: true
      command: ["sh", "-c", "upower -i $(upower -e | grep 'BAT')"]

      stdout: SplitParser {
                  id: batteryData
                  onRead: data => {
                    //console.log(data)
                    var bat =  data.trim().split(/\s+/)
                    var field = bat[0]
                    // console.log(bat[0])
                    if (field == "present:") {
                      if (bat[1] == "no") {
                        batLoop.running= false
                        batLoop.repeat =false
                        batInfo.batPresent = false
                        batPercText.visible =false
                        batPrefix.visible = false
                        chargePrefix.visible = false

                        console.log("no battery detected")}
                    }

                    if (field == "state:") {
                      if (bat[1] == "charging") {batInfo.chargeState = "⚡ chrg"
                                                 batPrefix.text = ""
                      }
                      if (bat[1] == "fully-charged") {batInfo.chargeState = "⚡ bat"
                                                      batPrefix.text = ""
                      }

                      if(bat[1]== "discharging") {
                        batInfo.chargeState =""
                        batPrefix.text ="bat"

                      }

                    }
                                        
                    if (field == "percentage:") {
                      batInfo.batteryPerc = parseInt(bat[1])
                      
                    } 
                  }
                }

              }
    
}




