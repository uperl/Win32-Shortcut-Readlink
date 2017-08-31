package mymm;

use strict;
use warnings;
use ExtUtils::MakeMaker;
use File::Copy qw( copy );

sub myWriteMakefile
{
  my(%args) = @_;
  
  if($^O =~ /^(cygwin|MSWin32|msys)$/)
  {
    $args{INC}    = '-Ixs';
    $args{LIBS}   = [ '-L/usr/lib/w32api -lole32 -luuid' ] if $^O eq 'cygwin';
    $args{OBJECT} = [ 'Readlink$(OBJ_EXT)', 'resolve$(OBJ_EXT)' ];

    foreach my $name (qw( Readlink.xs resolve.cpp typemap ))
    {
      my $from = "xs/$name";
      my $to   = "$name";
      unlink $to if -f $to;
      copy($from, $to) || die "unable to copy $from to $to $!";
    }
  }

  WriteMakefile(%args);
}

1;
