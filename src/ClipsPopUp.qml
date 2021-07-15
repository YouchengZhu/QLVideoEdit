//视频编辑界面
//提供所有视频编辑的功能：裁剪、添加logo、拆分
//date:2021-06-25
//author:冉杨 朱有成 张新蕾

import QtQuick 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.15
import QtMultimedia 5.15
import QtQml 2.15
import VideoEdit 1.0
import QtQuick.Dialogs 1.3
Item {
    property alias videoEdit: videoEdit;
    property var infilename
    property var outfilename
    property var outfilename2
    property var starttime
    property var endtime

    //播放进度条时间转化
    function currentTime(time)
    {
        var sec= Math.floor(time/1000);
        var hours=Math.floor(sec/3600);
        var minutes=Math.floor((sec-hours*3600)/60);
        var seconds=sec-hours*3600-minutes*60;
        var hh,mm,ss;
        if(hours.toString().length<2)
            hh="0"+hours.toString();
        else
            hh=hours.toString();
        if(minutes.toString().length<2)
            mm="0"+minutes.toString();
        else
            mm=minutes.toString();
        if(seconds.toString().length<2)
            ss="0"+seconds.toString();
        else
            ss=seconds.toString();
        return hh+":"+mm+":"+ss
    }
    //返回主界面
    Row{
        id: header;
        anchors.top: parent;
        anchors.left: parent.left
        anchors.right: parent.right;
        ToolBar{
            ToolButton{
                id: backButton
                action: actions.returnAction
            }
        }
    }
    //视频编辑工具栏
    Row{
        anchors.top: header.bottom;
        anchors.left: parent.left;
        anchors.right: parent.right;
        anchors.bottom: parent.bottom;
        Column{
            id: leftLayout
            width: parent.width * 5/6;
            anchors.top: parent.top;
            anchors.bottom: parent.bottom;
            Row{
                x: (leftLayout.width - width)/2
                id: topLayout;
                anchors.top: parent.top;
                anchors.topMargin: 4
                spacing: 0
                //工具栏
                Button{//裁剪
                    id: cutButton
                    width: 100
                    height: 60
                    action:actions.cutAction
                }
                Button{//拆分
                    id: divideButton
                    width: 100
                    height: 60
                    action: actions.divideAction
                }
                Button{//添加字幕
                    width: 100
                    height: 60
                    action:actions.textAction
                }
                Button{//添加动作
                    width: 100
                    height: 60
                    action: actions.actAction
                }
                Button{//添加3D效果
                    width: 100
                    height: 60
                    action: actions.tdAction
                }
                Button{//添加滤镜
                    width: 100
                    height: 60
                    action:actions.filterAction
                }
            }
            //按钮高亮
            Rectangle{
                id: highLight;
                anchors.top: topLayout.bottom;
                anchors.topMargin: 3;
                width: 84;
                color: "lightgray"
                height: 8;
                visible: false;
            }
            //媒体播放窗口
            Rectangle{
                id: middle
                anchors.top: topLayout.bottom
                anchors.topMargin: 20;
                anchors.bottom: control.top;
                anchors.bottomMargin: 20
                anchors.left: parent.left;
                anchors.leftMargin: 20
                anchors.right: parent.right;

                MediaPlayer {
                    id: player
                    source: infilename
                }
                VideoOutput{
                    id: playWindow
                    anchors.fill: parent;
                    source: player
                }
            }
            Row{
                //控制条
                id:control;
                height: 40
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 60;
                anchors.left: parent.left;
                anchors.right: parent.right;
                Row{
                    width: middle.width - 40
                    x: 22 + (middle.width - 620) / 2
                    Row{
                        id: leftRow
                        Button{//快进
                            width: 100
                            action: actions.backAction
                        }
                        Button{//播放
                            id:pause
                            width: 100
                            action:actions.pauseAction
                        }
                        Button{//后退
                            width: 100
                            action: actions.forwardAction
                        }
                    }
                    Rectangle{
                        color: "#ecf6ff"
                        id: rectLeft;
                        anchors.top: parent.top
                        anchors.left: leftRow.right
                        anchors.leftMargin: 5
                        width: 80
                        height: 50
                    Text{
                        id: start
                        anchors.centerIn: rectLeft
                        text: currentTime(slider.first.value)
                        //anchors.verticalCenter: parent.verticalCenter;
                    }
                    }
                    //双向滑块 选中视频区间
                    RangeSlider{

                        id: slider
                        anchors.left: rectLeft.right
                        width: 160;
                        from: 0;
                        to: player.duration;
                        stepSize: 1;
                        first.value: 0;//初始化第一个滑块的位置
                        second.value: player.duration;//初始化第二个滑块的位置
                    }
                    Rectangle{
                        id: rightRect
                        color: "#ecf6ff"
                        anchors.top: parent.top;
                        width: 80;
                        height: 50;
                        anchors.left: slider.right;
                    Text{
                        id: end;
                        text: currentTime(slider.second.value)
                        anchors.centerIn: rightRect
                    }
                    }
                    Timer{
                        id: timer
                        running: false;
                        repeat: false;
                        onTriggered: player.pause();
                    }
                }
            }
        }
        Column{
            id: rigntLayout
            anchors.right: parent.right;
            anchors.top: parent.top;
            anchors.left: leftLayout.right;
            anchors.bottom: parent.bottom;
            Rectangle{
                id: rectangle
                anchors.horizontalCenter: parent.horizontalCenter
                Text{
                    x: (parent.width - width)/2
                    text: qsTr("裁剪")
                    anchors.top: parent.top;
                    anchors.topMargin: 10;
                    font.pointSize: 15
                }
            }
            ToolBar{
                x: (parent.width - width)/2
                width: 80
                anchors.bottom: parent.bottom;
                anchors.bottomMargin: 50
                RowLayout{
                    anchors.fill: parent;
                    //完成剪辑按钮
                    ToolButton{
                        id: finishButton;
                        anchors.fill: parent;
                        text: qsTr("完成")
                        MouseArea{
                            anchors.fill: parent;
                            onClicked:{
                                dialogs.openOkToContinueDialog();
                            }
                        }
                        Connections{//视频裁剪
                            target: dialogs.okToContinueDialog
                            onYes: {//确认裁剪视频操作
                            videoEdit.videoIntercept(infilename,"file:///" + appPath + "/afterIntercept.mp4", slider.first.value/1000, slider.second.value/ 1000)
                            disPlay.player.source = "file:///" + appPath + "/afterIntercept.mp4"
                            //重新指定播放窗口的视频源
                            }
                        }
                    }
                }

            }
        }
    }
    Actions{
        id: actions
        pauseAction.onTriggered: {//视频暂停按钮
            timer.interval = slider.second.value - slider.first.value;
            timer.running = true;
            pause.action = actions.playAction
            player.seek(slider.first.value)
            player.play()
            console.log(slider.second.value - slider.first.value)
        }
        playAction.onTriggered: {//视频播放按钮
            pause.action = actions.pauseAction
            player.pause()
        }
        forwardAction.onTriggered:player.seek(player.position+10000)//快进
        backAction.onTriggered: player.seek(player.position-10000)//后退
        returnAction.onTriggered: {//返回主界面
            wd.resources.visible = true;
            clips.visible = true;
            disPlay.visible = true
            clipsPopUp.visible = false;
        }
        cutAction.onTriggered: {//视频裁剪按钮
            highLight.visible = true;
            highLight.anchors.left = topLayout.left;
            highLight.anchors.leftMargin = 0;
        }
        divideAction.onTriggered: {//视频拆分按钮
            dialogs.divideDialog.visible = true
        }

        textAction.onTriggered: {//添加logo按钮
            console.log(infilename);
            dialogs.textDialog.visible = true
        }
    }

    //编辑视频类：有裁剪，拆分，添加文本等功能
    VideoEdit {
        id: videoEdit
    }

    //提示窗口
    Dialog {
       id: videoEditDialog
        title: "提示"
        property alias text: content.text
        Label {
            id: content
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
        }

        standardButtons: StandardButton.Ok
    }

    //添加文本对话框
    Dialogs{
        id:dialogs
        textDialog.onYes: {//确认添加logo,进行添加logo的操作
            textContent = textField.text
            textColor = colorFiled.text
            textFont = fontField.text
            outfilename = "/root/" + outFileFiled.text
            var ret = videoEdit.addText(infilename, outfilename, textContent, textColor , textFont, textPosition)
            if(ret === 0) {
                videoEditDialog.text = "文字添加成功"
                videoEditDialog.open()
                console.log("sucess")
            }else {
                videoEditDialog.text = "文字添加失败"
                videoEditDialog.open()
                console.log("failed")
            }
            textField.text = ""
            colorFiled.text = ""
            fontField.text = ""
            outFileFiled.text = ""
        }
        textDialog.onNo: {//取消添加logo
            textField.text = ""
            colorFiled.text = ""
            fontField.text = ""
            outFileFiled.text = ""
        }

        divideDialog.onYes: {//确认拆分视频操作
            outfilename = "/root/" + divideFiled0.text
            outfilename2 ="/root/" + divideFiled1.text
            dividetime = divideTimeFiled.text
            console.log(outfilename)
            console.log(outfilename2)
            console.log(dividetime)
            var ret = videoEdit.videoSplit(infilename, outfilename, outfilename2, dividetime)
            if(ret === 1) {
                videoEditDialog.text = "视频拆分成功"
                videoEditDialog.open()
                console.log("sucess")
            }else {
                videoEditDialog.text = "视频拆分失败"
                videoEditDialog.open()
                console.log("failed")
            }
            divideFiled0.text = ""
            divideFiled1.text = ""
            divideTimeFiled.text = ""
        }
        divideDialog.onNo: {//取消拆分视频操作
            divideFiled0.text = ""
            divideFiled1.text = ""
            divideTimeFiled.text = ""
        }
    }
}



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
