import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

Scope {
  id: root
  property string time
  readonly property var palette: JSON.parse(jsonPalette.text())

  Variants {
    model: Quickshell.screens;

    delegate: Component {
      PanelWindow {
        id: bar

        required property var modelData
        property var activeWindow
        property var workspaces

        screen: modelData

        // Top bar
        anchors {
          top: true
          left: true
          right: true
        }

        implicitHeight: 25

        color: 'transparent'

        Rectangle {
          color: `#${root.palette.base00}`

          anchors.fill: parent

          radius: 7

          anchors.leftMargin: 15
          anchors.rightMargin: 15
          anchors.topMargin: 5

          Rectangle {
            color: 'transparent'

            anchors.fill: parent

            anchors.leftMargin: 5
            anchors.topMargin: 1
            anchors.rightMargin: 5

            RowLayout {
              Repeater {
                model: bar.workspaces
                delegate:
                  Text {
                    id: delegate
                    required property var modelData
                    font.pixelSize: 14
                    text: modelData.is_active ? "" : ""
                    color: `#${root.palette.base0D}`

                    MouseArea {
                      anchors.fill: parent

                      onClicked: workspaceChanger.running = true;
                    }

                    Process {
                      id: workspaceChanger
                      readonly property var destWorkspace: delegate.modelData.idx
                      command: ["niri", "msg", "action", "focus-workspace", `${destWorkspace}`]
                    }
                }
              }

              Text {
                id: clock

                font.pixelSize: 14
                color: `#${root.palette.base05}`

                text: root.time
              }
            }


            Text {
              id: title

              font.pixelSize: 14

              anchors.centerIn: parent
              color: `#${root.palette.base05}`

              text: bar.activeWindow == null ? "-" : bar.activeWindow.title
            }

            RowLayout {
              anchors.right: parent.right

              Text {
                font.pixelSize: 14

                color: `#${root.palette.base05}`

                text: `MEM 114%`
              }

              Text {
                id: outputName

                font.pixelSize: 14

                color: `#${root.palette.base05}`

                text: bar.screen.name
              }

              Repeater {
                model: SystemTray.items

                delegate: IconImage {
                  required property var modelData
                  backer.source: modelData.icon
                  implicitSize: 18
                  layer.enabled: true
                  layer.effect: MultiEffect {
                    colorization: 1.0
                    colorizationColor: `#${root.palette.base05}`
                  }
                }
              }
            }
          }
        }

        Process {
          id: titleProc
          command: ["niri", "msg", "-j", "focused-window"]
          running: true
          stdout: StdioCollector {
            onStreamFinished: bar.activeWindow = JSON.parse(this.text)
          }
        }

        Process {
          id: workspaceProc
          command: ["niri", "msg", "-j", "workspaces"]
          running: true
          stdout: StdioCollector {
            onStreamFinished: {
              workspaces = JSON.parse(this.text)
              workspaces.sort((a, b) => a.idx-b.idx)
              bar.workspaces = workspaces
            }
          }
        }

        Process {
          id: niriEventProc
          command: ["niri", "msg", "-j", "event-stream"]
          running: true
          stdout: SplitParser {
            onRead: {
              titleProc.running = true;
              workspaceProc.running = true;
            }
          }
        }
      }
    }
  }

  Process {
    id: dateProc
    command: ["date", "+%H:%M"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: root.time = this.text.trim()
    }
  }

  Timer {
    interval: 500
    running: true
    repeat: true
    onTriggered: dateProc.running = true
  }

  FileView {
    id: jsonPalette
    path: "/home/qb114514/.config/stylix/palette.json";
    blockLoading: true

    watchChanges: true
    onFileChanged: reload()
  }
}
