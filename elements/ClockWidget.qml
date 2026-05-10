import QtQuick
import QtQuick.Layouts

import ".."
  Text {
    id: timeText
    text: Time.time
    color: main.foreground 
    font.pixelSize: main.fontSize1
    font.family: main.font1
    horizontalAlignment: Text.AlignHCenter
    Layout.topMargin: 2
    verticalAlignment: Text.AlignVCenter
    MouseArea {
      cursorShape: Qt.PointingHandCursor
      anchors.fill: parent
      onClicked:{
        if (Time.timeFormat2 == Time.currentTimeFormat) {
          Time.currentTimeFormat = Time.timeFormat1
          console.log("changing timeformat")
          
        }
        else {Time.currentTimeFormat = Time.timeFormat2}
      }
    }
  }

