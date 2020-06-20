#!/usr/bin/env raku

use MONKEY-SEE-NO-EVAL;
use JSON::Fast;

role Custom-Repo {
    has %.distros;
    method need(CompUnit::DependencySpecification $spec,
                CompUnit::PrecompilationRepository $precomp = self.precomp-repository()
            --> CompUnit:D
                )
    {
        %!distros{$spec.short-name}++;
        return self.next-repo.need($spec, $precomp) if self.next-repo;
    }
}

BEGIN {
    $*REPO does Custom-Repo;
}

@*ARGS[0].EVAL(:check);

say to-json $*REPO.distros;