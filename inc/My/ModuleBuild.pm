package My::ModuleBuild;

use strict;
use warnings;
use base qw( Module::Build );

sub new
{
  my($class, %args) = @_;

  $args{c_source}           = 'xs';
  $args{extra_linker_flags} = "-L/usr/lib/w32api -lole32 -luuid"
    if $^O eq 'cygwin';
  
  my $self = $class->SUPER::new(%args);
  
  $self;
}

1;
