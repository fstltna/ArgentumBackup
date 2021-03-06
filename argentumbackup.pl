#!/usr/bin/perl

# Set these for your situation
my $SYNCDIR = "/home/argentumowner/anura";
my $BACKUPDIR = "/home/argentumowner/backups";
my $TARCMD = "/bin/tar czf";
my $VERSION = "1.1";

# Init file data
my $MySettings = "$ENV{'HOME'}/.argbackuprc";
my $BACKUPUSER = "";
my $BACKUPPASS = "";
my $BACKUPSERVER = "";
my $BACKUPPATH = "";
my $DEBUG_MODE = "off";

#-------------------
# No changes below here...
#-------------------

sub ReadConfigFile
{
	# Check for config file
	if (-f $MySettings)
	{
		# Read in settings
		open (my $FH, "<", $MySettings) or die "Could not read default file '$MySettings' $!";
		while (<$FH>)
		{
			chop();
			my ($Command, $Setting) = split(/=/, $_);
			if ($Command eq "backupuser")
			{
				$BACKUPUSER = $Setting;
			}
			if ($Command eq "backuppass")
			{
				$BACKUPPASS = $Setting;
			}
			if ($Command eq "backupserver")
			{
				$BACKUPSERVER = $Setting;
			}
			if ($Command eq "backuppath")
			{
				$BACKUPPATH = $Setting;
			}
			if ($Command eq "debugmode")
			{
				$DEBUG_MODE = $Setting;
			}
		}
		close($FH);
	}
	else
	{
		# Store defaults
		open (my $FH, ">", $MySettings) or die "Could not create default file '$MySettings' $!";
		print $FH "backupuser=\n";
		print $FH "backuppass=\n";
		print $FH "backupserver=\n";
		print $FH "backuppath=\n";
		print $FH "debugmode=off\n";
		close($FH);
	}
}

sub PrintDebugCommand
{
	if ($DEBUG_MODE eq "off")
	{
		return;
	}
	my $PassedString = shift;
	print "About to run:\n$PassedString\n";
	print "Press Enter To Run This:";
	my $entered = <STDIN>;
}

ReadConfigFile();

print "ArgentumBackup - back up your Argentum Age server - version $VERSION\n";
print "======================================================\n";

if (! -d $BACKUPDIR)
{
	print "Backup dir $BACKUPDIR not found, creating...\n";
	system("mkdir -p $BACKUPDIR");
}
print "Moving existing backups: ";

if (-f "$BACKUPDIR/citbackup-5.tgz")
{
	unlink("$BACKUPDIR/argentumbackup-5.tgz")  or warn "Could not unlink $BACKUPDIR/argentumbackup-5.tgz: $!";
}
if (-f "$BACKUPDIR/argentumbackup-4.tgz")
{
	rename("$BACKUPDIR/argentumbackup-4.tgz", "$BACKUPDIR/argentumbackup-5.tgz");
}
if (-f "$BACKUPDIR/argentumbackup-3.tgz")
{
	rename("$BACKUPDIR/argentumbackup-3.tgz", "$BACKUPDIR/argentumbackup-4.tgz");
}
if (-f "$BACKUPDIR/argentumbackup-2.tgz")
{
	rename("$BACKUPDIR/argentumbackup-2.tgz", "$BACKUPDIR/argentumbackup-3.tgz");
}
if (-f "$BACKUPDIR/argentumbackup-1.tgz")
{
	rename("$BACKUPDIR/argentumbackup-1.tgz", "$BACKUPDIR/argentumbackup-2.tgz");
}
print "Done\nCreating Backup: ";
system("$TARCMD $BACKUPDIR/argentumbackup-1.tgz $SYNCDIR --exclude='/sbbs/ctrl/localspy*.sock' --exclude='/sbbs/ctrl/status.sock'");
if ($BACKUPSERVER ne "")
{
	print "Offsite backup requested\n";
	print "Copying $BACKUPDIR/argentumbackup-1.tgz to $BACKUPSERVER:$BACKUPPORT\n";
	PrintDebugCommand("rsync -avz -e ssh $BACKUPDIR/argentumbackup-1.tgz $BACKUPUSER\@$BACKUPSERVER:$BACKUPPATH\n");
	system ("rsync -avz -e ssh $BACKUPDIR/argentumbackup-1.tgz $BACKUPUSER\@$BACKUPSERVER:$BACKUPPATH");
}

print("Done!\n");
exit 0;
