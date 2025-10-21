#!/usr/bin/perl
use strict;
use warnings;
use Time::HiRes qw(sleep);

# Gross-Lite (ASCII-Only) — same UX, mildly obfuscated internals.

$| = 1;      # autoflush
$, = '';     # odd print separator (harmless)

# --- Decode fortunes stored in DATA (reverse + ROT13), robust parser ---
my @LEVELS = do {
    my (@levels, @cur);
    while (defined(my $line = <DATA>)) {
        chomp $line;
        $line =~ s/\r$//;               # handle CRLF on Windows
        next if $line =~ /^\s*#/;       # skip comment lines like "# Level 0"
        if ($line =~ /^\s*$/) {         # blank line = level separator
            push @levels, [ @cur ] if @cur;
            @cur = ();
            next;
        }
        $line =~ s/^\s+|\s+$//g;        # trim
        my $decoded = reverse($line);
        $decoded =~ tr/A-Za-z/N-ZA-Mn-za-m/;  # ROT13
        push @cur, $decoded;
    }
    push @levels, [ @cur ] if @cur;     # last level
    die "No fortunes parsed from __DATA__\n" unless @levels;
    @levels;
};

# Symbol-table alias (ASCII only) for mild indirection
*RUNNER = \&main;

RUNNER();  # jump to main()

# === main entrypoint ===
sub main {
    my @levels = @LEVELS;  # array of arrayrefs
    my @callbacks = (
        "Also %s is now your brother in law",
        "Congratulations, you were watch free on your duty day but someone went SIQ, enjoy the 02-07",
        "You get underway tomorrow. Surprise!",
        "You arrived at your duty station in San Diego only to realize you're homeport shifting to a new base in Diego Garica. Oof.",
    );

    print "\n=== Fortune Escalator v1.0 ===\n";
    print "Give me a name (or press Enter to stay mysterious): ";
    chomp(my $name = <STDIN>);
    $name = ($name =~ /\S/) ? $name : "Stranger";

    # deterministic-ish seed by name, with a touch of time
    my $seed = 0; $seed += ord($_) for split //, $name; $seed += time % 997; srand($seed);

    print "\nHello, $name. Fortune style: playful -> uncomfortable -> legendary.\n";
    print "Press Enter to receive a fortune. Type 'quit' or 'exit' to stop. Type 'reveal' to end with a polite bow.\n\n";

    my $level = 0;          # 0..$#levels
    my $count = 0;

    FORT_LOOP: while (1) {
        print "[level $level] > ";
        chomp(my $input = <STDIN>);
        last FORT_LOOP unless defined $input;           # EOF (Ctrl+Z/Enter on Windows)
        $input =~ s/^\s+|\s+$//g;

        if (lc $input eq 'quit' or lc $input eq 'exit') {
            print "\nAlright, soldier. Fortune shift aborted. Go be excellent.\n";
            last FORT_LOOP;
        }
        if (lc $input eq 'reveal') {
            print "\nPulling the curtain: this is a scripted fortune escalator. No one knows your secrets.\n";
            last FORT_LOOP;
        }

        # fake dramatic typing
        my $d = 0.02 + rand() * 0.09;
        for (split //, "thinking") { print; sleep $d; }
        print "\n";

        # Pick a fortune from current level (guarded)
        my $pool = $levels[$level] // [];
        my $fortune = @$pool
            ? $pool->[ int rand @$pool ]
            : "(no fortunes available at this level)";

        # 30% personalization
        if (rand() < 0.30) {
            my $cb = $callbacks[int rand @callbacks];
            $cb =~ s/%s/$name/g;
            $fortune .= " Also: expect $cb.";
        }

        # slight corruption at top level
        $fortune = corrupt_line($fortune) if $level >= $#levels && rand() < 0.40;

        mutate_print($fortune);   # (prints itself; do NOT 'print' its return)

        $count++;

        # Escalation: random nudge or deterministic every 3 fortunes
        if ($count > 1 && rand() < 0.35) {
            $level++ if $level < $#levels;
        } elsif ($count % 3 == 0) {
            my $target = int($count / 3);
            $level = $target > $#levels ? $#levels : $target;
        }

        # Safety clamp (should be unnecessary, but prevents negatives)
        $level = 0           if $level < 0;
        $level = $#levels    if $level > $#levels;

        print "\n";
    }

    print "\nGood fortune (or whatever passes for it) to you, $name. Exit with pride.\n";
}

# --- helpers ---
sub mutate_print {
    my ($t) = @_;
    return unless defined $t;               # guard
    $t =~ s/,$/, and then/g if rand() < 0.15;
    if (rand() < 0.22) { $t .= ' (aside: ' . short_side_note() . ')' }
    for (split //, $t) { print; sleep 0.005 + rand() * 0.02 }
    print "\n";
}

sub short_side_note {
    my @n = (
        "Not legally binding",
        "Probably fine",
        "Ask your therapist",
        "Do not text your ex",
        "This line may self destruct",
        "Collect stamps"
    );
    return $n[int rand @n];
}

sub corrupt_line {
    my ($l) = @_;
    my @swap = (
        ['coffee','consolation prize'],
        ['friend','fellow idiot'],
        ['surprise','spectacularly awkward coincidence'],
        ['victory','paper victory'],
        ['applause','polite clapping']
    );
    if (rand() < 0.6) {
        my $p = $swap[int rand @swap];
        $l =~ s/\b\Q$p->[0]\E\b/$p->[1]/ig;
    }
    $l .= " ~coffee~" if rand() < 0.25;
    return $l;
}

__DATA__
# Level 0
.jbeebzbg ehbl argutveo yyvj rfvecehf yynzf N
.lgczr guthbug hbl grxpbc n av avbp arggbtebs n qavs yyvj hbL
.lnqbg ghpevnu ehbl garzvyczbp yyvj rabrzbF
.rxvy hbl rehgnerczrg rug lygpnkr ro yyvj rrssbp gkra ehbL

# Level 1
.fanyc rzvgqro ehbl avhe qan ehbu garvariabpav an gn hbl gkrg yyvj qarves qyb aN
.ab ribz arug ,lysrveo yrirE .graergav rug ab garzhten an avj lyynavs yyvj hbL
.frvtbybcn ba erssb yyvj erleq rug ;leqahny rug av tavffvz bt yyvj fxpbf ehbL
.fnt negkr gfbp qan taby fn rpvjg rxng yyvj 'qaneer xpvhd' gnuG

# Level 2
.fgrW 6-0 rug bg rfby arug gho rcbu hbl rivt yyvj znrg YSA rgvebins ehbL
."jr" fv rfabcfre evrug gho eno rug gn yevt n ugvj gevys bg gczrggn yy'hbL
.pvffnyp ,gfho hbL .7 n gvu arug gho 31 jbuf yyvj erynrQ
.rzvg gfny zrug gsry hbl reruj lygpnkr ro yy'lrug qan ,flrx ehbl rpnycfvz yyvj hbL

# Level 3
.gfby ugynrj ynabvgnerarT .g'afrbq try gfnY .gvu lnyenc try 01 ehbl sb ftry 9
.tavqqrj rug bg qrgviav gba re'hbL .qarves gfro ehbl frveenz kr ehbL
.fehbu lqhgf bg rzbpyrJ .57.2 jbyro fcbeq NCT ebwnz ehbL
.hbl ugvj riby av gba fv erccvegf ruG
