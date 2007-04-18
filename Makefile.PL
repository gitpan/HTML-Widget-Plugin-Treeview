use 5.008006;
use Getopt::Long;
my $cgi    = "/srv/www/cgi-bin";
my $htdocs = "/srv/www/htdocs";
my $prefix = "/";
my $result = GetOptions(
	"cgidir=s"  => \$cgi,
	"htdocs=s"  => \$htdocs,
	"prefix=s" =>\$prefix,
);
GOTO:;
print "Where is your Document root($htdocs?)\n";
my $in = <STDIN>;
chomp($in);
$htdocs =  -e $in ? $in :$htdocs;
die "$! \n" unless -e $htdocs;

print "Where is your cgi-bin directory ($cgi)?\n";
my $stdin = <STDIN>;
chomp($stdin);
$cgi =  -e $stdin ? $stdin :$cgi;
warn "$!: $stdin\n" unless -e $cgi;



print "Document root: $htdocs \n cgi-bin directory: $cgi \n  You have set up the follow Options, Continue ?\n (Yes/No/exit) default:yes\n";

my $k = <STDIN>;
goto GOTO if($k=~/No/i);
exit if($k=~/exit/i);
use lib("./lib");

my $makefile = "
NAME         = HTML-Widget-Plugin-Treeview
VERSION      = 0.5
PREFIX       = $prefix
INST_CGI     = blib$cgi
INSTALLCGI   = \$(PREFIX)$cgi

INST_LIB     = blib$cgi
INSTALLLIB   = \$(PREFIX)$cgi

INST_HTDOCS    = blib$htdocs
INSTALLHTDOCS  = \$(PREFIX)$htdocs


UNINST   = 0
VERBINST = 0
#Tools
PERL = /usr/bin/perl
DOINSTALL = \$(PERL) release.pl
RM_D = rm  -R

#dist
TAR = tar
TARFLAGS = cvf
ZIP = zip
COMPRESS = gzip -9
SUFFIX = gz

make:
	@\$(DOINSTALL) -release \$(INST_LIB)     -readdir lib/
	@\$(DOINSTALL) -release \$(INST_HTDOCS)  -readdir htdocs/


clean:
	@\$(RM_D) blib/

manifest :
	\$(PERL) \"-MExtUtils::Manifest=mkmanifest\" -e mkmanifest

dist:
	\$(PERL) \"-MExtUtils::Manifest=manicopy,maniread\" -e \"manicopy(maniread(),'\$(NAME)-\$(VERSION)','best') \";
	\$(TAR) \$(TARFLAGS) \$(NAME)-\$(VERSION)\.tar  \$(NAME)-\$(VERSION)
	@\$(RM_D \$(NAME)-\$(VERSION)
	\$(COMPRESS) \$(NAME)-\$(VERSION).tar


distclean :
	@rm \$(DISTVNAME)

install ::
	@\$(DOINSTALL) -release \$(PREFIX) -readdir blib/

uninstall ::
	@\$(RM_D) \$(INSTALLLIB)/HTML/Widget/Plugin/Treeview.pm
	@\$(RM_D) \$(INSTALLHTDOCS)/style


TEST_VERBOSE=0
TEST_FILES = t/*.t

test ::
	\$(PERL) \"-MExtUtils::Command::MM\" \"-e\" \"test_harness(\$(TEST_VERBOSE), '\$(INST_LIB)')\" \$(TEST_FILES)
";
open  OUT, ">./Makefile"  or die " $!\n";
print OUT $makefile;
close OUT;