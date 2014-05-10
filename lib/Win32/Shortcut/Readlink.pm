package Win32::Shortcut::Readlink;

use strict;
use warnings;
use base qw( Exporter );

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

This module adjusts the behavior of readlink ONLY in the calling module, so
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

if(eval { require 5.010000 })
{
  require Win32::Shortcut::Readlink::Perl510;
}
else
{
  require Win32::Shortcut::Readlink::Perl56;
}

1;

=head1 CAVEATS

Does not handle Unicode.  Patches welcome.

Before Perl 5.16, C<CORE> functions could not be aliased, and you will see warnings
on Perl 5.14 and earlier if you pass undef in as the argument to readlink, even if
you have warnings turned off.  The work around is to make sure that you never pass
undef to readlink on Perl 5.14 or earlier.

=head1 SEE ALSO

=over 4

=item L<Win32::Shortcut>

=item L<Win32::Unicode::Shortcut>

=item L<Win32::Symlink>

=item L<Win32::Hardlink>

=back

=cut
