package
  Win32::Shortcut::Readlink;

use strict;
use warnings;
use Carp qw( carp );
use constant _is_cygwin  => $^O eq 'cygwin';
use constant _is_mswin32 => $^O eq 'MSWin32';
use constant _is_windows => _is_cygwin || _is_mswin32;

sub readlink (;$)
{
  if(_is_windows)
  {
    if(@_ > 0)
    { CORE::readlink($_) }
    else
    { CORE::readlink($_[0]) }
  }

  my $arg = @_ > 0 ? $_[0] : $_;
  
  if(defined $arg && $arg =~ /\.lnk$/ && -r $arg)
  {
    my $target = _win32_resolve(_is_cygwin ? Cygwin::posix_to_win_path($arg) : $arg);
    return $target if defined $target;
  }

  if(_is_cygwin)
  {
    if(@_ > 0)
    { CORE::readlink($_) }
    else
    { CORE::readlink($_[0]) }
  }

  # else is MSWin32
  # emulate unix failues
  if(!defined $arg)
  {
    # TODO: only warn if warnings on in caller
    carp "Use of uninitialized value in readlink";
    $! = 22;
  }
  elsif(-e $arg)
  {
    $! = 22; # Invalid argument
  }
  else
  {
    $! = 2; # No such file or directory
  }
  
  return;
}

1;

