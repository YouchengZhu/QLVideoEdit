//主窗口
//包含菜单栏、资源导入区域、视频播放区域、视频编辑区域
//date:2021-06-25
//author:冉杨 朱有成 张新蕾

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.0
import com.mycomponent.myGLWidget 1.0//导入自定义组件用于显示每个导入视频的第一帧
import QtMultimedia 5.15

ApplicationWindow {
    id:wd
    width: 1480
    height: 900
    visible: true
    minimumWidth: 1480;//界面最小宽
    minimumHeight: 900;//界面最小高

    property alias resources: resources
    property var delRepeatEle: []
    property alias clipsPopUp: clipsPopUp

    //菜单栏
    Header{
        id:header
        onArrayFinished: {
            resources.videoItem.fileSources = [];
            resources.videoItem.fileSources = array;
            array = [];
        }
    }
    Column{
        id:column
        anchors.fill: parent
        anchors.topMargin: 55
        Row{
            width: parent.width
            height: parent.height/3*2
            //资源导入区域
            Resources {
                id:resources
                width: parent.width/2
                height: parent.height
                Connections{
                    target: header
                    onArrayChanged:{
                        videoItem.fileSources.push(array[0]);
                    }
                }
            }
            //视频显示播放区域
            Display{
                id:disPlay
                width: parent.width/2
                height: parent.height
                video.width: parent.width/2
                video.height:parent.height-80
                anchors.left: resources.right
            }
        }
        //视频编辑区域
        Clips {
            id:clips
            width: parent.width
            height:parent.height/3
            Connections{
                target: resources
                onSendIndex:{
                    resources.selectFileArray.push(resources.videoItem.fileSources[currentIndex])
                    //去掉重复添加的元素
                    for(var i = 0; i < resources.selectFileArray.length; i++)
                    {
                        if(wd.delRepeatEle.indexOf(resources.selectFileArray[i]) < 0)
                        {
                            clipsVideoItem.selectStatus = 1;//修改为选择标题卡状态
                            wd.delRepeatEle.push(resources.selectFileArray[i]);
                            clipsVideoItem.fileSources = wd.delRepeatEle;
                            //添加到播放列表
                            clipsPopUp.videoEdit.videoMerge(wd.delRepeatEle);
                            disPlay.player.source = "file:///" + appPath + "/final" + wd.delRepeatEle.length + ".mp4"
                        }
                    }
                }
            }

            //自定义组件，显示视频文件的第一帧
            VideoItem{
                id: clipsVideoItem
                width: parent.width;
                height: 105
                anchors.left: parent.left;
                anchors.right: parent.right;
                anchors.top: parent.top;
                anchors.topMargin: 80;
                anchors.leftMargin: 40
                currentIndex: -1;
                column: 7
                MouseArea{
                    anchors.fill: parent;
                    onClicked:{
                        var col = parseInt(mouse.x / 127);//所点击图片所在列
                        var row = parseInt(mouse.y / 100);//所点击图片所在行
                        var index = row * clipsVideoItem.column + col;
                        clipsVideoItem.currentIndex = index;
                    }
                }
            }
        }
    }
    Actions{
        id:actions
    }

    //实现播放速度的调整
    Connections{
        target: clips
        onSpeed1: {
            console.log("oncli")
            disPlay.mediaPlayerPlaybackRate = 1.0
        }
        onSpeed2: {
            console.log("onspped2")
            disPlay.mediaPlayerPlaybackRate = 2.0
        }
        onSpeed5: {
            console.log("onspedd0.5")
            disPlay.mediaPlayerPlaybackRate = 0.5
        }
    }
    //视频编辑区域
    ClipsPopUp{
        id: clipsPopUp;
        visible: false;
        anchors.top: parent.top
        anchors.topMargin:40
        width: wd.width;
        height: wd.height;
    }
    onClosing:{//窗口关闭事件处理
        wd.clipsPopUp.videoEdit.delFinal(wd.delRepeatEle.length,disPlay.player.source)
    }
}

