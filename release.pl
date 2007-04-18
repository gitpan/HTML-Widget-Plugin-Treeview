#!/usr/bin/perl -w
use strict;
use Getopt::Long;
my $release = 'blib/';
my $dir ='lib/';
my $result = GetOptions("release=s"   => \$release,"readdir=s"   => \$dir,);
system("mkdir -p $release") unless -e $release;
&change($dir);
sub change{
	my $d = shift;
	chomp($d);

	opendir(IN,$d) or  die  "cant open $d $!:\n" ;
	my @files = readdir(IN);
	closedir(IN);
	for(my $i = 0; $i <= $#files; $i++){

	unless($files[$i]=~/^\./ ){
			my $c = $d.$files[$i];
			my $e = $c;
			$e=~s/^$dir(.*)/$1/;
			unless(-d $d.$files[$i]){
				system(" cp ".$c." $release/$e") unless( $files[$i]=~/\~$/ );
                        }else{
				unless($files[$i]=~/CVS/ ){
				system("mkdir -p $release/$e") unless(-e $release."/".$e );
				&change($d.$files[$i]."/");
				}
                        }
	}
	}
}

1;