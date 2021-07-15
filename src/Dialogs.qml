//对话框模块
//提供对话框的实现
//date:2021-06-25
//author:冉杨 朱有成 张新蕾

import QtQuick 2.0
import QtQuick.Controls 2.5 as QQC
import QtQuick.Dialogs 1.2 as QQD

Item {
    property alias fileOpenDialog: file
    property alias aboutDialog: about
    property alias okToContinueDialog: okToContinue
    property alias saveDialog: save
    property alias inputFileNameDialog: inputFileName
    property alias inputName:inputName

    property alias textDialog: textDialog
    property alias textField: textField
    property alias colorFiled: colorFiled
    property alias fontField: fontField
    property alias outFileFiled: outFileFiled

    property alias divideDialog: divideDialog
    property alias divideFiled0: divideFiled0
    property alias divideFiled1: divideFiled1
    property alias divideTimeFiled: divideTimeFiled
    signal sendInputName(var path);
    signal determineClip;
    signal cancelClip;
    function openFileDialog(){file.open();} //打开文件窗口
    function openAboutDialog(){about.open();} //打开关于窗口
    function openOkToContinueDialog(){okToContinue.open();}//打开询问窗口
    function openSaveDialog(){save.open();}//打开保存窗口
    function openInputFileDialog(){inputFileName.open();}

    //文件窗口
    QQD.FileDialog{
        id:file
        title: "select the file"
        folder: shortcuts.documents
        nameFilters: ["video files(*)"]
    }

    //关于窗口
    QQD.Dialog{
        id:about
        title:"About"
        QQC.Label {
            anchors.fill: parent
            text: qsTr("A QML Txt Viewer\n")
            horizontalAlignment: Text.AlignHCenter
        }
    }

    //询问用户是否进行裁剪窗口
    QQD.Dialog{
        id:okToContinue
        title:"OkToContinue"
        QQC.Label{
            id:label
            anchors.fill: parent;
            text: qsTr("是否确定进行裁剪？")
            horizontalAlignment: Text.AlignHCenter
        }
        standardButtons: QQD.StandardButton.No|QQD.StandardButton.Yes
        onYes: {determineClip()}
        onNo: cancelClip();
    }

    //文件保存窗口
    QQD.FileDialog{
        id: save;
        title: "Save file"
        selectExisting: false
        folder: shortcuts.documents
        selectFolder: true;
    }

    //读取保存文件名窗口
    QQD.Dialog{
        id: inputFileName
        title: "Please input your file name"
        Row{
            QQC.Label{
                text:qsTr("请输入需要的保存文件名：")
            }
            QQC.TextField{
                id: inputName;
            }
        }
        standardButtons: QQD.StandardButton.Yes | QQD.StandardButton.No
    }


    //添加文本对话框
    property var textContent
    property var textColor
    property var textFont
    property var textPosition

    QQD.Dialog {
        id: textDialog
        title: "添加文本对话框"
        visible: false
        height: 260
        Rectangle {
            id: textRectangle
            anchors.fill: parent
            width: 250
            height: 260
//            color: "red"
            x: 15
            visible: true
            //位置
            Column {
                id: positionColumn
                anchors.left: parent.left
                width: 50
                height: 200
                spacing: 0
                Rectangle {
                    id: rect0
                    width: 50
                    height: 50
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("左上")
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            textPosition = 0
                            parent.color = "gray"
                            rect1.color = rect2.color = rect3.color = "white"
                        }
                    }
                }
                Rectangle {
                    id: rect1
                    width: 50
                    height: 50
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("右上")
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            textPosition = 1
                            parent.color = "gray"
                            rect0.color = rect2.color = rect3.color = "white"
                        }
                    }
                }
                Rectangle {
                    id: rect2
                    width: 50
                    height: 50
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("左下")
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            textPosition = 2
                            parent.color = "gray"
                            rect1.color = rect0.color = rect3.color = "white"
                        }
                    }
                }
                Rectangle {
                    id: rect3
                    width: 50
                    height: 50
                    Text {
                        anchors.centerIn: parent
                        text: qsTr("右下")
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            textPosition = 3
                            parent.color = "gray"
                            rect1.color = rect2.color = rect0.color = "white"
                        }
                    }
                }
            }
            Column {
                anchors.left: positionColumn.right
                width: 250
                height: 200
                QQC.TextField {
                    id: textField
                    height: 50
                    width: 300
//                    color: "gray"
                    placeholderTextColor: "grey"
                    placeholderText: qsTr("文本内容")
                }
                QQC.TextField {
                    id: colorFiled
                    height: 50
                    width: 300
                    placeholderTextColor: "grey"
                    placeholderText: qsTr("输入颜色： 英文")
                }
                QQC.TextField{
                    id: fontField
                    height: 50
                    width: 300
                    placeholderTextColor: "grey"
                    placeholderText: qsTr("输入大小：int")
                }
                QQC.TextField {
                    id: outFileFiled
                    height: 50
                    width: 300
                    placeholderTextColor: "grey"
                    placeholderText: qsTr("输入：保存文件名字(*.mp4) ")
                }
            }
        }
        standardButtons: QQD.StandardButton.No | QQD.StandardButton.Yes
    }

    //拆分文本对话框
   property var dividetime
   QQD.Dialog {
           id: divideDialog
           title: "拆分对话框"
           height: 240
           visible: false
           Rectangle {
               id: divideRectangle
               visible: true
               anchors.fill: parent
               width: 300
               height: 165
               Column {
                   id: divideColumn
                   anchors.fill: parent
                   QQC.TextField {
                       id: divideFiled0
                       height: 55
                       width: 300
                       placeholderTextColor: "grey"
                       placeholderText:qsTr("输入保存文件名1（*.mp4)")
                   }
                   QQC.TextField {
                       id: divideFiled1
                       height: 55
                       width: 300
                       placeholderTextColor: "grey"
                       placeholderText:qsTr("输入保存文件名2（*.mp4)")
                   }
                   QQC.TextField {
                       id: divideTimeFiled
                       height: 55
                       width: 300
                       placeholderTextColor: "grey"
                       placeholderText:qsTr("输入拆分时间")
                   }
               }
           }
           standardButtons: QQD.StandardButton.No | QQD.StandardButton.Yes
   }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
