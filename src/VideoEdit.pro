QT += quick
QT += quickcontrols2
QT += widgets
CONFIG += c++11

CONFIG += qmltypes
QML_IMPORT_NAME = com.mycomponent.myGLWidget
QML_IMPORT_MAJOR_VERSION = 1

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
        videoedit.cpp \
        videoffmpeg.cpp \
        videoitem.cpp

RESOURCES += qml.qrc
INCLUDEPATH += /usr/include
LIBS += -L/usr/lib -lavcodec \
        -lavdevice \
        -lavfilter \
        -lavformat \
        -lavutil \
        -lpostproc \
        -lswresample \
        -lswscale \
        -lSDL2 \
        -lSDL2main \
# Additional import path used to resolve QML modules in Qt Creator's code model
#QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    videoedit.h \
    videoffmpeg.h \
    videoitem.h
