###############################################################################
# Project file for CS106B/X Library 
#
# @author Julie Zelenski
# @version 2019/11/05
# This version still in development
###############################################################################

# Versioning
# ----------
QUARTER_ID = 19-1
REQUIRES_QT_VERSION = 5.11
VERSION = 19.1
# JDZ: above version gives auto access to qmake major/minor/patch and requires()
#CONFIG += develop_mode

# Top-level configuration
# -----------------------
# CS106B/X library project
# Builds static library libcs106.a to be installed in fixed location
# along with library headers and shared resources (icons, binaries, etc.)
# Student client program accesses library+resources from fixed location

TARGET = cs106
TEMPLATE = lib
CONFIG += staticlib
CONFIG += c++11
CONFIG -= depend_includepath

# Gather project inputs
# ----------------------
# Glob source and header files from known set of subdirs
# Configure include path for headers + Qt

MY_SUBDIRS = autograder collections console graphics io system util

for(dir, MY_SUBDIRS): PUBLIC_HEADERS *= $$files($${dir}/*.h)
PRIVATE_HEADERS *= $$files(private/*.h)
HEADERS *= $$PUBLIC_HEADERS $$PRIVATE_HEADERS

for(dir, MY_SUBDIRS): SOURCES *= $$files($${dir}/*.cpp)
SOURCES *= $$files(private/*.cpp)

RESOURCES = images.qrc

INCLUDEPATH *= $$MY_SUBDIRS
QT += core gui widgets network multimedia

# Build settings
# --------------
# When in develop_mode, enable warnings, deprecated, nit-picks, all of it.
# Pay attention and fix! Published version should trigger no warnings.
# Future update may foil our best-laid plans, so suppress
# warnings when !develop_mode to shield students from these surprises

develop_mode {
    CONFIG += warn_on
    QMAKE_CXXFLAGS_WARN_ON += -Wall -Wextra
    DEFINES += QT_DEPRECATED_WARNINGS
} else {
    CONFIG += warn_off
    CONFIG += sdk_no_version_check
    CONFIG += silent
} 

DEFINES += SPL_INSTALL_DIR=\\\"$${INSTALL_PATH}\\\" QUARTER_ID=\\\"$${QUARTER_ID}\\\"

# JDZ: below are previous defines, not yet sorted out what to do with

# allow clients to access the internal data inside the heap of PriorityQueue?
# (used for some practice exam exercises/demos)
DEFINES += SPL_PQUEUE_ALLOW_HEAP_ACCESS

# should toString / << of a PriorityQueue display the elements in sorted order,
# or in heap internal order? the former is more expected by client; the latter
# is faster and avoids a deep-copy
DEFINES += SPL_PQUEUE_PRINT_IN_HEAP_ORDER

# flag to throw exceptions when a collection iterator is used after it has
# been invalidated (e.g. if you remove from a Map while iterating over it)
DEFINES += SPL_THROW_ON_INVALID_ITERATOR

# should we attempt to precompile the Qt moc_*.cpp files for speed?
DEFINES += SPL_PRECOMPILE_QT_MOC_FILES

# Installation
# ------------
# make install is kind of what is wanted here (copy headers+lib
# to install location). However make install always copies (no skip if up-to-date
# and nothing was built), install target also requires add make step in Qt Creator,
# both ugh.
# Below are manual steps to copy lib+headers to install dir after each re-compile
#
# Install location is in user's home directory (near location required
# for wizard). This should be writable even on cluster computer.
# Note strategy is to specify all paths using forward-slash separator
# which requires goopy rework of APPDATA environment variable

win32|win64 {
    USER_STORAGE = $$(APPDATA)
    USER_STORAGE = $$replace(USER_STORAGE, \\\\, /)
} else {
    USER_STORAGE = $$(HOME)/.config
}
INSTALL_PATH = $${USER_STORAGE}/QtProject/qtcreator/cs106

for(h, PUBLIC_HEADERS): TO_COPY *= $$relative_path($$PWD, $$OUT_PWD)/$$h
QMAKE_POST_LINK = @echo "Installing into "$${INSTALL_PATH} && $(COPY_FILE) $$TO_COPY $${INSTALL_PATH}/include

# JDZ: kind of cheezy, why is output path different on windows?
win32|win64: PREFIX = debug/
QMAKE_POST_LINK += && $$QMAKE_QMAKE -install qinstall $${PREFIX}$(TARGET) $${INSTALL_PATH}/lib/$(TARGET)

# Requirements
# ------------
# Error if installed version of QT is insufficient

!versionAtLeast(QT_VERSION, $$REQUIRES_QT_VERSION) {
    error(The CS106 library for quarter $$QUARTER_ID requires Qt $$REQUIRES_QT_VERSION or newer; Qt $$[QT_VERSION] was detected. Please upgrade/re-install.)
}
