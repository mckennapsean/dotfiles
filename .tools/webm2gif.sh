if [ "$#" -gt 1 ]; then
  echo "Please provide a file!"
  echo "Usage: webmgif [filename] [width]"
fi
if [ "$#" -eq 1 ]; then
  ffmpeg -i "$1" -r 15 -vf 'fps=15,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse' "${1%.*}.gif"
fi
if [ "$#" -ge 2 ]; then
  ffmpeg -i "$1" -r 15 -vf "scale=$2:-1,fps=15,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" "${1%.*}.gif"
fi

