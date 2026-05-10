import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
//

//https://www.tonybtw.com/tutorial/quickshell/
	Item {
			id: audioInfo
			implicitWidth: audioText.width
    			implicitHeight: audioText.height
    
			property string defaultSinkName: ""
			property string volume:  parseInt(Pipewire.defaultAudioSink.audio.volume*100) + "%"
			property var availableSinks: []
			property int currentSinkIndex: -1  
			function sinkDiscovery() {
				availableSinks = []
				for (var i = 0; i < Pipewire.nodes.values.length; i++){
			
					var node = Pipewire.nodes.values[i];
										

					if (node.isSink == true && node.isStream == false){
						audioInfo.availableSinks.push(node);
						 //console.log("added to sinks: " + node.description)
					}	
				}					
	 			if (availableSinks.length > 0) { currentSinkIndex = 0;}
			}	
			function cyclePreferredSink() {
				audioInfo.currentSinkIndex = (audioInfo.currentSinkIndex + 1) % audioInfo.availableSinks.length;
	                        if (audioInfo.availableSinks.length > 0) {
					
					if (Pipewire.defaultAudioSink == audioInfo.availableSinks[audioInfo.currentSinkIndex]) {
						audioInfo.currentSinkIndex = (audioInfo.currentSinkIndex + 1) % audioInfo.availableSinks.length;
					}

					Pipewire.preferredDefaultAudioSink = audioInfo.availableSinks[audioInfo.currentSinkIndex];
				
				} 
				else {console.log("No available sinks to cycle through.");}
		       
			}	

			Component.onCompleted:	(initDelay.running= true)


			Timer {
				id:sinkUpdate
				interval:5000
				running: true
				repeat: true
				onTriggered: {sinkDiscovery();}	} 
    
			Timer {
				id:initDelay
				interval:200
				running: false
				repeat: false
				onTriggered: {sinkDiscovery();}	} 
    

			PwObjectTracker {
    				objects: [Pipewire.defaultAudioSink]  
			}

  

  			RowLayout {
    				id: audioText
    				Layout.rightMargin: 50
    				implicitHeight: defaultSinkName.implicitHeight
    				implicitWidth: defaultSinkName.implicitWidth+volumePrefix.implicitWidth+volumeValue.implicitWidth 
    				spacing: 0
    
 
    				Text {
					id: defaultSinkName
					text: Pipewire.defaultAudioSink.description + "  --"
					color: if (Pipewire.defaultAudioSink.audio.muted == true) {main.colorMuted} else {main.foreground}
					font { family: main.font1; pixelSize: main.fontSize2;}
					MouseArea {
						anchors.fill: parent
						cursorShape: Qt.PointingHandCursor
            //onClicked: {cyclePreferredSink()}
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            onClicked: (mouse)=>{
                        console.log("mouse event2")//
                        if (mouse.button == Qt.LeftButton) {cyclePreferredSink()}

          
                        else Quickshell.execDetached({command: [main.audioControlCmd]})

          //if (mouse.button == Qt.LeftButton) {Hyprland.dispatch("exec " + main.launcherCmd)}
          //else Hyprland.dispatch("exec " + main.powerMenuCmd)        
        }

					}
				}
    				Text {
         				id:volumePrefix
			        	text: if (Pipewire.defaultAudioSink.audio.muted == true){" "} else {" vol: "} 
         				color: if (Pipewire.defaultAudioSink.audio.muted == true) {main.colorMuted} else {main.color2}
         				font { family: main.font2; pixelSize: main.fontSize2;}
 				}
				Text {
        				id:volumeValue
         				text: if (Pipewire.defaultAudioSink.audio.muted == true){"muted"} else {audioInfo.volume} 
         				color: if (Pipewire.defaultAudioSink.audio.muted == true) {main.colorMuted} else {main.foreground}
					font { family: main.font2; pixelSize: main.fontSize2;}
					MouseArea {
						anchors.fill: parent
						cursorShape: Qt.SizeVerCursor
						onWheel: function(event) {
       			 				var delta = event.angleDelta.y;

        						Pipewire.defaultAudioSink.audio.volume += delta > 0 ? 0.01 : -0.01;
							Pipewire.defaultAudioSink.audio.volume = Math.max(0.0, Math.min(1.0, Pipewire.defaultAudioSink.audio.volume));	
						}
						onClicked: {

							if (Pipewire.defaultAudioSink.audio.muted == true) {Pipewire.defaultAudioSink.audio.muted = false}
							else {Pipewire.defaultAudioSink.audio.muted = true}	
						}
					}	

 				}

        		}	
      

	}

