import Quickshell // for PanelWindow
import QtQuick // for Text
import QtQuick.Layouts
import Quickshell.Hyprland
  



RowLayout{
  //Layout.fillHeight: parent
  //anchors.centerIn: parent
Repeater {
          model: Hyprland.workspaces.values
          property var ws: Hyprland.workspaces.values
          Text {
                id:workspaceNumbers
               // anchors.fill: parent
                Layout.leftMargin:8 
               // Layout.maximumWidth:15 
                required property int index
                text: Hyprland.workspaces.values[index].id
                font { family: font2; pixelSize: fontSize1;}

                bottomPadding: -2 
                color: foreground
                property int ws_index: Hyprland.workspaces.values[index].id
                property bool isActive: Hyprland.focusedWorkspace.id === ws_index
                
                MouseArea {
                           anchors.fill: parent
                           cursorShape: Qt.PointingHandCursor
                           //required property int index
                           onClicked: Hyprland.dispatch("workspace " + parent.ws_index)
                }

                Rectangle {
                            width: 15


                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.horizontalCenterOffset: -1
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: -4
                            height: parent.isActive ? 3 : 0         // thickness

                                          
                            color: color2

                }                
          }                     
}
}
