//Action对应模块
//提供所有的Action的定义
//date:2021-06-25
//author:冉杨 朱有成 张新蕾
import QtQuick 2.12
import QtQuick.Controls 2.12


Item {
    property alias openAction:open
    property alias exitAction:exit
    property alias saveAction:save
    property alias aboutAction:about
    property alias lastStepAction: lastStep
    property alias nextStepAction: nextStep
    property alias musicAction: music
    property alias cutAction: cut
    property alias divideAction: divide
    property alias textAction: text
    property alias actAction: act
    property alias tdAction: td
    property alias filterAction: filter
    property alias speedAction: speed
    property alias backAction: back
    property alias forwardAction: forward
    property alias playAction: play
    property alias fullscreenAction: fullScreen
    property alias rotateAction: rotate
    property alias deleteAction: deleteAction
    property alias finishAction: finish
    property alias addAction: add
    property alias deleteresourceAction: deleteReource
    property alias insertFragmentAction: insertFragment
    property alias pauseAction: pause
    property alias returnAction: returnAction

    /*********菜单栏**************/
    //文件打开
    Action {
        id: open
        text: qsTr("打开")
        icon.name: "document-new"
        shortcut: "StandardKey.Open"
    }

    //文件保存
    Action {
        id:save
        text: qsTr("保存")
        icon.name:"document-save"
        shortcut: "StandardKey.Save"
    }
    //文件退出
    Action{
        id: exit
        text: qsTr("退出")
        icon.name: "application-exit"
        shortcut: "StandarKey.Exit"
    }
    //关于
    Action {
        id:about
        text: qsTr("关于")
        icon.name: "help-about"
    }

    //上一步
    Action {
        id:lastStep
        icon.name: "edit-undo"
    }

    //下一步
    Action {
        id:nextStep
        icon.name: "edit-redo"
    }

    //背景音乐
    Action{
        id:music
        icon.name:"audio-x-generic"
        text: qsTr("背景音乐")
    }

    //添加
    Action {
        id:add
        icon.name:"list-add"
    }

    /***********视频编辑工具栏**********/

    //裁剪
    Action {
        id:cut
        text: qsTr("裁剪")
    }

    //拆分
    Action {
        id:divide
        text: qsTr("拆分")
    }

    //文本(添加字幕)
    Action {
        id:text
        icon.name: "insert-text"
        text: qsTr("文本")

    }

    //添加动作
    Action {
        id:act
        text: qsTr("动作")
    }

    //添加3D效果
    Action {
        id:td
        text: qsTr("3D效果")
    }

    //添加滤镜
    Action {
        id:filter
        text: qsTr("滤镜")
    }

    //改变速度
    Action {
        id:speed
        text:qsTr("速度")
    }

    //旋转
    Action{
        id:rotate
        icon.name:"object-rotate-right"
    }

    //删除
    Action {
        id:deleteAction
        icon.name: "edit-delete"
    }

    //完成视频
    Action {
        id:finish
        text: qsTr("完成视频")
    }

    /***********视频预览操作栏******/

    //后退
    Action {
        id:back
        icon.name:"media-skip-backward"
    }

    //快进
    Action{
        id:forward
        icon.name:"media-skip-forward"
    }

    //播放
    Action {
        id:play
        icon.name: "media-playback-pause"
    }

    //暂停
    Action{
        id:pause
        icon.name: "media-playback-start"
    }

    //全屏
    Action{
        id:fullScreen
        icon.name:"view-fullscreen"
    }


    /***********上下文菜单*********/
    //添加标题卡
    Action {
        id:insertFragment
        text: qsTr("添加标题卡")
    }

    //从资源文件中删除
    Action{
        id:deleteReource
        text: "从资源列表中删除"
    }

    //从视频编辑界面返回
    Action{
        id: returnAction;
        icon.name: "go-first"
    }
}
