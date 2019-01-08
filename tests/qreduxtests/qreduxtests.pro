#-------------------------------------------------
#
# Project created by QtCreator 2016-02-25T18:56:34
#
#-------------------------------------------------

QT       += testlib qml

TARGET = qreduxtests
CONFIG   += console
CONFIG   -= app_bundle

TEMPLATE = app

SOURCES +=     main.cpp    

DEFINES += SRCDIR=\\\"$$PWD/\\\"
DEFINES += QUICK_TEST_SOURCE_DIR=\\\"$$PWD/qmltests\\\"

include(vendor/vendor.pri)
include(../../qredux.pri)

DISTFILES +=     qpm.json \    
    qmltests/tst_Redux.qml \
    qmltests/tst_patch_JavaScriptObject.qml

HEADERS +=    

