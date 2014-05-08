# Win32::Shortcut::Readlink

Make readlink work with shortcuts

# SYNOPSIS

    use Win32::Shortcut::Readlink;
    
    my $target = readlink "c:\\users\\foo\\Desktop\\Application.lnk";

# DESCRIPTION

This module overloads the perl built-in function [readlink](https://metacpan.org/pod/perlfunc#readlink)
so that it will treat shortcuts like pseudo symlinks on `cygwin` and `MSWin32`.
This module doesn't do anything on any other platform, so you are free to make
this a dependency, even if your module or script is going to run on non-Windows
platforms.

This module adjusts the behavior of readlink ONLY in the calling module, so
you shouldn't have to worry about breaking other modules that depend on the
more traditional behavior.

# FUNCTION

## readlink

    my $target = readlink EXPR
    my $target = readlink

Returns the value of a symbolic link or the target of the shortcut on Windows,
if either symbolic links are implemented or if shortcuts are.  If not, raises an 
exception.  If there is a system error, returns the undefined value and sets 
`$!` (errno). If `EXPR` is omitted, uses `$_`.

# CAVEATS

Does not handle Unicode.  Patches welcome.

Before Perl 5.16, `CORE` functions could not be aliased, and you will see warnings
on Perl 5.14 and earlier if you pass undef in as the argument to readlink, even if
you have warnings turned off.  The work around is to make sure that you never pass
undef to readlink on Perl 5.14 or earlier.

# SEE ALSO

- [Win32::Shortcut](https://metacpan.org/pod/Win32::Shortcut)
- [Win32::Unicode::Shortcut](https://metacpan.org/pod/Win32::Unicode::Shortcut)
- [Win32::Symlink](https://metacpan.org/pod/Win32::Symlink)
- [Win32::Hardlink](https://metacpan.org/pod/Win32::Hardlink)

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
