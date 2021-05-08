package Win32::Shortcut::Readlink::Perl510;

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
use Carp qw( carp );
use constant _is_cygwin  => $^O eq 'cygwin';
use constant _is_mswin32 => $^O eq 'MSWin32';
use constant _is_windows => _is_cygwin || _is_mswin32;

sub _real_readlink (_);
# TODO: only warn in 5.14 or earlier if warnings on in caller
*_real_readlink = eval { require 5.016000 } ? \&CORE::readlink : sub (_) { CORE::readlink($_[0]) };

sub readlink (_)
{
  goto &_real_readlink unless _is_windows;

  if(defined $_[0] && $_[0] =~ /\.lnk$/ && -r $_[0])
  {
    my $target = _win32_resolve(_is_cygwin ? Cygwin::posix_to_win_path($_[0]) : $_[0]);
    return $target if defined $target;
  }

  goto &_real_readlink if _is_cygwin;

  # else is MSWin32
  # emulate unix failues
  if(!defined $_[0])
  {
    # TODO: only warn if warnings on in caller
    carp "Use of uninitialized value in readlink";
    $! = 22;
  }
  elsif(-e $_[0])
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

