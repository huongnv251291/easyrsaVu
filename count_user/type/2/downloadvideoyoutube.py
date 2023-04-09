#!/usr/bin/env python3
import os
from pathlib import Path

from pytube import YouTube, Playlist
import youtube_dl
from youtube_transcript_api import YouTubeTranscriptApi


def main():
    p = Playlist('https://www.youtube.com/watch?v=tVjHCYdUH28&list=PLjTDbsarUVZ0MzrJKrZTeogzn1_bG82w9')
    print(p.length)
    i = 0
    root = "C:/demodownload/"
    for url in p.video_urls[:p.length]:
        i = i + 1
        print(str(i) + "-" + url)
        yt = YouTube(url)
        print(yt.video_id)
        srt = YouTubeTranscriptApi.get_transcript(yt.video_id, ["vi"])
        print(srt)
        video = yt.streams.filter(abr='128kbps', only_audio=True).last()
        out_file = video.download(output_path=root)
        base, ext = os.path.splitext(out_file)
        new_file = Path(f'{base}.mp3')
        os.rename(out_file, new_file)
        break


def run(path):
    print("\nget video infor")
    video_url = input(path)
    video_info = youtube_dl.YoutubeDL().extract_info(
        url=video_url, download=False
    )
    print("\nvideo infor :")
    print(video_info)
    # filename = f"{video_info['title']}.mp3"
    # options = {
    #     'format': 'bestaudio/best',
    #     'keepvideo': False,
    #     'outtmpl': filename,
    # }
    #
    # with youtube_dl.YoutubeDL(options) as ydl:
    #     ydl.download([video_info['webpage_url']])
    #
    # print("Download complete... {}".format(filename))


if __name__ == "__main__":
    main()
