
 Loader {
                              id: menuLoader
                              active: false
                              anchors.fill: parent

                              function open() { active = true }
                              function close() { active = false }
                              sourceComponent: PopupWindow{
                                                            id: menuWindow
                                                            anchor.item: sysTrayIcon
                                                            visible: true
                                                            //anchor.edges: Qt.BottomEdge | Qt.LeftEdge
                                                            //anchor.gravity: Qt.BottomEdge | Qt.LeftEdge
                                                            color: background
                                                            implicitWidth: 200
                                                            implicitHeight:299 
                                                            ColumnLayout {
                                                              
                                                                          id:menuColumn
                                                                          implicitHeight: menuEntry.height
                                                                          implicitWidth: menuEntry.width
                                                                          QsMenuOpener{
                                                                                    id: menu
                                                                                    menu: sysTrayIcon.item.menu

                                                                          }

                                                                          Repeater{
                                                                                    id:menuRepeater
                                                                                    model: menu.children
                                                                                
                                                                                    
                                                                                    delegate: Item{
                                                                                                property QsMenuEntry item: modelData

                                                                                                
                                                                                                Text {
                                                                                                    id: menuEntry
                                                                                                                                                                                                        

                                                                                                
                                                                                                    text: item.text
                                                                                                }

                                                                                    }
                                                                          }
                                                            }

                              }
                        } 
