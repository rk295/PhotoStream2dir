# osX LaunchAgents

This dir holds the master plist files for various tasks I run on my macs from [launchd](http://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man8/launchd.8.html).

Typically these files are copied into ~/Library/LaunchAgents/ and then loaded with the following command:

	% launchctl load -w ~/Library/LaunchAgents/<filename>
	
Files:

* uk.org.riviera.PicturesBackup.plist - Used to rsync my pictures from the external USB drive to the internal drive of Marvin and off to Trin.


r - 23/08/2011

