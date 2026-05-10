import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

Text {
    id: archLogo
    text: ""
    //anchors.fill: parent
    //anchors.centerIn: parent
    Layout.leftMargin: 10
    Layout.rightMargin: 5
    Layout.topMargin: 5
    font.pixelSize: 18
    color: main.color2
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse)=>{
          console.log("mouse event2")
          if (mouse.button == Qt.LeftButton) {Quickshell.execDetached({command: ["sh", "-c", main.fetchCmd]})}
          
          else Quickshell.execDetached({command: ["sh", "-c", main.powerMenuCmd]})          

          //if (mouse.button == Qt.LeftButton) {Hyprland.dispatch("exec " + main.launcherCmd)}
          //else Hyprland.dispatch("exec " + main.powerMenuCmd)        
        }
    }
}
