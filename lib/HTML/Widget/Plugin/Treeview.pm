package HTML::Widget::Plugin::Treeview;
use 5.008006;
use strict;
use warnings;
require Exporter;
use vars qw($DefaultClass @EXPORT @ISA);
@ISA                                       = qw(Exporter);
@HTML::Widget::Plugin::Treeview::EXPORT_OK = qw(Tree css jscript setStyle getStyle setDocumentRoot getDocumentRoot);
$HTML::Widget::Plugin::Treeview::VERSION   = '0.5';
$DefaultClass                              = 'HTML::Widget::Plugin::Treeview' unless defined $HTML::Widget::Plugin::Treeview::DefaultClass;

our $id    = "a";
our $style = "Crystalm";
our $path  = '.';

=head1 NAME

HTML::Widget::Plugin::Treeview

=head1 SYNOPSIS 

use HTML::Widget::Plugin::Treeview qw(Tree);

my @tree =( {
	
	text => 'Folder',
	
	folderclass => 'folderMan',

	subtree => [

		{

                text => 'treeview.tigris.org',

                href => 'http://treeview.tigris.org',

		}

            ],

},);

Tree(\tree);

Possible values for folderclass :

folderMan, folderVideo,folderCrystal, folderLocked , folderText, folderFavorite, folderPrint,folderHtml,folderSentMail,folderImage,folderSound,folderImportant,folderTar

=head2 OO Syntax

use HTML::Widget::Plugin::Treeview qw(Tree);

use strict;

my @tree =(

	{

        image => 'tar.png',

        onclick => "alert('onclick');",

        text => 'Node',

	},

	{

        href => "http://www.google.de",

        text => 'Node',

	},

	{

        text => 'Folder',
        folderclass => 'folderMan', # only for Crystal styles
        subtree => [

		{

                text => 'treeview.tigris.org',

                href => 'http://treeview.tigris.org',

		},

            ],

	}	,
);

my $treeview = new HTML::Widget::Plugin::Treeview();

$treeview->setStyle("bw");

print $treeview->css('.');

print treeview->jscript();

print $treeview->Tree(\@tree);

=head2 FO Syntax

use HTML::Widget::Plugin::Treeview qw(Tree css jscript setStyle setDocumentRoot);

use strict;

my @tree =(

	{

        image => 'tar.png',

        onclick => "alert('onclick');",

        text => 'Node',

	},

	{

        href => "http://www.google.de",

        text => 'Node',

	},

	{

        text => 'Folder',

        subtree => [

	{

                text => 'treeview.tigris.org',

                href => 'http://treeview.tigris.org',

	},

            ],

	},
);

setDocumentRoot("/srv/www/httpdocs");

setStyle("Crystalm");

print css();

print jscript();

print Tree(\@tree);

=head1 DESCRIPTION

treeview.pm ist a Modul to build an Html tree of an AoH.

=head1 Changes

0.5

new Namespace HTML::Widget::Plugin::Treeview

new styles red green orange.

alternate folder symbols for Crystalm style.

one folder for mimetypes (link images).

warn instead of  die

spacer.gif for emty cells which contain only a background image.

Overwrought code, test, Documentation, styles, exaples.

shebang within pod crashes some older Perl verions

if you want use treevie.pm with perl > 5.008006 you should remove use 5.008006;.

0.4

New SYNTAX, setter for DocumentRoot and Style.

Overwrought Documentation, code,exaples.

New default style (Crystalm).

0.3

Opera fixed...

0.2

should be fit for mod_perl,

the main change is that modul make use of a Lincoln Loader like getSelf method to provide an OO and FO Syntax

(the SYNOPSIS).

cleaner code.

=head1 PUBLIC

=head2  new()

show SYNOPSIS.

=cut

sub new {
    my ($class, @initializer) = @_;
    my $self = {tree => undef,};
    bless $self, ref $class || $class || $DefaultClass;
    $style = $initializer[1] if(defined $initializer[1]);
    $self->initTree(@initializer) if(@initializer);
    return $self;
} ## end sub new

=head2 setStyle($style)

setStyle("style");

bw = Black & White Style

blw = Blue Style

blwm = Blue Modern Style

plastic = Plastic Style

plasticm = Plastic Modern Style

kde = Suse 10.1 like style

Crystalm = Suse 10.1 like style

simple = redmond like style

simplem = modern redmond like style

system = Gray redmond like style

red = red Modern Style

green  =  green Modern Style

orange = orange Modern Style

=cut

sub setStyle {
    my ($self, @p) = getSelf(@_);
    $style = $p[0];
}

=head2 getStyle()

mainly for testing.

=cut

sub getStyle {
    my ($self, @p) = getSelf(@_);
    return $style;
}

=head2 setDocumentRoot($path)

set the local path to the style folder.

should be the DocumentRoot of the webserver.

example: setPath('/srv/www/htdocs');

default: /srv/www/htdocs'

=cut

sub setDocumentRoot {
    my ($self, @p) = getSelf(@_);
    $path = $p[0];
}

=head2 getDocumentRoot()

