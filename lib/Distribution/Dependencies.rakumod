use JSON::Fast;

unit module Distribution::Dependencies;

    constant @excluded = <Test NativeCall>;
    sub explore($dir where .IO.d = ".") is export {
        with my $meta6-content = "$dir/META6.json".IO.slurp {
            my %dependencies;
            my $meta6 = from-json $meta6-content;
            for $meta6<provides>.values -> $p {
                my @lines = "$dir/$p".IO.lines.grep(/^^ \s* ["use" | "need"]/);
                for @lines -> $l {
                   $l ~~ / ["use" | "need" ] \s+ $<module> = (\S+) [";" | \s+] /;
                   my $module-name = ~$<module>;
                   next if $module-name ∈ @excluded
                           || $module-name ∈ $meta6<provides>.keys
                           || $module-name ~~ /^^v6/;
                   %dependencies{$module-name}++;
                }
            }
            %dependencies;
        } else {
            fail "Can't open $dir/META6.json";
        }
    }
