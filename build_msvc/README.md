Building bitphantom Core with Visual Studio
========================================

Introduction
---------------------
Solution and project files to build the bitphantom Core applications `msbuild` or Visual Studio can be found in the build_msvc directory. The build has been tested with Visual Studio 2017 and 2019.

Building with Visual Studio is an alternative to the Linux based [cross-compiler build](https://github.com/bitphantom/bitphantom/blob/master/doc/build-windows.md).

Quick Start
---------------------
The minimal steps required to build bitphantom Core with the msbuild toolchain are below. More detailed instructions are contained in the following sections.

```
vcpkg install --triplet x64-windows-static boost-filesystem boost-signals2 boost-test libevent openssl zeromq berkeleydb rapidcheck double-conversion
py -3 build_msvc\msvc-autogen.py
msbuild /m build_msvc\bitphantom.sln /p:Platform=x64 /p:Configuration=Release /t:build
```

Dependencies
---------------------
A number of [open source libraries](https://github.com/bitphantom/bitphantom/blob/master/doc/dependencies.md) are required in order to be able to build bitphantom Core.

Options for installing the dependencies in a Visual Studio compatible manner are:

- Use Microsoft's [vcpkg](https://docs.microsoft.com/en-us/cpp/vcpkg) to download the source packages and build locally. This is the recommended approach.
- Download the source code, build each dependency, add the required include paths, link libraries and binary tools to the Visual Studio project files.
- Use [nuget](https://www.nuget.org/) packages with the understanding that any binary files have been compiled by an untrusted third party.

The [external dependencies](https://github.com/bitphantom/bitphantom/blob/master/doc/dependencies.md) required for building are:

- Berkeley DB
- Boost
- DoubleConversion
- libevent
- OpenSSL
- Qt5
- RapidCheck
- ZeroMQ

Qt
---------------------
All the bitphantom Core applications are configured to build with static linking. In order to build the bitphantom Core Qt applications a static build of Qt is required.

The runtime library version (e.g. v141, v142) and platform type (x86 or x64) must also match. OpenSSL must also be linked into the Qt binaries in order to provide full functionality of the bitphantom Core Qt programs. An example of the configure command to build Qtv5.9.7 locally to link with bitphantom Core is shown below (adjust paths accordingly), note it can be expected that the configure and subsequent build will fail numerous times until dependency issues are resolved.

````
..\Qtv5.9.7_src\configure -developer-build -confirm-license -debug-and-release -opensource -platform win32-msvc -opengl desktop -no-shared -static -no-static-runtime -mp -qt-zlib -qt-pcre -qt-libpng -ltcg -make libs -make tools -no-libjpeg -nomake examples -no-compile-examples -no-dbus -no-libudev -no-qml-debug -no-icu -no-gtk -no-opengles3 -no-angle -no-sql-sqlite -no-sql-odbc -no-sqlite -no-libudev -skip qt3d -skip qtactiveqt -skip qtandroidextras -skip qtcanvas3d -skip qtcharts -skip qtconnectivity -skip qtdatavis3d -skip qtdeclarative -skip qtdoc -skip qtgamepad -skip qtgraphicaleffects -skip qtimageformats -skip qtlocation -skip qtmacextras -skip qtmultimedia -skip qtnetworkauth -skip qtpurchasing -skip qtquickcontrols -skip qtquickcontrols2 -skip qtscript -skip qtscxml -skip qtsensors -skip qtserialbus -skip qtserialport -skip qtspeech -skip qtvirtualkeyboard -skip qtwayland -skip qtwebchannel -skip qtwebengine -skip qtwebsockets -skip qtwebview -skip qtx11extras -skip qtxmlpatterns -nomake tests -openssl-linked -IC:\Dev\github\vcpkg\installed\x64-windows-static\include -LC:\Dev\github\vcpkg\installed\x64-windows-static\lib OPENSSL_LIBS="-llibeay32 -lssleay32 -lgdi32 -luser32 -lwsock32 -ladvapi32" -prefix C:\Qt5.9.7_ssl_x64_static_vs2017
````

A prebuilt version for x64 and Visual C++ runtime v141 (Visual Studio 2017) can be downloaded from [here](https://github.com/sipsorcery/qt_win_binary/releases). Please be aware this download is NOT an officially sanctioned bitphantom Core distribution and is provided for developer convenience. It should NOT be used for builds that will be used in a production environment or with real funds.

To build bitphantom Core without Qt unload or disable the bitphantom-qt, libbitphantom_qt and test_bitphantom-qt projects.

Building
---------------------
The instructions below use `vcpkg` to install the dependencies.

- Clone `vcpkg` from the [github repository](https://github.com/Microsoft/vcpkg) and install as per the instructions in the main README.md.
- Install the required packages (replace x64 with x86 as required):

```
    PS >.\vcpkg install --triplet x64-windows-static boost-filesystem boost-signals2 boost-test libevent openssl zeromq berkeleydb rapidcheck double-conversion
```

- Use Python to generate *.vcxproj from Makefile

```
    PS >py -3 msvc-autogen.py
```

- An optional step is to adjust the settings in the build_msvc directory and the common.init.vcxproj file. This project file contains settings that are common to all projects such as the runtime library version and target Windows SDK version. The Qt directories can also be set.

- Build with Visual Studio 2017 or msbuild.

```
msbuild /m bitphantom.sln /p:Platform=x64 /p:Configuration=Release /t:build
```

- Build with Visual Studio 2019 or msbuild.

```
msbuild /m bitphantom.sln /p:Platform=x64 /p:Configuration=Release /p:PlatformToolset=v142 /t:build
```

AppVeyor
---------------------
The .appveyor.yml in the root directory is suitable to perform builds on [AppVeyor](https://www.appveyor.com/) Continuous Integration servers. The simplest way to perform an AppVeyor build is to fork bitphantom Core and then configure a new AppVeyor Project pointing to the forked repository.

For safety reasons the bitphantom Core .appveyor.yml file has the artifact options disabled. The build will be performed but no executable files will be available. To enable artifacts on a forked repository uncomment the lines shown below:

```
    #- 7z a bitphantom-%APPVEYOR_BUILD_VERSION%.zip %APPVEYOR_BUILD_FOLDER%\build_msvc\%platform%\%configuration%\*.exe
    #- path: bitphantom-%APPVEYOR_BUILD_VERSION%.zip
```
