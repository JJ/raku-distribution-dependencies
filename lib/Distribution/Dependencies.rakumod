use JSON::Fast;

unit module Distribution::Dependencies;

    constant @excluded = <Test NativeCall v6.c v6.d>;
    sub explore($dir where .IO.d = ".") is export {
        with my $meta6-content = "$dir/META6.json".IO.slurp {
            my %dependencies;
            my $meta6 = from-json $meta6-content;
            for $meta6<provides>.values -> $p {
                my @lines = "$dir/$p".IO.lines.grep(/^^ \s* ["use" | "need"]/);
                for @lines -> $l {
                   $l ~~ / ["use" | "need" ] \s+ $<module> = (\S+) ";" /;
                   %dependencies{~$<module>}++ unless ~$<module> ∈ @excluded;
                }
            }
            %dependencies;
        } else {
            fail "Can't open $dir/META6.json";
        }
    }
