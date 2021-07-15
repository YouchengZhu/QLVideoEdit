#ifndef VIDEOITEM_H
#define VIDEOITEM_H

//视频编辑类
//负责视频的合并、剪辑、拆分、添加logo等操作
//date:2021-06-25
//作者:冉杨 朱有成 张新蕾


#include <QQuickPaintedItem>
#include <QObject>
#include <QColor>
#include <videoffmpeg.h>
#include <QImage>
#include <QList>
class VideoItem : public QQuickPaintedItem
{
    Q_OBJECT
    //属性1:视频文件列表
    Q_PROPERTY(QList<QString> fileSources READ fileSources WRITE setFileSources NOTIFY fileSourcesChanged)
    //属性2:当前视频文件列表中活动的视频文件
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
    //属性3:改组件每行容纳的视频第一帧图片个数
    Q_PROPERTY(int column READ column WRITE setColumn NOTIFY columnChanged)
    //属性4:控制选择状态，0表示选择多个文件改变路径（默认为0），1表示添加到情景板
    Q_PROPERTY(int selectStatus READ selectStatus WRITE setSelectStatus NOTIFY selectStatusChanged)

    QML_ELEMENT
private slots:
    //作用:将视频文件列表的第一帧图片绘制到组件所在区域
    void paint(QPainter* painter);
    //作用:将经过ffmpeg解码转换的第一帧转化成的RGB32图片设置到image成员
    void SetImage(QImage& image);

public:
    VideoItem();

    QList<QString> fileSources() const
    {
        return m_fileSources;
    }

    int currentIndex() const
    {
        return m_currentIndex;
    }

    int column() const
    {
        return m_column;
    }

    int selectStatus() const
    {
        return m_selectStatus;
    }

public slots:
    void setFileSources(QList<QString> &fileSources)
    {
        m_fileSources.clear();
        for(int i = 0; i < fileSources.length(); i++)
        {
            m_fileSources.push_back(fileSources[i]);
        }
        emit fileSourcesChanged(m_fileSources);
    }

    void setCurrentIndex(int currentIndex)
    {
        if (m_currentIndex == currentIndex)
            return;

        m_currentIndex = currentIndex;
        emit currentIndexChanged(m_currentIndex);
    }

    void setColumn(int column)
    {
        if (m_column == column)
            return;

        m_column = column;
        emit columnChanged(m_column);
    }
    //作用:解码
    void startDecode();

    void setSelectStatus(int selectStatus)
    {
        if (m_selectStatus == selectStatus)
            return;

        m_selectStatus = selectStatus;
        emit selectStatusChanged(m_selectStatus);
    }

signals:

    void fileSourcesChanged(QList<QString> fileSources);

    void currentIndexChanged(int currentIndex);

    void columnChanged(int column);

    void selectStatusChanged(int selectStatus);
private:
    VideoFFmpeg *videoFFmpeg;
    QImage m_image;
    QList<QImage> m_images;//保存每一个视频的图片
    QList<QString> m_fileSources;
    int m_currentIndex = -1;
    int m_column = 7;
    int m_selectStatus = 0;
};

#endif // VIDEOITEM_H

