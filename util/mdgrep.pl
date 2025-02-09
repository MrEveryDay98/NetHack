#!perl
# NetHack 3.7  mdgrep.pl  $NHDT-Date: 1693083351 2023/08/26 20:55:51 $  $NHDT-Branch: keni-crashweb2 $:$NHDT-Revision: 1.24 $
# Copyright (c) Kenneth Lorber, Kensington, Maryland
# NetHack may be freely redistributed.  See license for details.

# MAKEDEFS:
@commands = qw/grep/;

# GREP:
# Operating Systems:
@os = qw/WIN32 MSDOS VMS UNIX TOS AMIGA MAC WINNT __BEOS__ WIN_CE OS2
	WIN_CE_SMARTPHONE WIN_CE_POCKETPC WIN_CE_PS2xx
	WIN32_PLATFORM_HPCPRO WIN32_PLATFORM_WFSP/;

# Window Systems:
@win = qw/TTY_GRAPHICS MAC_GRAPHICS AMII_GRAPHICS MSWIN_GRAPHICS X11_GRAPHICS
	QT_GRAPHICS GNOME_GRAPHICS GEM_GRAPHICS/;

# Game Features:
@feature = qw/ZEROCOMP TILES_IN_GLYPHMAP ASCIIGRAPH CLIPPING TEXTCOLOR
	COMPRESS ZLIB_COMP RANDOM SECURE USER_SOUNDS
	SAFERHANGUP MFLOPPY NOCWD_ASSUMPTIONS
	VAR_PLAYGROUND DLB SHELL SUSPEND NOSAVEONHANGUP HANGUPHANDLING
	BSD_JOB_CONTROL MAIL POSIX_JOB_CONTROL INSURANCE
	UNICODE_DRAWING UNICODE_WIDEWINPORT UNICODE_PLAYERTEXT
	CRASHREPORT
/;

# Miscellaneous
@misc = qw/BETA/;

# Meta
@meta = qw/ALLDOCS/;	# convention: use --grep-define ALLDOCS to notate
			# items that are conditionally available

# JUNK:
# MICRO BSD __GNUC__ NHSTDC TERMLIB __linux__ LINUX WIN32CON NO_TERMS
# ULTRIX_PROTO TERMINFO _DCC DISPMAP OPT_DISPMAP TARGET_API_MAC_CARBON
# NOTTYGRAPHICS SYSV ULTRIX MAKEDEFS LEV_LEX_C __STDC__
# BITCOUNT TILE_X COLORS_IN_USE CHDIR KR1ED
# apollo __APPLE__ AIX_31 PC9800 __MACH__ _GNU_SOURCE __EMX__ DGUX
# __MWERKS__ __MRC__ __BORLANDC__ LINT THINK_C __SC__ AZTEC_C __FreeBSD__
# USE_PROTOTYPES __DJGPP__ macintosh POSIX_TYPES SUNOS4 _MSC_VER __OpenBSD__
# GCC_WARN VOIDYYPUT FLEX_SCANNER FLEXHACK_SCANNER WIERD_LEX
# NeXT __osf__ SVR4 _AIX32 _BULL_SOURCE AUX __sgi GNUDOS
# TIMED_DELAY DEF_MAILREADER DEF_PAGER NO_SIGNAL PC_LOCKING LATTICE __GO32__
# msleep NO_FILE_LINKS bsdi HPUX AMIFLUSH
# SCREEN_BIOS SCREEN_DJGPPFAST SCREEN_VGA SCREEN_8514
# EXEPATH NOTSTDC SELECTSAVED NOTPARMDECL

# constants
@const_true = qw/1 TRUE/;
@const_false = qw/0 FALSE/;

$outfile = "mdgrep.h";
sub start_file {
	($rev) = ('$NHDT-Revision: 1.24 $') =~ m/: (.*) .$/;
	my $date = '$NHDT-Date: 1693083351 2023/08/26 20:55:51 $';
	my $branch = '$NHDT-Branch: keni-crashweb2 $';
	my $revision = '$NHDT-Revision: 1.24 $';
	open(OUT, ">$outfile") || die "open $outfile: $!";
# NB: Date and Revision below will be modified when mdgrep.h is written to
# git - this is correct (but it means you must commit changes to mdgrep.pl
# before generating mdgrep.h and committing that file).
	print OUT <<E_O_M;
/*
 * NetHack 3.7  $outfile  $date $branch:$revision
 * Copyright (c) Kenneth Lorber, Kensington, Maryland, 2008
 * NetHack may be freely redistributed.  See license for details.
 *
 * This file generated by mdgrep.pl version $rev.
 * DO NOT EDIT!  Your changes will be lost.
 */
E_O_M
}

sub end_file {
	print OUT "/* End of file */\n";
	close OUT;
}

sub gen_magic {
	local($v, @x) = @_;
	foreach (@x){
		$magic{$_} = $v;
	}
}

# NB: Do NOT make grep_vars const - it needs to be writable for some debugging
# options.
sub gen_file {
	print OUT "static struct grep_var grep_vars[]={\n";
	foreach(@_){
		if(defined $magic{$_}){
			print OUT <<E_O_M;
	{"$_", $magic{$_}},
E_O_M
			next;
		}
		print OUT <<E_O_M;
#if defined($_)
	{"$_", 1},
#else
	{"$_", 0},
#endif
E_O_M
	}
	print OUT "\t{0,0}\n};\n";
}

sub gen_commands {
	local($x) = 1;
	print OUT "\n/* Command ids */\n";
	foreach(@commands){
		print OUT "#define TODO_\U$_\E $x\n";
	}
	print OUT "\n";
}

&start_file;
&gen_magic(0, @const_false);
&gen_magic(1, @const_true);
&gen_file(sort(@os,@win,@feature,@misc,@meta,@const_false,@const_true));
&gen_commands;
&end_file;
