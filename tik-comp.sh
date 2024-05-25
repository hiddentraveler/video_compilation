#!/bin/bash
echo "Downloading reddit Videos"
yt-dlp --restrict-filenames $(curl -s -H "User-agent: 'You bot 3000'" https://www.reddit.com/r/TikTokCringe/hot.json?limit=3 | jq '.' | grep url_overridden_by_dest | grep -Eoh "https:\/\/v\.redd\.it\/\w{13}")
echo "Download complete"
mkdir blur
for f in *.mp4;
do
  echo "Bluring sides of video $f"
  ffmpeg -i $f -lavfi '[0:v]scale=ih*16/9:-1,boxblur=luma_radius=min(h\,w)/20:luma_power=1:chroma_radius=min(cw\,ch)/20:chroma_power=1[bg];[bg][0:v]overlay=(W-w)/2:(H-h)/2,crop=h=iw*9/16' -vb 800K blur/$f;
done
echo "removing original videos"
rm *.mp4

for f in blur/*.mp4; do echo "file '$f'" >> file_list.txt ; done
echo "Compiling videos into one"
ffmpeg -f concat -safe 0 -i file_list.txt final.mp4
echo "Removing Blur folder"
rm -rf blur
rm file_list.txt
