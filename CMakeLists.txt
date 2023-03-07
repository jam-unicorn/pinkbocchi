cmake_minimum_required(VERSION 3.16)

project(mediaplayer LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)

set(INSTALL_EXAMPLEDIR "E:/c++ Project/mediaplayer")

find_package(Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 Svg)

qt_add_executable(mediaplayer
    main.cpp
)

set(resource_files
    "main.qml"
    "PlaybackControl.qml"
    "MetadataInfo.qml"
    "AudioControl.qml"
    "PlaybackSeekControl.qml"
    "PlayerMenuBar.qml"
    "PlayList.qml"
    "TracksInfo.qml"
    "Cover.jpg"
    "Mute_Icon.svg"
    "Speaker_Icon.svg"
)

qt_add_resources(mediaplayer "mediaplayer"
    PREFIX
        "/"
    FILES
        ${resource_files}
)

target_link_libraries(mediaplayer PRIVATE
    Qt6::Core
    Qt6::Svg
    Qt6::Quick
)

install(TARGETS mediaplayer
    RUNTIME DESTINATION "${INSTALL_EXAMPLEDIR}"
    BUNDLE DESTINATION "${INSTALL_EXAMPLEDIR}"
    LIBRARY DESTINATION "${INSTALL_EXAMPLEDIR}"
)
