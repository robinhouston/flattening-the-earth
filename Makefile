POVRAY_FLAGS =

all: output/cea-composite.mp4

output/cea-final.freeze-1s.mp4: rendered/cea-morph/cea-morph48.png
	ffmpeg -y -f image2 -r 1/1 -i rendered/cea-open/cea-open48.png -vcodec libx264 -pix_fmt yuv420p $@

output/%.freeze-1s.mp4:
	ffmpeg -y -f image2 -r 1/1 -i rendered/$*/$*01.png -vcodec libx264 -pix_fmt yuv420p $@

output/%.mp4: %.ini %.pov
	mkdir -p rendered/$*
	povray $(POVRAY_FLAGS) $< && \
	ffmpeg -y -i rendered/$*/$*%02d.png -vcodec libx264 -pix_fmt yuv420p $@

output/bounce.mp4: bounce.ini bounce.pov
	povray $(POVRAY_FLAGS) $< && \
	ffmpeg -y -itsoffset 0.9 -i sfx/spring-sound.mp3 -i rendered/bounce/bounce%02d.png $@

output/cea-composite.mp4: cea-composite.txt \
							output/spin.freeze-1s.mp4 \
							output/spin.mp4 \
							output/cylindrical-equal-area.mp4 \
							output/cea-spin.mp4 \
							output/cea-spin.freeze-1s.mp4 \
							output/cea-open.mp4 \
							output/cea-final.freeze-1s.mp4
	ffmpeg -y -f concat -i $< -c copy $@
