pragma Singleton

import Quickshell
import QtQuick
import "."
Singleton {
  id: root
    property string timeFormat1: "MMM d yyyy -- hh:mm:ss"
    property string timeFormat2: "hh:mm"
    property string currentTimeFormat: "hh:mm"
    property string time: {
        Qt.formatDateTime(clock.date, currentTimeFormat);

    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }
}
