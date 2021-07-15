//裁剪故事板模块
//显示用户添加的资源文件，默认对添加进故事版的文件进行合并操作
//date:2021-06-25
//author:冉杨 朱有成 张新蕾

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.0
import QtMultimedia 5.15
import com.mycomponent.myGLWidget 1.0//导入自定义组件用于显示每个导入视频的第一帧
Item {

    //设置速度切换的信号
    signal speed5()
    signal speed2()
    signal speed1()

    Text {
        id:storyText
        color: "#4f4646"
        text: qsTr("故事板")
        font.bold: true
        font.pixelSize: 36
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 12
        anchors.leftMargin: 35
    }
    //故事板区域工具栏
    Row {
        id:toolBar
        anchors.right: parent.right
        anchors.rightMargin: 10;
        anchors.top: parent.top
        anchors.topMargin: 12
        width: parent.width / 3 * 2;
        height: 50;
        spacing: 0
        Button{//裁剪
            width: parent.width / 10;
            action:actions.cutAction
        }
        Button{//拆分
            width: parent.width / 10
            action: actions.divideAction
        }
        Button{//添加字幕
            width: parent.width / 10
            action:actions.textAction
        }
        Button{//添加动作
            width: parent.width / 10
            action: actions.actAction
        }
        Button{//添加3D效果
            width: parent.width / 10
            action: actions.tdAction
        }
        Button{//添加滤镜
            width: parent.width / 10
            action:actions.filterAction
        }
        Button{//调整速度
            width: parent.width / 10
            id: speedButton
            action:actions.speedAction
        }
        Button{//全屏
            width: parent.width / 10
            action: actions.fullscreenAction
        }
        Button{//旋转
            width: parent.width / 10
            action: actions.rotateAction
        }
        Button{//删除
            width: parent.width / 10
            action: actions.deleteAction
        }
    }

    Actions{
        id:actions
        //设置速度激发动作的可见性
        speedAction.onTriggered: {
            if(speedItem.visible === false) speedItem.visible = true
            else speedItem.visible = false
        }
        //点击裁剪按钮，进入视频编辑界面
        cutAction.onTriggered: {
            wd.resources.visible = false;
            clips.visible = false;
            disPlay.visible = false
            clipsPopUp.visible = true;
            clipsPopUp.infilename = disPlay.player.source;
        }
    }

    //播放速度上下文菜单：可实现0.5-1-2倍数播放
    Item {
        id: speedItem
        x: speedButton.x + 500
        y: speedButton.y + 40
        width: 25
        height: 60
        visible: false
        Column{
            anchors.fill: parent
            focus: true
            Button{
                height: 15
                Text {
                    text: qsTr("0.5")
                }
                onClicked: speed5()
            }
            Button{
                height: 15
                Text {
                    text: qsTr("1")
                }
                onClicked: speed1()
            }
            Button{
                Text {
                    text: qsTr("2")
                }
                height: 15
                onClicked: speed2()
            }
        }
    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
