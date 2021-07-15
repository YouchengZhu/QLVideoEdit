#ifndef VIDEOFFMPEG_H
#define VIDEOFFMPEG_H

//视频解码类
//负责视频的解码,获取第一帧的图片
//date:2021-06-25
//作者:冉杨 朱有成 张新蕾


#include <QObject>
#include <stdio.h>
#include <QList>
#include <QImage>

#define __STDC_CONSTANT_MACROS
extern "C"
{
#include "libavcodec/avcodec.h"
#include "libavformat/avformat.h"
#include "libswscale/swscale.h"
};
class VideoFFmpeg : public QObject
{
    Q_OBJECT

public:
    explicit VideoFFmpeg(QObject *parent = nullptr);
public slots:
    void setFileSources(QList<QString> sources);//设置解码的文件路径（支持多选）
signals:
    void sig_GetOneFrame(QImage &image);
private:
    AVFormatContext	*pFormatCtx;
    int				i, videoindex;
    AVCodecContext	*pCodecCtx;
    AVCodec			*pCodec;
    AVFrame	*pFrame,*pFrameRGB;
    uint8_t *out_buffer;
    AVPacket *packet;
    int y_size;
    int ret, got_picture;
    struct SwsContext *img_convert_ctx;
    //输入文件路径
    QList<QString> m_sources;
    //视频帧队列
    std::vector<AVFrame *> videoVector;
    //音频帧队列
    std::vector<AVFrame *> audioVector;
public:
    bool decode(int index);
};

#endif // VIDEOFFMPEG_H

