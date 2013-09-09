#!/usr/bin/perl -w
#
# See the README.md for more details. 
#
# The most interesting variables are the three at the top:
#
# $assetDir  - is the place where iCloud is saving files - shoudn't need changing
# $stateFile - is where this script dumps state - probably don't want to be changing
#              this after you've started using the script. Killing this file will
#              cause all files currently cached in $assetDir to be copied to $targetDir
# $targetDir - Where the images will be copied to.
#
# In all these $ENV{'HOME'} will be expanded to whatever the home account is of the user
# running the script.
#

use strict;

use Data::Dumper;
use File::stat;
use Storable;
use File::Copy;

my $DEBUG = 0; # Set to 1 for some possibly useful output

### Edit these to suit ###
my $assetDir = "$ENV{'HOME'}/Library/Application Support/iLifeAssetManagement/assets/sub/";
my $stateFile = "$ENV{'HOME'}/.PhotostreamToDir.state";
my $targetDir = "$ENV{'HOME'}/Pictures/PhotoStream/";

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
