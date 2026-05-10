import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Hyprland

//

//https://www.tonybtw.com/tutorial/quickshell/
Item {
    id: playerCtl

    property string metadata: ""
    property string status: ""
    property int mpdVol: 0.0 
    property int volumeSpacerWidth: 20
    implicitWidth: playerInfo.width
    implicitHeight: playerInfo.height


    function timerPause() { 
        playerProcTimer.running = false;
        //cpuTimer.repeat = false;
    }
    function timerRun() { 
        playerProcTimer.running =true;
        playerProc.running = true
        //cpuTimer.repeat = false;
    }
    Timer {
        id: simpleDelay
        interval: 50
        running: false
        repeat: false
        onTriggered: playerProc.running = true
    }

    Timer {
        id: playerProcTimer
        interval: 800        // Every 2 seconds
        running: false         // Start immediately
        repeat: true          // Keep going forever
        onTriggered: playerProc.running = true;
    }
    Process {
        id: playerProc
        property string scriptPath2: Qt.resolvedUrl("Playerctl_script.sh").toString().replace("file://", "")
        command: ["sh", "-c", scriptPath2]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                var mediainfo = data.trim().split(/\s+/);
                var field = mediainfo[0];
                if (field == "off") {
                    playerCtl.metadata = "";
                    playerCtl.status = "";
                    mpdVolume.visible = false;
                    mpdVolumePrefix.visible = false;
                }
                if (field == "metadata:") {
                    playerCtl.metadata = mediainfo.slice(1).join(" ");
                }
                if (field == "status:") {
                    if (mediainfo[1] == "Playing") {
                        playerCtl.status = "󰏤";
                    } else {
                        playerCtl.status = "󰐊";
                    }
                }
                if (field == "player:") {
                    if (mediainfo[1] == "mpd") {
                        mpdVolume.visible = true;
                        mpdVolumePrefix.visible = true;
                        mpdVolumeSpacer.visible = true;
                        playerCtl.mpdVol = parseInt(mediainfo[2] * 100);
                    } else {
                        mpdVolume.visible = false;
                        mpdVolumeSpacer.visible = false;
                        mpdVolumePrefix.visible = false;
                    }
                }
            }
        }
    }

    RowLayout {
        Layout.alignment: Qt.AlignVCenter
        id: playerInfo
        Layout.rightMargin: 50
        implicitHeight: infoText.implicitHeight
        implicitWidth: infoText.implicitWidth
        spacing: 0
        

        Text {
        	id: mpdIcon
        	text: " 󰽰" 
          color: main.color2
          font { family: main.font2; pixelSize: 23}
          
          MouseArea {
            
            anchors.fill: parent            
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: (mouse)=>{
              
              console.log("mouse event2")
              
              if (mouse.button == Qt.LeftButton) {Quickshell.execDetached({command: ["sh", "-c", main.musicPlayerCmd]})}

          
              
              else Quickshell.execDetached({command: ["sh", "-c", main.musicPlayerCmdRemote]})          

            }
          }
        }
        Text {
            Layout.topMargin: 3
            verticalAlignment: Text.AlignVCenter
            id: statusIcon
            text: "  " + playerCtl.status + "  "
            color: main.color2
            font {
                family: main.font1
                pixelSize: 29
            }
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                  Quickshell.execDetached({command: ["sh", "-c", "playerctl play-pause"]});
                  simpleDelay.running = true;
                }
            }
        }

        Text {
          id: infoText
          text: playerCtl.metadata + ""
          color: main.foreground
          elide: Text.ElideMiddle
          //Layout.maximumWidth: 200
          Layout.maximumWidth: 600
          //Layout.alignment: Qt.AlignVCenter
          Layout.topMargin:3
          verticalAlignment: Text.AlignVCenter
          font {
            family: main.font1
            pixelSize: main.fontSize2
          }
        }
        Item {
          id:mpdVolumeSpacer
          width: 20 
          visible: false
        }
        Text {
          id: mpdVolumePrefix
          verticalAlignment: Text.AlignVCenter
          text: "mpd vol: "
          visible: false
          color: main.color2
          font {
            family: main.font2
            pixelSize: main.fontSize2
          }
        }
        Text {
          id: mpdVolume
          verticalAlignment: Text.AlignVCenter
          text: playerCtl.mpdVol + "% "
          visible: false
          color: main.foreground
          font {
            family: main.font2
            pixelSize: main.fontSize2
          }
          MouseArea {
            anchors.fill: parent
            cursorShape: Qt.SizeVerCursor
            onWheel: function (event) {
              var delta = event.angleDelta.y;
              //console.log(delta)
              if (delta == 120) {
                        Quickshell.execDetached({command: ["sh", "-c", "playerctl volume 0.02+"]});
                        playerCtl.mpdVol = playerCtl.mpdVol + 2;
                    }
                    if (delta == -120) {
                        Quickshell.execDetached({command: ["sh", "-c", "playerctl volume 0.02-"]});

                        playerCtl.mpdVol = playerCtl.mpdVol - 2;
                    }
                    playerProc.running = true;
                }
            }
        }
    }
}