mainly for testing.

=cut

sub getDocumentRoot {
    my ($self, @p) = getSelf(@_);
    return $path;
}

=head2 css()

return the  necessary css part without <style></style> tag.

You can also include it with

<link href="/style/Crystalm/Crystalm.css" rel="stylesheet" type="text/css">

=cut

sub css {
    my ($self, @p) = getSelf(@_);
    use Fcntl qw(:flock);
    use Symbol;
    my $fh   = gensym;
    my $file = "$path/style/$style/$style.css";
    open $fh, "$file" or warn "no style '$style.css' $style.css found \n  in  $path/style/$style/ \n $!";
    seek $fh, 0, 0;
    my @lines = <$fh>;
    close $fh;
    my $css;

    for(@lines) {
        $css .= $_;
    }
    return $css;
} ## end sub css

=head2 jscript()

return the necessary  javascript  without <script> tag.

You can also include it with

<script language="JavaScript1.5"  type="text/javascript" src="/style/treeview.js"></script>

=cut

sub jscript {
    return "
function ocFolder(id){
var  folder = document.getElementById(id).className;
if(folder == 'folderOpen'){
 document.getElementById(id).className = 'folderClosed';
}else if(folder == 'folderClosed'){
document.getElementById(id).className = 'folderOpen';
}else{
var mclass = /(folder.*)Closed/;
var isclosed = mclass.test(folder);
if (isclosed == true){
document.getElementById(id).className = mclass.replace(/(folder.*)Closed/, '$1');
}else{
document.getElementById(id).className = mclass.replace(/(folder.*)/, '\$1Closed')
}
}
}
function ocNode(id){
var folder = document.getElementById(id).className;if(folder == \"minusNode\"){
document.getElementById(id).className = 'plusNode';
}else if(folder == \"plusNode\"){
document.getElementById(id).className = 'minusNode';
}
}
function ocpNode(id){
var folder = document.getElementById(id).className;
if(folder == \"lastMinusNode\"){
document.getElementById(id).className = 'lastPlusNode';
}else if(folder == \"lastPlusNode\"){
document.getElementById(id).className = 'lastMinusNode';
}
}
function displayTree(id){
var e = document.getElementById(id);
var display = e.style.display;
if(display == \"none\"){
e.style.display = \"\";
}else if(display == \"\"){
e.style.display = \"none\";
}
}
";
} ## end sub jscript

=head2 Tree()

Tree(\@tree,optional $style);

Returns the treeview without  javasript and css.

=cut

sub Tree {
    my ($self, @p) = getSelf(@_);
    $style = $p[1] if(defined $p[1]);
    $self->initTree(@p) if(@p);
    return '<table align="left" class="treeview" border="0" cellpadding="0" cellspacing="0" summary="treeTable"  ><colgroup><col width="16"></colgroup>' . $self->{tree} . '</table>';
} ## end sub Tree

=head1 PRIVATE

=head2 privat initTree()

$self->initTree(\@tree);

called by Tree.

=cut

sub initTree {
    my ($self, @p) = getSelf(@_);
    my $tree   = $p[0];
    my $length = @$tree;
    for(my $i = 0 ; $i < @$tree ; $i++) {
        $length--;
        if(defined @{@$tree[$i]->{subtree}}) {
            if($length > 0) {
                $self->appendFolder(@$tree[$i], \@{@$tree[$i]->{subtree}});
            } elsif ($length eq 0) {
                $self->appendLastFolder(@$tree[$i], \@{@$tree[$i]->{subtree}});
            }
        } else {
            if($length > 0) {
                $self->appendNode(@$tree[$i]);
            } elsif ($length eq 0) {
                $self->appendLastNode(@$tree[$i]);
            }
        } ## end else [ if(defined @{@$tree[$i...
    } ## end for(my $i = 0 ; $i < @$tree...
} ## end sub initTree

=head2 privat getSelf()

my($self,@p) = getSelf(@_);

=cut

sub getSelf {
    return @_ if defined($_[0]) && (!ref($_[0])) && ($_[0] eq 'HTML::Widget::Plugin::Treeview');
    return (defined($_[0]) && (ref($_[0]) eq 'HTML::Widget::Plugin::Treeview' || UNIVERSAL::isa($_[0], 'HTML::Widget::Plugin::Treeview'))) ? @_ : ($HTML::Widget::Plugin::Treeview::DefaultClass->new, @_);
}

=head2 privat appendFolder()

called by initTree.

=cut

