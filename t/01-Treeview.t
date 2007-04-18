use lib("../lib");

use HTML::Widget::Plugin::Treeview qw(Tree);
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

my $treeview = new HTML::Widget::Plugin::Treeview();
my $tree =  $treeview->Tree(\@tree);
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

use Test::More tests =>3;
my $tree2 =  Tree(\@tree);
ok(length($tree2) eq length($tree));
my $tree3 =  Tree(\@tree2);
ok(length($tree3) < length($tree));
my $treeview2 = new HTML::Widget::Plugin::Treeview(\@tree2,$style);
my $tree4 = $treeview2->Tree();
ok(length($tree3) == length($tree4));
1;