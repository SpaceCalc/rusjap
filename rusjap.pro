QT += quick sql

CONFIG += c++17

CONFIG(debug, debug|release) {
    DESTDIR = debug
} else {
    DESTDIR = release
}

HEADERS += \
    Backend.h

SOURCES += \
        Backend.cpp \
        main.cpp

resources.files = \
    main.qml \
    MenuButton.qml \
    SText.qml \
    SRadioButton.qml \
    SButton.qml \
    STextField.qml \
    STextButton.qml \
    SVScrollBar.qml \

resources.prefix = /$${TARGET}
RESOURCES += resources

copydata.commands = $(COPY_FILE) $$shell_path($$PWD/data/lessons.xlsx) $$shell_path($$OUT_PWD/$${DESTDIR}/lessons.xlsx)
first.depends = $(first) copydata
export(first.depends)
export(copydata.commands)
QMAKE_EXTRA_TARGETS += first copydata

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