sub appendFolder {
    my $self    = shift;
    my $node    = shift;
    my $subtree = shift;
    ++$id;
    $node->{onclick} = defined $node->{onclick} ? $node->{onclick} : defined $node->{href} ? "" : "displayTree('$id'); ocFolder('$id.folder');ocNode('$id.node');";
    $node->{class} = defined $node->{class} ? $node->{class} : 'treeviewLink';
    my $FolderClass = defined $node->{folderclass} ? $node->{folderclass} : 'folderOpen';

    my $tt;
    foreach my $key (keys %{$node}) {
        $tt .= $key . '="' . $node->{$key} . '" ' unless ($key =~ /text|subtree|FolderClass/);
    }
    $self->{tree} .=
      "<tr class=\"trSubtreeCaption\"><td  id=\"$id.node\" class=\"minusNode\" onclick=\"displayTree('$id'); ocFolder('$id.folder');ocNode('$id.node');\"><img src=\"/style/$style/spacer.gif\" border=\"0\" width=\"16\" height=\"22\" alt=\"spacer\"/></td><td align=\"left\" class=\"$FolderClass\" id=\"$id.folder\"><a $tt>$node->{text}</a></td></tr><tr id=\"$id\" class=\"trSubtree\"><td class=\"submenuDeco\"><img src=\"/style/$style/spacer.gif\" border=\"0\" width=\"16\" height=\"22\" alt=\"spacer\"/></td><td class=\"submenu\"><table align=\"left\"  border=\"0\" cellpadding=\"0\" cellspacing=\"0\"  class=\"subtreeTable\" summary=\"treeTable\" width=\"100%\"><colgroup><col width=\"16\"></colgroup>";
    $self->initTree(\@$subtree);
    $self->{tree} .= "</table></td></tr>";
} ## end sub appendFolder

=head2 privat appendLastFolder()

show appendFolder

=cut

sub appendLastFolder {
    my $self    = shift;
    my $node    = shift;
    my $subtree = shift;
    $id++;
    $node->{onclick} = defined $node->{onclick} ? $node->{onclick} : defined $node->{href} ? "" : "displayTree('$id'); ocFolder('$id.folder');ocNode('$id.node');";
    $node->{class} = defined $node->{class} ? $node->{class} : 'treeviewLink';
    my $FolderClass = defined $node->{FolderClass} ? $node->{FolderClass} : 'folderOpen';
    my $tt;

    foreach my $key (keys %{$node}) {
        $tt .= $key . '="' . $node->{$key} . '" ' unless ($key =~ /text|subtree|folderclass/);
    }
    $self->{tree} .=
      "<tr class=\"lasttreeviewItem\"><td id=\"$id.node\" class=\"lastMinusNode\" onclick=\"displayTree('$id');ocFolder('$id.folder');ocpNode('$id.node');\"></td><td align=\"left\" class=\"$FolderClass\" id=\"$id.folder\"><a $tt>$node->{text}</a></td></tr><tr id=\"$id\" class=\"trSubtree\"><td ><img src=\"/style/$style/spacer.gif\" border=\"0\" width=\"16\" height=\"22\" alt=\"spacer\"/></td><td class=\"\"><table align=\"left\" width=\"100%\" cellpadding=\"0\" cellspacing=\"0\"   border=\"0\"  class=\"subtreeTable\" summary=\"treeTable\"><colgroup><col width=\"16\"></colgroup>";
    $self->initTree(\@$subtree);
    $self->{tree} .= "</table></td></tr>";
} ## end sub appendLastFolder

=head2 privat appendNode()

called by initTree.

=cut

sub appendNode {
    my $self = shift;
    my $node = shift;
    $node->{image} = defined $node->{image} ? $node->{image} : "link.gif";
    $node->{class} = defined $node->{class} ? $node->{class} : 'treeviewLink';
    my $tt;
    foreach my $key (keys %{$node}) {
        $tt .= $key . '="' . $node->{$key} . '" ' unless ($key =~ /text|image/);
    }
    $self->{tree} .=
      "<tr class=\"treeviewItem\"><td width=\"16\" class=\"node\"><img src=\"/style/$style/spacer.gif\" border=\"0\" width=\"16\" height=\"22\" alt=\"spacer\"/></td><td align=\"left\"  style=\"background-image:url('/style/mimetypes/$node->{image}');background-repeat:no-repeat;cursor:pointer;padding-left:20px;\"><a $tt>$node->{text}</a></td></tr>";
} ## end sub appendNode

=head2 privat appendLastNode()

show appendNode.

=cut

sub appendLastNode {
    my $self = shift;
    my $node = shift;
    $node->{image} = defined $node->{image} ? $node->{image} : "link.gif";
    $node->{class} = defined $node->{class} ? $node->{class} : 'treeviewLink';
    my $tt;
    foreach my $key (keys %{$node}) {
        $tt .= $key . '="' . $node->{$key} . '" ' unless ($key =~ /text|image/);
    }
    $self->{tree} .=
      "<tr class=\"treeviewItem\"><td  class=\"lastNode\"><img src=\"/style/$style/spacer.gif\" border=\"0\" width=\"16\" height=\"22\" alt=\"spacer\"/></td><td align=\"left\"  style=\"background-image:url('/style/mimetypes/$node->{image}');background-repeat:no-repeat;cursor:pointer;font-size:14px;padding-left:20px;\"><a $tt>$node->{text}</a></td></tr>";
} ## end sub appendLastNode

=head1 AUTHOR

Dirk Lindner <dirk.lindner@gmx.de>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Hr. Dirk Lindner

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330,
Boston, MA  02111-1307, USA.

=cut

1;
