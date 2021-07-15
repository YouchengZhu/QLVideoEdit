#include "videoitem.h"
#include <QPainter>
#include <videoffmpeg.h>

void VideoItem::paint(QPainter* painter)
{
    if(m_image.size().width() <= 0)
    {
        qDebug() << "m_image.size() <= 0";
        return;
    }

    //缩放图片大小
    for(int i = 0; i < m_images.length(); i++)
    {
        m_images[i] = m_images[i].scaled(160, 120,Qt::IgnoreAspectRatio);
    }

    //设置图片显示位置
        for(int index = 0; index < m_images.length(); index++){
            int i;//表示图片所在行数
            m_images[index] = m_images[index].scaled(90, 90,Qt::KeepAspectRatioByExpanding);
            //设置图片位置
            if(index < m_column) i = 0;
            else if(index >= m_column)
            {
                i = (index - index % m_column) / m_column;
            }
            for(int k = 0; k < m_column; k++) i = 0;
            int j = index % m_column;//表示图片所在列数
            //qDebug() << "j = " << j;
            painter->drawImage(j*127,i*100,m_images[index]);
    }
    //qDebug() << "m_images.length is" << m_images.length();
}

void VideoItem::SetImage(QImage& image)
{
    //每添加一个视频文件设置一次图片
        m_image = image;
        m_images.push_back(m_image);//放入显示图片列表
}

VideoItem::VideoItem()
{
    videoFFmpeg = new VideoFFmpeg();
    connect(this, &VideoItem::fileSourcesChanged, videoFFmpeg, &VideoFFmpeg::setFileSources);//设置路径信号与槽的连接
    connect(videoFFmpeg,&VideoFFmpeg::sig_GetOneFrame,this,&VideoItem::SetImage);//连接第一帧与显示帧的信号
    connect(this, &VideoItem::fileSourcesChanged, this, &VideoItem::startDecode);

}
void VideoItem::startDecode()
{
    if(m_selectStatus == 0)
    {
        for(int i = 0; i < m_fileSources.length(); i++)
        {
            videoFFmpeg->decode(i);
        }
    }
    if(m_selectStatus == 1)
    {
        videoFFmpeg->decode(m_fileSources.length() - 1);
    }
    update();
}
