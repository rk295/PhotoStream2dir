# PhotoStream2Dir

Simple perl script to walk the directory where osX currently saves PhotoStream [1]
photos and copy them into a directory. Currently I have Lightroom configured to 
watch the target directory, which means I can have my PhotoStream photos automatically
imported into Lightroom.

*NOTE:* For this to work you have to enabled PhotoStream in the iCloud section of the 
system preferences, which requires with iPhoto or Aperture installed. Once it is enabled
however as far as I can tell you don't ever then need to run either app for the files
to pile up in the directory under ~/Library/.

Designed to be run from launchd or similar to copy any new files from $assetDir
into $targetDir, which you can then do with what you want. 

It saves state out to a file (as defined in the $stateFile variable), which is actually
a perl hash of the top level directory name and mtime thereof (incase it is useful in the future).

## The PhotoStream Asset Directory

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
 3. The path to lockrun, or if you dont use lockrun then simply delete the following three lines:

     <string>/usr/local/bin/lockrun</string>
     <string>--lockfile=/Users/robin/tmp/var/backup-pictures.lockrun</string>
     <string>--</string>

2. Copy the plist file into ~/Library/LaunchAgents/
3. Load the new job
    
    `% launchctl load -w ~/Library/LaunchAgents/uk.org.riviera.PhotoStream2Dir.plist`

### Lockrun

[Lockrun](http://www.unixwiz.net/tools/lockrun.html) is a lovely little tool which runs the command you give it and writes out a lockfile. This 
has the nice effect of preventing more than one copy of your program running at once. I installed 
my copy of lockrun via the excellent [Homebrew](http://brew.sh/) tool.
	
## TODO

1. Do something with PNG files, they tend to just be screen shots from iOS devices and as a result I currently skip over them.
2. Some sort of locking mechanism maybe. Although I currently run under [Lockrun](http://www.unixwiz.net/tools/lockrun.html) 
3. Some sort of logging to help debugging.

# Contact

If you want to contact me, ping me a mail at robin@kearney.co.uk or on twitter as [rk295](http://twitter.com/rk295/).


r - 09/09/2013

