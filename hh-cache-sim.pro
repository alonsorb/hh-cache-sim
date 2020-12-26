QT += quick
TARGET = hh-cache-sim

CONFIG += c++14

# TODO switch to the new qml type registration system once it is stable enough

SOURCES += \
        src/cache.cpp \
        src/cacheset.cpp \
        src/main.cpp

HEADERS += \
    src/cache.h \
    src/cacheset.h

RESOURCES += qml/qml.qrc
