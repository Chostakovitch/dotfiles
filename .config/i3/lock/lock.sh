#!/bin/sh

B='#00000000'  # blank
C='#50343444'  # clear ish
D='#e6b790ff'  # default
T='#a55f41bb'  # text
W='#b7a56cff '  # wrong
V='#bb00bbbb'  # verifying
I='#fceac655'  # inside circle

i3lock \
--insidevercolor=$I   \
--ringvercolor=$D     \
\
--insidewrongcolor=$I \
--ringwrongcolor=$D   \
\
--insidecolor=$I      \
--ringcolor=$D        \
--linecolor=$B        \
--separatorcolor=$D   \
\
--verifcolor=$T        \
--wrongcolor=$T        \
--timecolor=$T        \
--datecolor=$T \
--layoutcolor=$T      \
--keyhlcolor=$C       \
--bshlcolor=$C        \
\
--screen 1            \
--blur 10              \
--clock               \
--indicator           \
--timestr="%H:%M:%S"  \
\
--veriftext="Chosto ?" \
--wrongtext="LEURRE" \
--modsize=10 \
--radius=110 \
--noinputtext="OH DIS DONC" \