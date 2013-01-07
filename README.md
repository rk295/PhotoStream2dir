# PhotoStream2Dir

Simple perl script to walk the directory where osX currently saves PhotoStream [1]
photos and copy them into a LightRoom auto import watch directory.

Designed to be run from launchd or similar to copy any new files from $assetDir
into $targetDir, which you can then do with what you want. For example you could
use LightRoom autoimport feature.

Saves state out to a file ($stateFile), which is a hash of the top level directory
name and mtime thereof (incase it is useful in the future).  

## The Asset Directory

The $assetDir has the following structure:

    ├── 01227cb0d039e4c9f466dfe2215506d7b831470cef
    │   └── IMG_7496.JPG
    ├── 012218e681f20fb9684d33e9780605132a71acdaed
        └── IMG_7396.JPG

With a single image in each folder. It is the unique folder names which are saved
into the hash.

## LaunchD

I currently run this out of [launchd](http://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man8/launchd.8.html), for which there is a plist file included.  To add this as a job do the following:

1. Edit the plist file to adjust the following: 

 1. *StartInterval* - in seconds, currently every 4 hours. 
 2. The path to the script. 
 3. The path to lockrun, or ff you dont use lockrun then simply delete the following three lines:

     <string>/usr/local/bin/lockrun</string>
     <string>--lockfile=/Users/robin/tmp/var/backup-pictures.lockrun</string>
     <string>--</string>
2. Copy the plist file into ~/Library/LaunchAgents/
3. Load the new job

    
    `% launchctl load -w ~/Library/LaunchAgents/uk.org.riviera.PhotoStream2Dir.plist`
	
## Notes

1. I used to have Aperture enabled to auto-import PhotoStream pics. It has occurred to me that the only reason the files are piling up in the asset dir is because Aperture somehow made that happy. I need to do some more testing on a blank osX account.

## TODO

1. Do something with PNG files, they tend to just be screen shots from iOS devices and as a 
   result I currently skip over them.
2. Some sort of locking mechanism maybe. Although I currently run under [Lockrun](http://www.unixwiz.net/tools/lockrun.html) 



r - $Date$

