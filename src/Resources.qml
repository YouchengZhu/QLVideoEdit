//资源模块
//显示所有导入视频文件
//date:2021-06-25
//author:冉杨 朱有成 张新蕾

import QtQuick 2.15
import QtQuick.Controls 2.0
import QtMultimedia 5.15
import com.mycomponent.myGLWidget 1.0//导入自定义组件用于显示每个导入视频的第一帧
Item {
    property alias addButton:addButton
    property alias videoItem: videoItem
    property var selectFileArray: []
    signal sendIndex(int currentIndex)
    Text {
        id:text1
        text: qsTr("项目库")
        font.pixelSize: 20
        font.bold: true
        anchors.leftMargin: 25
        anchors.top: parent.top
        anchors.topMargin: 15
        anchors.left: parent.left
    }
    Column{
        width: parent.width-text1.anchors.leftMargin
        height: parent.height-text1.height-30
        anchors.top: text1.bottom
        anchors.topMargin: 15
        anchors.left: parent.left
        anchors.leftMargin: 25

        Button{
            id:addButton
            x: 10
            y:10
            action:actions.addAction
        }
        VideoItem{//自定义组件，显示视频文件的第一帧图片
            id: videoItem
            x: 10;
            anchors.top: addButton.bottom;
            anchors.topMargin: 10;
            anchors.left: addButton.left;
            anchors.right: parent.right
            anchors.rightMargin: 20
            width: parent.width
            height: parent.height - 80
            focus: true;
            currentIndex: -1;
            column: 6//设置每行图片的个数
            MouseArea{
                anchors.fill: parent;
                acceptedButtons: Qt.RightButton

                onClicked:{
                    contextMenu.x = mouse.x
                    contextMenu.y = mouse.y
                    contextMenu.open()

                    var col = parseInt(mouse.x / 127);//所点击图片所在列

                    var row = parseInt(mouse.y / 100);//所点击图片所在行

                    var index = row * videoItem.column + col;
                    //console.log("currentIndex = " + index)
                    videoItem.currentIndex = index;
                }

            }
            Menu{//上下文菜单
                id:contextMenu
                MenuItem{
                    action: actions.insertFragmentAction//插入到情景框
                }
                MenuItem{
                    action: actions.deleteresourceAction
                }
            }
        }
    }
    Actions{
        id:actions
        insertFragmentAction.onTriggered:{
            sendIndex(videoItem.currentIndex);
        }
    }


}

