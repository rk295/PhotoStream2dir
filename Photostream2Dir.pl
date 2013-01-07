#!/usr/bin/perl -w
#
# $Id$
#
# Simple perl script to walk the directory where osX currently saves PhotoStream
# photos and copy them into a LightRoom auto import watch directory.
#
# Designed to be run from cron or similar to copy any new files from $assetDir
# into $targetDir, which Lightroom will then process next time it is opened. 
# Saves state out to a file ($stateFile), which is a hash of the top level directory
# name and mtime thereof (incase it is useful in the future).  The $assetDir 
# has the following structure:
#
# ├── 01227cb0d039e4c9f466dfe2215506d7b831470cef
# │   └── IMG_7496.JPG
# ├── 012218e681f20fb9684d33e9780605132a71acdaed
#     └── IMG_7396.JPG
# 
# With a single image in each folder. It is the unique folder names which are saved
# into the hash.
#
# TODO: Do something with PNG files, Lightroom currently doesnt support them, 
#       they tend to just be screen shots from iOS devices. But maybe out to
#       do something with them?
#


use strict;

use Data::Dumper;
use File::stat;
use Storable;
use File::Copy;

my $DEBUG = 1;

my $assetDir = "/Users/robin/Library/Application Support/iLifeAssetManagement/assets/sub/";
my $stateFile = "/Users/robin/.PhotostreamToDir/state";
my $targetDir = "/Users/robin/Pictures/LightroomWatchDir/";
my %fileList;
my @toProcess;

# Attempt to open the state file
if ( -e $stateFile) {
		$DEBUG && print STDERR "Found state file, attempting to load\n";
		%fileList = %{ retrieve($stateFile) };
}

# Open, and walk the dir looking for new files.
opendir(D, $assetDir) || die "Can't opedir: $!\n";

while (my $dir = readdir(D)) {
 	next if $dir =~ /^\.$/;
	next if $dir =~ /^\..$/;
	next if $dir =~ /^\.DS_Store$/;
	
	if ( exists $fileList{$dir} ) {
		$DEBUG && print STDERR "Seen this one before ($dir)\n";
		next;
	}

	# If we are here, it is a new dir, so add it and process it.
	$DEBUG && print STDERR "processing $dir\n";
	$fileList{$dir} = stat($assetDir . $dir)->mtime;
	
	# Open the subdir and walk that.
	opendir(S, $assetDir .$dir);
	
	while (my $file = readdir(S)) {
		next if $file =~ /^\.$/;
		next if $file =~ /^\..$/;
		next if $file =~ /^\.DS_Store$/;
		next if $file =~ /\.PNG$/;

		$DEBUG && print STDERR "Copying $file\n";
		copy($assetDir . $dir . "/" . $file, $targetDir . $file);
		
	}
	
	closedir(S);

}
closedir(D);

$DEBUG && print STDERR "Saving state file out \n";
store(\%fileList, $stateFile);
