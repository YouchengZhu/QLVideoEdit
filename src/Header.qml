//菜单栏模块
//提供所有按钮的实现
//date:2021-06-25
//author:冉杨 朱有成 张新蕾

import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtMultimedia 5.15
import QtQuick.Controls.Material 2.0

Item {
    id:wind
    anchors.fill: parent

    property var array: []
    signal arrayFinished;

    ToolBar{
        id:toolBar
        width: parent.width
        height: 50
        RowLayout{
            id:row
            width: 175
            height: parent.height
            ToolButton{//文件菜单
                text: "文件"
                MouseArea{
                    anchors.fill: parent
                    onClicked:fileMenu.open()
                }
            }
            ToolButton{//帮助菜单
                text: "帮助"
                MouseArea{
                    anchors.fill: parent
                    onClicked:helpMenu.open()
                }
            }
        }
        RowLayout{
            anchors.top: parent.top;
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            Button{
                id: btn1
                width: 80;
                opacity: 0.7//上一步
                action: actions.lastStepAction
            }
            Button{
                id:btn2
                anchors.left: btn1.right
                width: 80;
                opacity: 0.7//下一步
                action: actions.nextStepAction
            }
            Button{
                id: btn3
                anchors.left: btn2.right;
                opacity: 0.7//背景音乐
                action: actions.musicAction
            }
            Button{//完成视频
                anchors.left: btn3.right
                width: btn3.width;
                opacity: 0.7
                action:actions.finishAction
            }
        }
        Actions{
            id:actions
            aboutAction.onTriggered: dialogs.openAboutDialog();//打开文件窗口
            openAction.onTriggered: dialogs.openFileDialog();//打开about窗口
            exitAction.onTriggered: {//退出窗口
                wd.clipsPopUp.videoEdit.delFinal(wd.delRepeatEle.length)
                Qt.quit();
            }
            finishAction.onTriggered: {//完成视频按钮
                dialogs.openSaveDialog();
            }
        }

        Dialogs{
            id:dialogs
            fileOpenDialog.selectMultiple: true
            fileOpenDialog.onAccepted:{//添加视频文件资源
                for (var i = 0; i < fileOpenDialog.fileUrls.length;i++){
                    array.push(fileOpenDialog.fileUrls[i])
                }
                arrayFinished();
            }

            saveDialog.onAccepted: {//保存
                inputFileNameDialog.open();
            }
            inputFileNameDialog.onYes: {//从用户处获取文件名
                var dstSource = saveDialog.folder +"/" +inputName.text + ".mp4";
                console.log("dstSource"+dstSource)
                wd.clipsPopUp.videoEdit.finishFile(dstSource,disPlay.player.source)//第一个参数为目的地址，第二个参数为源地址

            }
        }

        Menu{//文件菜单
            id:fileMenu
            x:0
            y:row.height
            MenuItem{
                action: actions.openAction
            }
            MenuItem{
                action:actions.saveAction
            }
            MenuItem{
                action: actions.exitAction
            }
        }
        Menu{//帮助菜单
            id:helpMenu
            x:row.width/2
            y:row.height
            MenuItem{
                action:actions.aboutAction
            }
        }

    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;formeditorZoom:1.33;height:480;width:640}
}
##^##*/
