#include "videoffmpeg.h"
#include <QDebug>
#include <QImage>
#include <iostream>

using namespace std;

VideoFFmpeg::VideoFFmpeg(QObject *parent) : QObject(parent)
{

}

void VideoFFmpeg::setFileSources(QList<QString> sources)
{
    m_sources.clear();//清空之前数据
    for(int i = 0; i < sources.length(); i++)
    {
        m_sources.append(sources[i]);
    }
//    qDebug() << "m_sources's length is " << m_sources.length();
}

bool VideoFFmpeg::decode(int index)
{
    int frame_cnt;
    std::string str = m_sources[index].toStdString();
    const char* filePath = str.data();

    av_register_all();
    avformat_network_init();
    pFormatCtx = avformat_alloc_context();

    if(avformat_open_input(&pFormatCtx,filePath,NULL,NULL)!=0){
        printf("Couldn't open input stream.\n");
        return -1;
    }
    if(avformat_find_stream_info(pFormatCtx,NULL)<0){
        printf("Couldn't find stream information.\n");
        return -1;
    }
    videoindex=-1;
    for(i=0; i<pFormatCtx->nb_streams; i++)
        if(pFormatCtx->streams[i]->codec->codec_type==AVMEDIA_TYPE_VIDEO){
            videoindex=i;
            break;
        }
    if(videoindex==-1){
        printf("Didn't find a video stream.\n");
        return -1;
    }

    pCodecCtx=pFormatCtx->streams[videoindex]->codec;
    pCodec=avcodec_find_decoder(pCodecCtx->codec_id);
    if(pCodec==NULL){
        printf("Codec not found.\n");
        return -1;
    }
    if(avcodec_open2(pCodecCtx, pCodec,NULL)<0){
        printf("Could not open codec.\n");
        return -1;
    }
    pFrame=av_frame_alloc();
    pFrameRGB=av_frame_alloc();

    out_buffer=(uint8_t *)av_malloc(avpicture_get_size(AV_PIX_FMT_RGB32, pCodecCtx->width, pCodecCtx->height));
    avpicture_fill((AVPicture *)pFrameRGB, out_buffer, AV_PIX_FMT_RGB32, pCodecCtx->width, pCodecCtx->height);

    packet=(AVPacket *)av_malloc(sizeof(AVPacket));
    img_convert_ctx = sws_getContext(pCodecCtx->width, pCodecCtx->height, pCodecCtx->pix_fmt,
    pCodecCtx->width, pCodecCtx->height, AV_PIX_FMT_RGB32, SWS_BICUBIC, NULL, NULL, NULL);

    //av_read_frame(pFormatCtx,packet);
    while(av_read_frame(pFormatCtx, packet)>=0){
        if(packet->stream_index==videoindex){
            ret = avcodec_decode_video2(pCodecCtx, pFrame, &got_picture, packet);
            if(ret < 0){
                printf("Decode Error.\n");
                return -1;
            }
            if (got_picture){
            sws_scale(img_convert_ctx,
                        (uint8_t const * const *) pFrame->data,
                        pFrame->linesize, 0, pFrame->height, pFrameRGB->data,
                        pFrameRGB->linesize);
            QImage tmpImg((uchar *)out_buffer,pFrame->width,pFrame->height,QImage::Format_RGB32);
                QImage image = tmpImg.copy(); //把图像复制一份 传递给界面显示
                //cout<<image.width()<<"   "<<image.height()<<endl;
                emit sig_GetOneFrame(image);
                break;
            }
        }
        av_free_packet(packet);
    }

    sws_freeContext(img_convert_ctx);

    av_frame_free(&pFrameRGB);
    av_frame_free(&pFrame);
    avcodec_close(pCodecCtx);
    avformat_close_input(&pFormatCtx);
}
