ffmpeg -i $1.mp4 -r 10 -f image2pipe -vcodec ppm - | \
  convert -delay 5 -loop 0 - $1.gif
