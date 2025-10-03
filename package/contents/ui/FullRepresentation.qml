/*
 *  Copyright 2019 Davide Sandona' <sandona.davide@gmail.com>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>
 */

import QtQuick 2.2
import QtQuick.Controls as QtControls
import QtQuick.Layouts

import org.kde.kirigami as Kirigami
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents

import QtLocation 5.15
import QtPositioning 5.15


Item {
    readonly property int mapZoomLevel: Plasmoid.configuration.mapZoomLevel
    readonly property bool layoutRow: Plasmoid.configuration.layoutRow
    readonly property bool showHostname: Plasmoid.configuration.showHostname
    readonly property bool useLabelThemeColor: Plasmoid.configuration.useLabelThemeColor
    readonly property string labelColor: Plasmoid.configuration.labelColor
    readonly property bool useLinkThemeColor: Plasmoid.configuration.useLinkThemeColor
    readonly property string linkColor: Plasmoid.configuration.linkColor

    id: fullRoot
    // Automatically adapt to the GridLayout’s implicit size
    width: labelsContainer.implicitWidth
    height: labelsContainer.implicitHeight
    Layout.preferredWidth: labelsContainer.implicitWidth
    Layout.preferredHeight: labelsContainer.implicitHeight

    GridLayout {
        id: labelsContainer
        flow: GridLayout.LeftToRight
        columns: 2

        QtControls.Label {
            text: i18n("IP address:")
            color: useLabelThemeColor ? Kirigami.Theme.textColor : labelColor
        }

        LabelDelegate {
            text: jsonData !== undefined && jsonData.ip ? jsonData.ip : "N/A"
        }

        QtControls.Label {
            text: i18n("Country:")
            color: useLabelThemeColor ? Kirigami.Theme.textColor : labelColor
        }

        LabelDelegate {
            text: jsonData !== undefined && jsonData.country ? jsonData.country : "N/A"
        }

        QtControls.Label {
            text: i18n("Region:")
            color: useLabelThemeColor ? Kirigami.Theme.textColor : labelColor
        }

        LabelDelegate {
            text: jsonData !== undefined && jsonData.region ? jsonData.region : "N/A"
        }

        QtControls.Label {
            text: i18n("Postal Code:")
            color: useLabelThemeColor ? Kirigami.Theme.textColor : labelColor
        }

        LabelDelegate {
            text: jsonData !== undefined && jsonData.postal ? jsonData.postal : "N/A"
        }

        QtControls.Label {
            text: i18n("City:")
            color: useLabelThemeColor ? Kirigami.Theme.textColor : labelColor
        }

        LabelDelegate {
            text: jsonData !== undefined && jsonData.city ? jsonData.city : "N/A"
        }

        QtControls.Label {
            text: i18n("Coordinates:")
            color: useLabelThemeColor ? Kirigami.Theme.textColor : labelColor
        }

        LabelDelegate {
            text: jsonData !== undefined && jsonData.loc ? jsonData.loc : "N/A"
        }

        QtControls.Label {
            text: i18n("Hostname:")
            color: useLabelThemeColor ? Kirigami.Theme.textColor : labelColor
            visible: showHostname
        }

        LabelDelegate {
            text: jsonData !== undefined && jsonData.hostname ? jsonData.hostname : "N/A"
            visible: showHostname
        }

        QtControls.Button {
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            text: jsonData !== undefined ? i18n("Open map in the browser") : "N/A"
            visible: jsonData !== undefined
            onClicked: {
                let mapLink = "https://www.openstreetmap.org/?mlat=" + latitude + "&mlon=" + longitude + "#map=" + mapZoomLevel + "/" + latitude + "/" + longitude
                debug_print("[showMap onClicked] " + mapLink)
                Qt.openUrlExternally(mapLink)
            }
        }

        QtControls.Button {
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: parent.width
            text: i18n("Update")
            onClicked: {
                root._triggerReloadOnClick()
            }
        }

        Map {
            id: map
            plugin: Plugin { name: "mapboxgl" }
            center: QtPositioning.coordinate(59.91, 10.75) // Oslo
            zoomLevel: 14
        }
    }
}
