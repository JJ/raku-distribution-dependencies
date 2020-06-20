use JSON::Fast;

role Custom-Repo {
    has %.distros;
    method need(CompUnit::DependencySpecification $spec,
                CompUnit::PrecompilationRepository $precomp = self.precomp-repository()
            --> CompUnit:D
                )
    {
        say $spec;
        %!distros{$spec.short-name}++;
        return self.next-repo.need($spec, $precomp) if self.next-repo;
    }
}

BEGIN {
    $*REPO does Custom-Repo;
}

module Distribution::Dependencies {
    sub explore($dir where .IO.d = ".") {
        with my $meta6-content = "$dir/META6.json".IO.slurp {
            my $meta6 = from-json $meta6-content;
            for $meta6<provides> -> $p {
                my @lines = "$dir/{ $p.value }".lines
                .grep(/^^ \s* "use" | "need"/);
                say @lines;
            }
        } else {
            fail "Can't open $dir/META6.json";
        }
    }
}