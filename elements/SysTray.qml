import Quickshell
import QtQuick
import Quickshell.Widgets
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import QtQuick.Effects

Item {
    implicitWidth: trayLayout.implicitWidth
    implicitHeight: trayLayout.implicitHeight
   RowLayout{
    id: trayLayout
   implicitWidth: trayRepeater.implicitWidth
    implicitHeight: trayRepeater.implicitHeight

Repeater {
    id:trayRepeater
    model: SystemTray.items
    delegate: IconImage {
                        property SystemTrayItem item: modelData
                        source: item.icon
                        id: sysTrayIcon
                        width:20
                        height:20
                        Layout.topMargin: 0
                        //property alias delegateMenu: menu
                        MouseArea{
                          anchors.fill: parent
                          cursorShape: Qt.PointingHandCursor
                          acceptedButtons: Qt.LeftButton | Qt.RightButton
                           
                          onClicked: event=> {
                            
                            switch(event.button){
                              case Qt.LeftButton:{
                                  if(sysTrayIcon.item.onlyMenu == true){
                                      if(sysTrayIcon.item.hasMenu) {
                                          menu.open()
                                          main.menuOpen = true
                                      }    
                                  }
                                  else {sysTrayIcon.item.activate()}
                              }                         
                              
                              break;
                              case Qt.RightButton:{
                                  if(sysTrayIcon.item.hasMenu) {
                                  menu.open()
                                  main.menuOpen = true
                                  } 

                              }
                              break;
                            }
                          }



                        }

                        QsMenuAnchor{
                          id:menu
                          menu: sysTrayIcon.item.menu
                          anchor.item: sysTrayIcon
                          anchor.edges: Qt.BottomEdge | Qt.LeftEdge

                          anchor.gravity: Qt.BottomEdge | Qt.LeftEdge


                          onClosed:{

                                   main.menuOpen = false
                                    if (barMouseArea.containsMouse === false) {hideTimer.start()}
                          }
                 }
    }

} 
}
}
                  


