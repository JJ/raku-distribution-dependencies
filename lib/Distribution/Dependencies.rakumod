use JSON::Fast;

unit module Distribution::Dependencies;

    sub explore($dir where .IO.d = ".") is export {
        with my $meta6-content = "$dir/META6.json".IO.slurp {
            my $meta6 = from-json $meta6-content;
            for $meta6<provides>.values -> $p {
                my @lines = "$dir/$p".IO.lines.grep(/^^ \s* ["use" | "need"]/);
                my $script = %?RESOURCES<explorer.p6>
                        ?? %?RESOURCES<explorer.p6>.relative !!
                        "resources/explorer.p6";
                note $*EXECUTABLE;
                my $output = shell "$*EXECUTABLE $script" ~  ' "' ~
                        @lines.join("; ") ~
'"', :out;
                my $result = $output.out.slurp: :close;
                return from-json $result;
            }
        } else {
            fail "Can't open $dir/META6.json";
        }
    }
