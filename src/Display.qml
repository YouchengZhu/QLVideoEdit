//视频显示模块
//此模块用于播放预览视频效果
//date:2021-06-25
//author:冉杨 朱有成 张新蕾

import QtQuick 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.0
import QtMultimedia 5.15

Item {
    property alias video: video
    property alias player:player
    property alias mediaPlayerPlaybackRate: player.playbackRate

    //播放进度条时间转换
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

    Rectangle{
        id:video
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        color: "black"
        MediaPlayer {
            id: player
            //存放播放的资源
        }

        //绑定并加载容器中的资源，默认为不播放。
        VideoOutput {
            id:playWindow
            anchors.fill: parent
            source: player

        }
        MouseArea{
            anchors.fill: parent
            onClicked:{
                //player.play()
                console.log(video.width)
                console.log(video.x)
            }
        }
    }

    //视频播放控制栏
    Actions{
        id:actions
        pauseAction.onTriggered: {//视频暂停按钮
            pause.action = actions.playAction
            player.play()
        }
        playAction.onTriggered: {//视频播放按钮
            pause.action = actions.pauseAction
            player.pause()
        }
        forwardAction.onTriggered:player.seek(player.position+10000)//快进按钮
        backAction.onTriggered: player.seek(player.position-10000)//后退按钮
        property int status: 0
        fullscreenAction.onTriggered: {//全屏显示视频
            if (status == 0){
                clips.visible = false
                disPlay.width = column.width
                disPlay.height = column.height
                video.width = column.width
                video.height = column.height-100
                wd.resources.visible = false
                disPlay.anchors.left = wd.resources.left
                status = 1
            }else{
                clips.visible = true
                disPlay.width = column.width/2
                disPlay.height = column.height/3*2
                video.width = column.width/2
                video.height = column.height/3*2-80
                wd.resources.visible = true
                disPlay.anchors.left = wd.resources.right
                status = 0
            }
        }
    }
    //播放控制模块
    Row{
        id: control;
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: video.bottom
        anchors.topMargin: 10
        anchors.left: video.left;
        anchors.leftMargin: 5;
        anchors.right: video.right;
        anchors.rightMargin: 5;
        width: video.width - 10;
        height: 55
        spacing: 5
        Row{
            id: row1;
            width: control.width / 7 * 3;
            Button{//快进
                id: btn1;
                width: control.width / 7;
                action: actions.backAction
            }
            Button{//播放
                id:pause
                anchors.left: btn1.right
                width: control.width / 7
                action:actions.pauseAction
            }
            Button{//后退
                id: back
                anchors.left: pause.right
                width: control.width / 7;
                action: actions.forwardAction
            }
        }
        Row{
            id: rowMid
            anchors.left: row1.right
            anchors.leftMargin: 5;
            anchors.rightMargin: 5;
            width: control.width / 7 * 3;
            anchors.verticalCenter: parent.verticalCenter
            Rectangle{
                id: start
                color: "#ecf6ff"
                width: control.width / 7 - 46
                anchors.top:parent.top;
                anchors.topMargin: -26
                height: 48
                opacity: 1
                Text{//显示视频播放时间
                    text: currentTime(player.position)
                    anchors.centerIn: parent;
                }
            }
            Slider{//进度条
                id: slider;
                anchors.left: start.right;
                x: start.width;
                width: control.width / 7 * 2
                anchors.top:parent.top
                anchors.topMargin: -27
                to:player.duration
                from: 0
                stepSize: 1
                value: player.position
                onValueChanged: console.log(value)
            }
            Rectangle{
                color: "#ecf6ff"
                width: control.width / 7 - 46
                anchors.top:parent.top;
                anchors.topMargin: -26
                anchors.left: slider.right
                height: 48
                Text{//显示视频总时长
                    text:currentTime(player.duration)
                    anchors.verticalCenter: parent.verticalCenter;
                }
            }
        }
        Button{//全屏
            anchors.left: rowMid.right;
            anchors.leftMargin: 10;
            width: control.width / 7;
            id:fullScreen
            action:actions.fullscreenAction
        }
    }
}



/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
