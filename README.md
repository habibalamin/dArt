iStore Artwork Downloader!
========================

## Features ##
* Only uses standard libraries from Python 2.6 - tested on Python 2.7.2
* Download artwork at full resolution from Apple's servers!
* Supports songs, music videos, albums, movies, short films, TV shows, audiobooks, iBooks, iOS/OS X software and podcasts.
* Non-interactive - can be called from scripts
* Can look up track by iTunes ID for exact matches
* Can filter explicit media

## Usage ##
```
dart -id LOOKUPID [-c ISOCODE] [-dl DOWNLOADLOCATION]
	  -s SEARCHTERM [-c ISOCODE] [-m MEDIATYPE] [-dl DOWNLOADLOCATION] [-fe]
```
## Issues ##
* Can't search all metadata, only supports country, media type, search term, iTunes ID and explicit filter.
* A lot of items don't return their artwork, even though they do have them. This is an issue on Apple's part, there's nothing I can do about it. The user is warned about which images aren't downloaded. During testing, I noticed that one of the images that had worked a few times stopped working after repeated testing on that image, while all other working images were still working.
* Error messages go to stdout, instead of stderr.
* Can't narrow search for TV shows by episode, except with iTunes ID. Without the exact ID, it will show all episodes of TV show corresponding to search term.
* Doesn't use getopt - which I just found out about after implementing the options accepted and couldn't be bothered to change it after - and a lot of lazy patching together. This should change with the next version, when I have to add more options.