#include "videoedit.h"
#include <iostream>
#include <QFile>
#include <QDebug>
#include <stdlib.h>

extern "C" {
#include <libavutil/timestamp.h>
#include <libavformat/avformat.h>
}

int VideoEdit::videoIntercept(QString in_file, QString out_file, const double start_time, const double end_time)
{
    AVFormatContext *ifmt_ctx = NULL, *ofmt_ctx = NULL;
    AVPacket pkt;
    int ret, i;

    std::string tr;
    tr= in_file.toStdString();
    const char *in_filename = tr.data();

    std::string tr2;
    tr2 = out_file.toStdString();
    const char *out_filename = tr2.data();

    if ((ret = avformat_open_input(&ifmt_ctx, in_filename, 0, 0)) < 0) {
        fprintf(stderr, "Could not open input file '%s'", in_filename);
        return -1;;
    }

    if ((ret = avformat_find_stream_info(ifmt_ctx, 0)) < 0) {
        fprintf(stderr, "Failed to retrieve input stream information");
        return -1;
    }

//    av_dump_format(ifmt_ctx, 0, in_filename, 0);

    avformat_alloc_output_context2(&ofmt_ctx, NULL, NULL, out_filename);
    if (!ofmt_ctx) {
        fprintf(stderr, "Could not create output context\n");
        return -1;;
    }


    for (i = 0; i < ifmt_ctx->nb_streams; i++) {
        AVStream *out_stream;
        AVStream *in_stream = ifmt_ctx->streams[i];
        AVCodecParameters *in_codecpar = in_stream->codecpar;


        out_stream = avformat_new_stream(ofmt_ctx, NULL);
        if (!out_stream) {
            fprintf(stderr, "Failed allocating output stream\n");
            return -1;
        }

        ret = avcodec_parameters_copy(out_stream->codecpar, in_codecpar);
        if (ret < 0) {
            fprintf(stderr, "Failed to copy codec parameters\n");
            return -1;
        }
        out_stream->codecpar->codec_tag = 0;
    }

    ret = avio_open(&ofmt_ctx->pb, out_filename, AVIO_FLAG_WRITE);
    if (ret < 0) {
           fprintf(stderr, "Could not open output file '%s'", out_filename);
            return -1;
    }

    ret = avformat_write_header(ofmt_ctx, NULL);
    if (ret < 0) {
        fprintf(stderr, "Error occurred when opening output file\n");
        return -1;
    }
    ret = av_seek_frame(ifmt_ctx, -1, start_time * AV_TIME_BASE, AVSEEK_FLAG_BACKWARD);
    if (ret < 0) {
            fprintf(stderr, "Error seek\n");
            return -1;
    }

    while(1) {
       AVStream *in_stream, *out_stream;
       ret = av_read_frame(ifmt_ctx, &pkt);
       if (ret < 0) break;
       in_stream  = ifmt_ctx->streams[pkt.stream_index];
       out_stream = ofmt_ctx->streams[pkt.stream_index];

       if(end_time != 0) {
           if (av_q2d(in_stream->time_base) * pkt.pts > end_time) {
                      av_packet_unref(&pkt);
                      break;
           }
       }
       pkt.pts = av_rescale_q_rnd(pkt.pts, in_stream->time_base, out_stream->time_base, AV_ROUND_NEAR_INF);
       pkt.dts = av_rescale_q_rnd(pkt.dts, in_stream->time_base, out_stream->time_base, AV_ROUND_NEAR_INF);
       pkt.duration = av_rescale_q(pkt.duration, in_stream->time_base, out_stream->time_base);
       pkt.pos = -1;
       if (pkt.pts < pkt.dts) {
                   continue;
       }
       ret = av_interleaved_write_frame(ofmt_ctx, &pkt);
       if (ret < 0) {
            fprintf(stderr, "Error muxing packet\n");
            break;
       }
       av_packet_unref(&pkt);
    }

    av_write_trailer(ofmt_ctx);

    avformat_close_input(&ifmt_ctx);
    /* close output */
    avio_closep(&ofmt_ctx->pb);
    avformat_free_context(ofmt_ctx);

    return 0;
}
int VideoEdit::videoSplit(QString in_file, QString out_file1, QString out_file2, const double end_time)
{
    qDebug()<<"in file: "<<in_file;
    qDebug()<<"out file1: "<<out_file1;
    qDebug()<<"out file2: "<<out_file2;
    std::string tr;
    tr= in_file.toStdString();
    const char *in_filename = tr.data();

    std::string tr2;
    tr2 = out_file1.toStdString();
    const char *out_filename1 = tr2.data();

    std::string tr3;
    tr3 = out_file2.toStdString();
    const char *out_filename2 = tr3.data();
    int ret1 = videoIntercept(in_filename, out_filename1, 0, end_time);
    int ret2 = videoIntercept(in_filename, out_filename2, end_time, 0);
    return (ret1==ret2) && ret1 == 0;
}

