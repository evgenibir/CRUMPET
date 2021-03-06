/*
 *   Copyright 2019 Dan Leinir Turthra Jensen <admin@leinir.dk>
 *   Copyright 2019 Ildar Gilmanov <gil.ildar@gmail.com>
 *   This file based on sample code from Kirigami
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 3, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>
 */

import QtQuick 2.7
import QtQuick.Controls 2.4 as QQC2
import org.kde.kirigami 2.13 as Kirigami
import org.thetailcompany.digitail 1.0 as Digitail

Kirigami.ScrollablePage {
    id: control;

    property alias model: commandListView.model
    property Item infoCardFooter: null;

    signal insertCommand(int insertAt, string command, variant destinations);
    signal removeCommand(int index, string command);

    actions {
        main: Kirigami.Action {
            text: qsTr("Add Move To List");
            icon.name: "list-add";
            onTriggered: {
                pickACommand.insertAt = commandListView.count;
                pickACommand.pickCommand();
            }
        }

        right: Kirigami.Action {
            text: qsTr("Add Pause To List");
            icon.name: "accept_time_event";
            onTriggered: {
                commandPausePicker.insertAt = commandListView.count;
                commandPausePicker.pickDuration();
            }
        }
    }

    Component {
        id: commandListDelegate;

        Kirigami.SwipeListItem {
            id: listItem;

            property variant command: {
                "name": "",
                "command": "",
                "minimumCooldown": 0,
                "duration": 0
            }

            property string title: command["name"];

            Component.onCompleted: {
                Digitail.Utilities.getCommand(modelData);
            }

            QQC2.Label {
                text: command["minimumCooldown"] > 0
                        ? qsTr("%1<br/><small>%2 seconds</small><br/><small>Additional cooldown: %3 seconds</small>").arg(title).arg(command["duration"] / 1000).arg(command["minimumCooldown"] / 1000)
                        : qsTr("%1<br/><small>%2 seconds</small>").arg(title).arg(command["duration"] / 1000)

                // Silly, yes, but we can't put it at the proper root of SwipeListItem, as it only wants QQuickItems there
                Connections {
                    target: Digitail.Utilities;

                    onCommandGotten: {
                        if(command.command === modelData) {
                            listItem.command = command;
                        }
                    }
                }
            }

            onClicked: {}

            actions: [
                Kirigami.Action {
                    text: qsTr("Add after");
                    icon.name: "list-add";

                    onTriggered: {
                        pickACommand.insertAt = index + 1;
                        pickACommand.pickCommand();
                    }
                },

                Kirigami.Action {
                    text: qsTr("Add pause after");
                    icon.name: "accept_time_event";

                    onTriggered: {
                        commandPausePicker.insertAt = index + 1;
                        commandPausePicker.pickDuration();
                    }
                },

                Kirigami.Action { separator: true; enabled: false; },

                Kirigami.Action {
                    text: qsTr("Remove from list");
                    icon.name: "list-remove";

                    onTriggered: {
                        control.removeCommand(index, command["command"]);
                    }
                }
            ]
        }
    }

    ListView {
        id: commandListView;
        delegate: commandListDelegate;
        header: InfoCard {
            text: qsTr("This is your list of commands. It can include both moves, glows, and pauses. Tip: To add a new command underneath one you have in the list already, click the add actions shown when you swipe left on the items.");
            footer: control.infoCardFooter
        }
    }

    CommandPausePicker {
        id: commandPausePicker;

        onDurationPicked: {
            control.insertCommand(insertAt, "pause:" + duration);
            commandPausePicker.close();
        }
    }

    PickACommandSheet {
        id: pickACommand;

        property int insertAt;

        onCommandPicked: {
            control.insertCommand(insertAt, "pause:15", destinations);
            control.insertCommand(insertAt, command, destinations);
            pickACommand.close();
        }
    }
}
