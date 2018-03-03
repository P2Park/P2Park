#!/bin/bash
# create multiresolution windows icon
ICON_DST=../../src/qt/res/icons/p2park.ico

convert ../../src/qt/res/icons/p2park-16.png ../../src/qt/res/icons/p2park-32.png ../../src/qt/res/icons/p2park-48.png ${ICON_DST}
