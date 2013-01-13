POVRAY_FLAGS = +W1024 +H768 +ua
#POVRAY_FLAGS = +ua
#POVRAY_FLAGS = +W160 +H120 +ua

all: earth.png

open: earth.png
	open earth.png

clean:
	rm -f earth.png bounce*.png bounce.mp4

%.png: %.pov
	povray $(POVRAY_FLAGS) $<

%.mp4: %.ini %.pov
	povray $(POVRAY_FLAGS) $< && \
	ffmpeg -y -i $*%02d.png $@

bounce.mp4: bounce.ini bounce.pov
	povray $(POVRAY_FLAGS) $< && \
	ffmpeg -y -itsoffset 0.9 -i sfx/spring-sound.mp3 -i bounce%02d.png $@
