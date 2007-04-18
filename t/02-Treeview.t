use lib("../lib");

use HTML::Widget::Plugin::Treeview qw(css setDocumentRoot jscript setStyle getStyle setDocumentRoot getDocumentRoot);
my @tree =(
	{
	text => '<a href="treeview.pl" class="link">News</a>',
	dir => [
		{
			text => 'Treeview',
			href => 'attribute',
			image => "news.gif"
		},
	],
	},
	{
		text => "Help",
		onclick => 'attribute',
		image =>"help.gif"
	},
);


my @tree2 =(
	{
	text => '<a href="treeview.pl" class="link">News</a>',
	dir => [
		{
			text => 'Treeview',
			href => 'attribute',
			image => "news.gif"
		},
	],
	},
);

use Test::More tests =>5;
my $treeview = new HTML::Widget::Plugin::Treeview();
my $js =  $treeview->jscript();
my $js2 =  jscript();
ok(length($js2) eq length($js));
my $style =  getStyle();
my $treeview2 = new HTML::Widget::Plugin::Treeview(\@tree2);
my $style2 = $treeview2->getStyle();
ok(length($style) eq length($style2));
setStyle("system");
ok($treeview2->getStyle() eq "system");
$treeview2->setDocumentRoot("$ENV{PWD}/htdocs");
ok(getDocumentRoot() eq "$ENV{PWD}/htdocs");
ok(length(css()) > 0);


1;