int VideoEdit::addText(QString in_filename, QString out_filename, QString textContent, QString textColor, QString textFont,  int position)
{
    if(position < 0 || position > 3) {
        return -1;
    }
    std::string str;
    str = in_filename.toStdString();
    std::string str2;
    str2 = textContent.toStdString();
    std::string str3 = out_filename.toStdString();
    std::string strColor = textColor.toStdString();
    std::string strFont = textFont.toStdString();


    std::string cmd;
    switch (position) {
    case 0:
        cmd = "ffmpeg -i " + str + " -vf " + "\"drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf: text='" + str2 + "':fontcolor=" + strColor + ":fontsize=" + strFont + ":x=0:y=0\" " + str3;
        break;
    case 1:
         cmd = "ffmpeg -i " + str + " -vf " + "\"drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf: text='" + str2 + "':fontcolor=" + strColor + ":fontsize=" + strFont + ":x=w-text_w:y=0\" " + str3;
        break;
    case 2:
         cmd = "ffmpeg -i " + str + " -vf " + "\"drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf: text='" + str2 + "':fontcolor=" + strColor + ":fontsize=" + strFont + "x=0:y=h-text_h\" " + str3;
        break;
    case 3:
          cmd = "ffmpeg -i " + str + " -vf " + "\"drawtext=fontfile=/usr/share/fonts/truetype/freefont/FreeSerif.ttf: text='" + str2 + "':fontcolor=" + strColor + ":fontsize=" + strFont + ":x=w-text_w:y=h-text_h\" "+ str3;
        break;
    }
    QString Qcmd = QString::fromStdString(cmd);
    QProcess *proc = new QProcess;
    if(proc->state() != proc->NotRunning) {
        proc->waitForFinished(20000);
    }


    proc->start(Qcmd);
//    qDebug()<<Qcmd;
    return 0;
}
int VideoEdit::videoMerge(QList<QString> fileList)
{
    QList<QString> filelist;
    for(int i = 0; i < fileList.length(); i++)
    {
        filelist.push_back(fileList[i].right(fileList[i].length()-7));
        qDebug()<<"filelist[i] = "<<filelist[i];
    }
    QString temp = filelist[0];
    AVFormatContext *fmtCtx = nullptr;

    QList<QString> outpathNames = {"out1.mp4", "out2.mp4", "out3.mp4"};
    QList<QString> outFinalPath = {"final1.mp4", "final2.mp4", "final3.mp4"};
    int width, height;
    std::string tr;
    QString fileFormat;
    tr= temp.toStdString();
    const char *in_filename = tr.data();
    int ret = avformat_open_input(&fmtCtx, in_filename, NULL, NULL);
    if(ret) {
        qDebug()<<"open input failed";
    }
    ret = avformat_find_stream_info(fmtCtx, NULL);
    int videoIndex = av_find_best_stream(fmtCtx,  AVMEDIA_TYPE_VIDEO, -1, -1, nullptr, 0);
    width = fmtCtx->streams[videoIndex]->codec->width;
    height = fmtCtx->streams[videoIndex]->codec->height;

    fileFormat = fmtCtx->streams[videoIndex]->codecpar->format;

    QList<QString> tempInputFiles;
    QString width1 = QString::number(width, 10);
    QString height1 = QString::number(height, 10);

    //在转换之前将之前out1,ou2,...文件给删掉 第一次执行不会删
        for(int del = 1; del < 8; del++)
        {
            QString file = "rm ./out" + QString::number(del, 10) + ".mp4";
            qDebug()<<file;
            const char *rmFile = file.toStdString().c_str();
            system(rmFile);
        }
    for(int i =0; i < filelist.length();i++)
    {
        std::string cmd = "ffmpeg -i " + (filelist[i]).toStdString() + "  -vf scale="+ (width1).toStdString()+ ":" + (height1).toStdString() + " ./" + (outpathNames[i]).toStdString();
        const char* cmd1 = cmd.c_str();
        system(cmd1);
        tempInputFiles.push_back(outpathNames[i]);
    }

    QList<QString> finalfileList = tempInputFiles;
    QFile file("in.txt");

    if(!file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        qDebug() << "Open file failed!";
        return -1;
    }
    QTextStream stream(&file);

    QProcess *process =  new QProcess{};
    for(int i = 0; i < finalfileList.length(); i++)
    {
        stream << "file \'" <<"./"<< finalfileList[i] << "\'"<< "\n";
    }

    QString cmd = "ffmpeg -f concat -safe 0 -i ./in.txt -c copy  ./" +
            outFinalPath[fileList.length()-1];

    qDebug() << "fileName " << file.fileName();
    qDebug() << cmd;

    process->start(cmd);
    return 0;
}

void VideoEdit::delFinal(int length, QString fileName)
{
    for(int del = 1; del < length+1; del++)
    {
        QString file = "rm ./final" + QString::number(del, 10) + ".mp4";
        qDebug()<<file;
        const char *rmFile = file.toStdString().c_str();
        system(rmFile);
    }

    QString file ="rm ./afterIntercept.mp4";

    QProcess *proc = new QProcess;
    proc->start(file);
}

void VideoEdit::finishFile(QString dstPath, QString orgPath)
{
    QString org = orgPath.right(orgPath.length()-7);
    QString dst = dstPath.right(dstPath.length()-7);

    QString cmd = "cp " + org + " " + dst;

    system(cmd.toStdString().c_str());
}





