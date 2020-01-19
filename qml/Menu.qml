import Felgo 3.0
import QtQuick 2.5
import QtQuick.Controls 2.0 as Quick2


Quick2.ComboBox {
currentIndex: 0
  property alias data: comboBox.model
  id: comboBox
//  implicitWidth: dp(120) + 20
//  implicitHeight: dp(24) + topPadding + bottomPadding
  padding: dp(12)
  opacity:0.7
model: ListModel {
    ListElement { key: "First"; value: 123 }
    ListElement { key: "Second"; value: 456 }
    ListElement { key: "Third"; value: 789 }
}
  // overwrite style for density independent sizes
  delegate: Quick2.ItemDelegate {
//    width: comboBox.implicitWidth
//    height: comboBox.implicitHeight
    padding: dp(12)
    contentItem: AppText {
      text: fileName//modelData
      color: highlighted ? Theme.tintColor : Theme.textColor
      wrapMode: Text.NoWrap
    }
    highlighted: comboBox.highlightedIndex == index
  }

  contentItem: AppText {
    width: comboBox.width - comboBox.indicator.width - comboBox.spacing
    text: comboBox.currentIndex
    wrapMode: Text.NoWrap
  }
}
