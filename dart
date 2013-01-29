#!/usr/bin/env python
# encoding: utf-8

# Name: iStore Artwork Downloader - dArt - download Art
# Version: 1b1
# Purpose: This application will search Apple's online stores (iTunes Store, iBookstore, Mac App Store and iOS App Store) for a user-input term and retrieve the full resolution cover art images from Apple's servers. It MAY support other sources in the future, but for now, it's limited to Apple's online media stores.
# Author: Habib alAmin

from sys import argv, exit
from os.path import basename, join, expanduser, expandvars, splitext, isdir, exists
from os import access, makedirs, W_OK
from urllib import urlopen, urlretrieve
from string import replace

try:
    import simplejson as json
except ImportError:
    import json

shortUsageMessage = """-id LOOKUPID [-c ISOCODE] [-dl DOWNLOADLOCATION]
             -s SEARCHTERM [-c ISOCODE] [-m MEDIATYPE] [-dl DOWNLOADLOCATION] [-fe]"""
usageMessage = """
""" + "Usage: " + basename(argv[0]) + " " + shortUsageMessage + """

    Spaces in search term should be separated by +
    
    Default download location: ~/Downloads/Artwork/
    
    Media types:
        All [default]: all
        Song: music
        Music Video: musicVideo
        Movie: movie
        Short Film: shortFilm
        TV Show: tvShow
        iBook: ebook
        Audiobook: audiobook
        OS X/iOS App: software
        Podcast: podcast
    
    'Common' ISO codes:
        United States [default]: us
        United Kingdom: gb
"""


def humanReadableMediaType(shortType):
    if shortType == "music":
        return "songs"
    elif shortType == "musicVideo":
        return "music vdeos"
    elif shortType == "movie":
        return "movies"
    elif shortType == "shortFilm":
        return "short films"
    elif shortType == "tvShow":
        return "TV shows"
    elif shortType == "ebook":
        return "iBooks"
    elif shortType == "audiobook":
        return "audiobooks"
    elif shortType == "software":
        return "apps"
    elif shortType == "podcast":
        return "podcasts"
    else:
        return "all types of media"

def humanReadableCountry(isocode):
    if isocode == "us":
        return "American"
    elif isocode == "gb":
        return "UK"
    else:
        return isocode

if len(argv) < 2:
    print "Usage: " + basename(argv[0]) + " " + shortUsageMessage
    exit(6)
elif argv[1] == "-h" or argv[1] == "--help":
    print usageMessage
    exit(6)
else:
    missingSearchOrLookup = 1
    for i in argv:
        if i == "-s" or "--search=" in i or i == "-id" or "--lookup-id=" in i:
            missingSearchOrLookup = 0
    if missingSearchOrLookup == 1:
        print
        print basename(argv[0]) + ": missing SEARCHTERM or LOOKUPID parameter!"
        print
        print "Usage:", basename(argv[0]), shortUsageMessage
        print
        exit(6)

