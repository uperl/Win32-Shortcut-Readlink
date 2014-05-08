package Win32::Shortcut::Readlink;

use strict;
use warnings;
use base qw( Exporter );
use Carp qw( carp );
use constant _is_cygwin  => $^O eq 'cygwin';
use constant _is_mswin32 => $^O eq 'MSWin32';
use constant _is_windows => _is_cygwin || _is_mswin32;

BEGIN {

# ABSTRACT: Make readlink work with shortcuts
# VERSION

  if($^O =~ /^(cygwin|MSWin32)$/)
  {
    require XSLoader;
    XSLoader::load('Win32::Shortcut::Readlink', $Win32::Shortcut::Readlink::VERSION);
  }

}

=head1 SYNOPSIS

 use Win32::Shortcut::Readlink;
 
 my $target = readlink "c:\\users\\foo\\Desktop\\Application.lnk";

=head1 DESCRIPTION

This module overloads the perl built-in function L<readlink|perlfunc#readlink>
so that it will treat shortcuts like pseudo symlinks on C<cygwin> and C<MSWin32>.
This module doesn't do anything on any other platform, so you are free to make
this a dependency, even if your module or script is going to run on non-Windows
platforms.

This module adjusted the behavior of readlink ONLY in the calling module, so
you shouldn't have to worry about breaking other modules that depend on the
more traditional behavior.

=cut

our @EXPORT_OK = qw( readlink );
our @EXPORT    = @EXPORT_OK;

=head1 FUNCTION

=head2 readlink

 my $target = readlink EXPR
 my $target = readlink

Returns the value of a symbolic link or the target of the shortcut on Windows,
if either symbolic links are implemented or if shortcuts are.  If not, raises an 
exception.  If there is a system error, returns the undefined value and sets 
C<$!> (errno). If C<EXPR> is omitted, uses C<$_>.

=cut

sub readlink (_)
{
  goto &CORE::readlink unless _is_windows;
  
  if(defined $_[0] && $_[0] =~ /\.lnk$/ && -r $_[0])
  {
    my $target = _win32_resolve(_is_cygwin ? Cygwin::posix_to_win_path($_[0]) : $_[0]);
    return $target if defined $target;
  }

  goto &CORE::readlink if _is_cygwin;

  # else is MSWin32
  # emulate unix failues
  if(-e $_[0])
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

=head1 CAVEATS

Does not handle Unicode.  Patches welcome.

=head1 SEE ALSO

=over 4

=item L<Win32::Shortcut>

=item L<Win32::Symlink>

=item L<Win32::Hardlink>

=back

=cut
