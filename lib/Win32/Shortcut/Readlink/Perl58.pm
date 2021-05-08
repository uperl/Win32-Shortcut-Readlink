package Win32::Shortcut::Readlink::Perl58;

# ABSTRACT: Make readlink work with shortcuts
# VERSION

=head1 SYNOPSIS

 % perldoc Win32::Shortcut::Readlink

=head1 DESCRIPTION

This is a private class used by L<Win32::Shortcut::Readlink>.

=head1 SEE ALSO

=over 4

=item L<Win32::Shortcut::Readlink>

=back

=cut

package Win32::Shortcut::Readlink;

use strict;
use warnings;
use Carp qw( carp croak );
use constant _is_cygwin  => $^O eq 'cygwin';
use constant _is_mswin32 => $^O eq 'MSWin32';
use constant _is_windows => _is_cygwin || _is_mswin32;

sub readlink (;$)
{
  unless(_is_windows)
  {
    if(@_ > 0)
    { return CORE::readlink($_[0]) }
    else
    # If you need this feature, then please either upgrade to 5.10 or downgrade to 5.6
    { croak "implicit \$_ and Win32::Shortcut::Readlink are not interoperable on Perl 5.8.x" }
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
    { return CORE::readlink($_[0]) }
    else
    # If you need this feature, then please either upgrade to 5.10 or downgrade to 5.6
    { croak "implicit \$_ and Win32::Shortcut::Readlink are not interoperable on Perl 5.8.x" }
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

