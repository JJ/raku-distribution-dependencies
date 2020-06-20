use Test;

use Distribution::Dependencies;

my %result = explore;
is %result<JSON::Fast>, 1, "Auto-exploration works";

done-testing;
