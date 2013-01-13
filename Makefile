POVRAY_FLAGS =

all: output/bounce.mp4

clean:
	rm -f earth.png bounce*.png bounce.mp4

%.png: %.pov
	povray $(POVRAY_FLAGS) $<

output/%.mp4: %.ini %.pov
	povray $(POVRAY_FLAGS) $< && \
	ffmpeg -y -i rendered/$*/$*%02d.png $@

output/bounce.mp4: bounce.ini bounce.pov
	povray $(POVRAY_FLAGS) $< && \
	ffmpeg -y -itsoffset 0.9 -i sfx/spring-sound.mp3 -i rendered/bounce/bounce%02d.png $@

output/cylindrical-equal-area.mp4: cylindrical-equal-area.ini cylindrical-equal-area.pov
	povray $(POVRAY_FLAGS) $< && \
	ffmpeg -y -i rendered/cylindrical-equal-area/cylindrical-equal-area%02d.png $@