filterExplicit = 0
mediaType = "all types of media"
storeCountry = "American"
downloadLocation = "~/Downloads/Artwork/"
search = "https://itunes.apple.com/"
searchTerm = ""
lookupID = ""
try:
    for i in range(1, len(argv)):
        if "--search=" in argv[i]:
            search = replace(search, "https://itunes.apple.com/", "https://itunes.apple.com/search")
            search += replace(argv[i], "--search=", "&term=")
            searchTerm = replace(argv[i], "--search=", "")
        elif argv[i] == "-s":
            search = replace(search, "https://itunes.apple.com/", "https://itunes.apple.com/search")
            search += "&term=" + argv[i+1]
            searchTerm = argv[i+1]
        elif argv[i] == "-id":
            search = replace(search, "https://itunes.apple.com/", "https://itunes.apple.com/lookup")
            search += "&id=" + argv[i+1]
            lookupID = argv[i+1]
        elif "--lookup-id=" in argv[i]:
            search = replace(search, "https://itunes.apple.com/", "https://itunes.apple.com/lookup")
            search += replace(argv[i], "--lookup-id=", "&id=")
            lookupID = replace(argv[i], "--lookup-id=", "")
        elif argv[i] == "-m":
            search += "&media=" + argv[i+1]
            mediaType = humanReadableMediaType(argv[i+1])
        elif argv[i] == "-c":
            search += "&country=" + argv[i+1]
            storeCountry = humanReadableCountry(argv[i+1])
        elif "--media=" in argv[i]:
            search += replace(argv[i], "--", "&")
            mediaType = humanReadableMediaType(replace(argv[i], "--media=", ""))
        elif "--country=" in argv[i]:
            search += replace(argv[i], "--", "&")
            storeCountry = humanReadableCountry(replace(argv[i], "--country=", ""))
        elif argv[i] == "--filter-explicit" or argv[i] == "-fe":
            search += "&explicit=no"
            filterExplicit = 1
        elif argv[i] == "-dl":
            downloadLocation = argv[i+1]
        elif argv[i] == "--download-location=":
            downloadLocation = replace(argv[i], "--download-location=", "")
        else:
            if argv[i-1] != "-s" and argv[i-1] != "-id" and argv[i-1] != "-m" and argv[i-1] != "-c" and argv[i] != "-fe" and argv[i-1] != "-dl":
                print
                print basename(argv[0]) + ": What is '" + argv[i] + "'?" + """
    Usage: """ + basename(argv[0]), shortUsageMessage
                print
                exit(1)
    search = replace(search, "/search&", "/search?")
    search = replace(search, "/lookup&", "/lookup?")
    search += "&limit=200"
    
    if "search" in search:
        print "Searching for", mediaType, "which contain", "\"" + replace(searchTerm, "+", " ") + "\"", "in the", storeCountry, "store.",
        if filterExplicit == 1:
            print "Explicit results are being filtered.",
        else:
            print "Explicit results are being shown.",
    else:
        print "Searching for", lookupID, "in the", storeCountry, "store.",
    print "If any artwork is found, it will be downloaded to \"" + expandvars(expanduser(join(downloadLocation, ""))) + "\"."
    
    if exists(expandvars(expanduser(join(downloadLocation, "")))) == 1:
        if isdir(expandvars(expanduser(join(downloadLocation, "")))) == 0:
            print basename(argv[0]) + ": the download directory… isn't a directory! Damn FOOL!"
            exit(4)
    else:
        try:
            makedirs(expandvars(expanduser(join(downloadLocation, ""))))
        except OSError, err:
            if err.errno == 13:
                print basename(argv[0]) + ": the download directory does not exist and you do not have permissions to create it!"
                exit(2)
    if access(expandvars(expanduser(join(downloadLocation, ""))), W_OK) == 0:
        print basename(argv[0]) + ": you don't have permission to write to the download directory!"
        exit(3)
    
    searchResults = json.load(urlopen(search))
    
    for i in range(len(searchResults[u'results'])):
        if urlopen(replace(searchResults[u'results'][i][u'artworkUrl100'], ".100x100-75", "")).getcode() == 200:
            try:
                urlretrieve(replace(searchResults[u'results'][i][u'artworkUrl100'], ".100x100-75", ""), expandvars(expanduser(join(downloadLocation, replace(searchResults[u'results'][i][u'trackName'], "/", "--")))) + splitext(searchResults[u'results'][i][u'artworkUrl100'])[1])
                print "The artwork for \"" + searchResults[u'results'][i][u'trackName'] + "\"", "has been retrieved!"
            except KeyError:
                urlretrieve(replace(searchResults[u'results'][i][u'artworkUrl100'], ".100x100-75", ""), expandvars(expanduser(join(downloadLocation, replace(searchResults[u'results'][i][u'collectionName'], "/", "--")))) + splitext(searchResults[u'results'][i][u'artworkUrl100'])[1])
                print "The artwork for \"" + searchResults[u'results'][i][u'collectionName'] + "\"", "has been retrieved!"
        elif urlopen(replace(searchResults[u'results'][i][u'artworkUrl100'], ".100x100-75", "")).getcode() == 403:
            try:
                urlretrieve(replace(searchResults[u'results'][i][u'artworkUrl100'], ".100x100", ".600x600"), expandvars(expanduser(join(downloadLocation, replace(searchResults[u'results'][i][u'trackName'], "/", "--")))) + splitext(searchResults[u'results'][i][u'artworkUrl100'])[1])
                print "The artwork for \"" + searchResults[u'results'][i][u'trackName'] + "\"", "has been retrieved!"
            except KeyError:
                urlretrieve(replace(searchResults[u'results'][i][u'artworkUrl100'], ".100x100", ".600x600"), expandvars(expanduser(join(downloadLocation, replace(searchResults[u'results'][i][u'collectionName'], "/", "--")))) + splitext(searchResults[u'results'][i][u'artworkUrl100'])[1])
                print "The artwork for \"" + searchResults[u'results'][i][u'collectionName'] + "\"", "has been retrieved!"
        else:
            try:
                print "\033[91mThe artwork for \"" + searchResults[u'results'][i][u'trackName'] + "\"", "could not be retrieved!" + "\033[1m", urlopen(replace(searchResults[u'results'][i][u'artworkUrl100'], ".100x100-75", "")).getcode(), "error!\033[0m"
            except KeyError:
                print "\033[91mThe artwork for \"" + searchResults[u'results'][i][u'collectionName'] + "\"", "could not be retrieved!" + "\033[1m", urlopen(replace(searchResults[u'results'][i][u'artworkUrl100'], ".100x100-75", "")).getcode(), "error!\033[0m"
except KeyboardInterrupt:
    print "\n\033[93m" + basename(argv[0]) + ": user aborted operation! Some artwork may not be fully downloaded!\033[0m"
    exit(5)