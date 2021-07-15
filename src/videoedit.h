//视频编辑类
//负责视频的合并、剪辑、拆分、添加logo等操作
//date:2021-06-25
//作者:冉杨 朱有成 张新蕾

#ifndef PLAYER_H
#define PLAYER_H

#include <QObject>
#include <QProcess>
#include <QList>
class VideoEdit: public QObject
{
    Q_OBJECT
//    QML_ELEMENT
public slots:
    //剪辑函数:将输入文件in_filename从start_time到end_time裁剪,并保存到out_filename文件里面
    //参数1:输入文件名
    //参数2:剪辑后的文件名
    //参数3:视频裁剪的起始时间
    //参数4:视频剪辑的末尾时间
    int videoIntercept(QString in_filename, QString out_filename, const double start_time, const double end_time);
    //拆分函数:将输入视频文件从end_time这个时刻一分为二,0到end_time保存到out_filename文件1,end_time到视频末尾导入到文件out_filename2
    //参数1:in_filename输入文件名
    //参数2:out_filename输出文件1
    //参数3:out_filename2输出文件2
    //参数3:分割时间
    int videoSplit(QString in_filename, QString out_filename, QString out_filename2, const double end_time);
    //添加文本函数:将视频文件in_filename添加名字为textContent,颜色为textColor,字体大小为textFont,位置为position的文本,并保存为out_filename文件
    //参数1:输入文件名
    //参数2:导出文件名
    //参数3:文本内容
    //参数4:文本颜色
    //参数5:文本大小
    //参数6:文本位置
    int addText(QString in_filename, QString out_filename, QString textContent, QString textColor, QString textFont,  int position);
    //视频合并函数:将输入链表中的视频文件合并
    //参数1:输入文件链表
    int videoMerge(QList<QString> filelist);
    //删除函数
    //参数1:路径列表长度
    //参数2:剪辑过渡文件
    void delFinal(int length,QString fileName);
    //完成视频函数
    //参数1:目的地址
    //参数2:源地址
    void finishFile(QString dstPath,QString orgPath);
};

#endif // PLAYER_H

