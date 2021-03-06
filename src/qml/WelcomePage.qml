/*
 *   Copyright 2018 Dan Leinir Turthra Jensen <admin@leinir.dk>
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

import QtQuick 2.11
import QtQuick.Controls 2.11
import QtQuick.Layouts 1.11
import org.kde.kirigami 2.13 as Kirigami
import org.thetailcompany.digitail 1.0 as Digitail

Kirigami.ScrollablePage {
    id: root;
    objectName: "welcomePage";
    title: qsTr("Crumpet");
    actions {
        main: Kirigami.Action {
            text: BTConnectionManager.isConnected ? "Disconnect" : "Connect";
            icon.name: BTConnectionManager.isConnected ? "network-disconnect" : "network-connect";
            onTriggered: {
                if(BTConnectionManager.isConnected) {
                    BTConnectionManager.disconnectDevice("");
                }
                else {
                    if(BTConnectionManager.deviceCount === 1) {
                        BTConnectionManager.stopDiscovery();
                    }
                    else {
                        connectToTail.open();
                    }
                }
            }
        }
        right: (BTConnectionManager.isConnected && DeviceModel !== null && DeviceModel.rowCount() > 1) ? connectMoreAction : null
    }
    property QtObject connectMoreAction: Kirigami.Action {
        text: qsTr("Connect More...");
        icon.name: "list-add";
        onTriggered: connectToTail.open();
    }

    ScrollView {
        id: scrollView;
        Layout.fillWidth: true;
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        ColumnLayout {
            width: scrollView.availableWidth
            TailBattery {
                Layout.fillWidth: true;
            }
            NotConnectedCard { }
            Item { height: Kirigami.Units.smallSpacing; Layout.fillWidth: true; }
            Kirigami.AbstractCard {
                contentItem: ColumnLayout {
                    Kirigami.BasicListItem {
                        text: qsTr("Moves");
                        visible: opacity > 0;
                        opacity: connectedDevicesModel.count > 0 ? 1 : 0;
                        Behavior on opacity { PropertyAnimation { duration: Kirigami.Units.shortDuration; } }
                        icon: ":/images/moves.svg";
                        separatorVisible: false;
                        onClicked: {
                            switchToPage(tailMoves);
                        }
                        Kirigami.Icon {
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight;
                            Layout.margins: Kirigami.Units.smallSpacing;
                            width: Kirigami.Units.iconSizes.small;
                            height: width;
                            source: "go-next";
                        }
                    }
                    Kirigami.BasicListItem {
                        text: qsTr("Ear Poses");
                        visible: opacity > 0;
                        opacity: hasListeningDevicesRepeater.count > 0 ? 1 : 0;
                        Behavior on opacity { PropertyAnimation { duration: Kirigami.Units.shortDuration; } }
                        icon: ":/images/earposes.svg";
                        separatorVisible: false;
                        onClicked: {
                            switchToPage(earPoses);
                        }
                        Kirigami.Icon {
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight;
                            Layout.margins: Kirigami.Units.smallSpacing;
                            width: Kirigami.Units.iconSizes.small;
                            height: width;
                            source: "go-next";
                        }
                    }
                    Kirigami.BasicListItem {
                        text: qsTr("Glow Tips");
                        visible: opacity > 0;
                        opacity: connectedDevicesModel.count > hasListeningDevicesRepeater.count ? 1 : 0;
                        Behavior on opacity { PropertyAnimation { duration: Kirigami.Units.shortDuration; } }
                        icon: ":/images/glowtip.svg";
                        separatorVisible: false;
                        onClicked: {
                            switchToPage(tailLights);
                        }
                        Kirigami.Icon {
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight;
                            Layout.margins: Kirigami.Units.smallSpacing;
                            width: Kirigami.Units.iconSizes.small;
                            height: width;
                            source: "go-next";
                        }
                    }
                    Item { height: Kirigami.Units.smallSpacing; Layout.fillWidth: true; visible: connectedDevicesModel.count > 0; }
                    Kirigami.BasicListItem {
                        text: qsTr("Alarm");
                        icon: ":/images/alarm.svg";
                        separatorVisible: false;
                        onClicked: {
                            switchToPage(alarmList);
                        }
                        Kirigami.Icon {
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight;
                            Layout.margins: Kirigami.Units.smallSpacing;
                            width: Kirigami.Units.iconSizes.small;
                            height: width;
                            source: "go-next";
                        }
                    }
                    Kirigami.BasicListItem {
                        text: qsTr("Move List");
                        icon: ":/images/movelist.svg";
                        separatorVisible: false;
                        onClicked: {
                            switchToPage(moveLists);
                        }
                        Kirigami.Icon {
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight;
                            Layout.margins: Kirigami.Units.smallSpacing;
                            width: Kirigami.Units.iconSizes.small;
                            height: width;
                            source: "go-next";
                        }
                    }
//                     Item { height: Kirigami.Units.smallSpacing; Layout.fillWidth: true; }
//                     Kirigami.BasicListItem {
//                         text: qsTr("Poses");
//                         icon: ":/images/tail.svg";
//                         separatorVisible: false;
//                         onClicked: {
//                             showPassiveNotification(qsTr("Sorry, nothing yet..."), 1500);
//                         }
//                         Kirigami.Icon {
//                             Layout.alignment: Qt.AlignVCenter | Qt.AlignRight;
//                             Layout.margins: Kirigami.Units.smallSpacing;
//                             width: Kirigami.Units.iconSizes.small;
//                             height: width;
//                             source: "go-next";
//                         }
//                     }
                }
            }
            Item { height: Kirigami.Units.smallSpacing; Layout.fillWidth: true; }
            Kirigami.AbstractCard {
                visible: opacity > 0;
                opacity: BTConnectionManager.isConnected ? 1 : 0;
                Behavior on opacity { PropertyAnimation { duration: Kirigami.Units.shortDuration; } }
                Layout.fillWidth: true;
                header: RowLayout {
                        Kirigami.Icon {
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft;
                            Layout.margins: Kirigami.Units.smallSpacing;
                            width: Kirigami.Units.iconSizes.small;
                            height: width;
                            source: ":/images/casualmode.svg"
                        }
                        Kirigami.Heading {
                            text: qsTr("Casual Mode");
                            Layout.fillWidth: true;
                        }
                        CheckBox {
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight;
                            Layout.margins: Kirigami.Units.smallSpacing;
                            height: Kirigami.Units.iconSizes.small;
                            width: height;
                            checked: AppSettings !== null ? AppSettings.idleMode : false;
                            onClicked: { AppSettings.idleMode = !AppSettings.idleMode; }
                        }
                }
                Component {
                    id: casualModeSettingsListItem
                    Kirigami.BasicListItem {
                            text: qsTr("Casual Mode Settings");
                            Layout.fillWidth: true;
                            separatorVisible: false;
                            icon: "settings-configure";
                            onClicked: switchToPage(idleModePage);
                        }
                }
                Component {
                    id: idlePauseRangePicker;

                    ColumnLayout {
                        Layout.fillWidth: true;
                        IdlePauseRangePicker {
                        }
                        Loader {
                            Layout.fillWidth: true;
                            sourceComponent: casualModeSettingsListItem
                        }
                    }
                }
                Component {
                    id: emptyNothing;
                    Loader {
                        sourceComponent: casualModeSettingsListItem
                    }
                }
                contentItem: Loader {
                    sourceComponent: (AppSettings !== null && AppSettings.idleMode === true) ? idlePauseRangePicker : emptyNothing;
                }
            }
            Item { height: Kirigami.Units.smallSpacing; Layout.fillWidth: true; }
            Kirigami.AbstractCard {
                visible: opacity > 0;
                opacity: hasListeningDevicesRepeater.count > 0 ? 1 : 0;
                Behavior on opacity { PropertyAnimation { duration: Kirigami.Units.shortDuration; } }
                Layout.fillWidth: true;
                header: RowLayout {
                    Kirigami.Icon {
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft;
                        Layout.margins: Kirigami.Units.smallSpacing;
                        width: Kirigami.Units.iconSizes.small;
                        height: width;
                        source: ":/images/listeningmode.svg"
                    }
                    Kirigami.Heading {
                        text: qsTr("Listening Mode");
                        Layout.fillWidth: true;
                        Digitail.FilterProxyModel {
                            id: connectedDevicesModel
                            sourceModel: DeviceModel;
                            filterRole: 262; // the isConnected role
                            filterBoolean: true;
                        }
                    }
                }
                contentItem: Column {
                    id: listeningColumn;
                    Layout.fillWidth: true;
                    height: childrenRect.height;
                    spacing: 0;
                    Label {
                        width: parent.width;
                        wrapMode: Text.Wrap;
                        text: qsTr("Turn this on to make your gear react to sounds around it for five minutes at a time.");
                    }
                    Repeater {
                        id: hasListeningDevicesRepeater;
                        model: Digitail.FilterProxyModel {
                            sourceModel: connectedDevicesModel;
                            filterRole: 265; // the hasListening role
                            filterBoolean: true;
                        }
                        Kirigami.BasicListItem {
                            width: listeningColumn.width;
                            separatorVisible: false;
                            icon: model.listeningState > 0 ? ":/icons/breeze-internal/emblems/16/checkbox-checked" : ":/icons/breeze-internal/emblems/16/checkbox-unchecked";
                            label: model.name;
                            onClicked: {
                                var newState = 0;
                                if (model.listeningState == 0) {
                                    newState = 1;
                                }
                                BTConnectionManager.setDeviceListeningState(model.deviceID, newState);
                            }
                        }
                    }
                }
            }
    //         Button {
    //             text: qsTr("Tailkiller! Slow Wag 1 + 3sec pause loop");
    //             Layout.fillWidth: true;
    //             onClicked: {
    //                 for(var i = 0; i < 1000; ++i) {
    //                     CommandQueue.pushCommand(CommandModel.getCommand(1));
    //                     CommandQueue.pushPause(3000);
    //                 }
    //             }
    //         }
        }
    }
}
