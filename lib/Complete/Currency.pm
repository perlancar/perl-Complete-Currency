package Complete::Currency;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Complete::Common qw(:all);

our %SPEC;
use Exporter 'import';
our @EXPORT_OK = qw(complete_currency_code);

$SPEC{complete_currency_code} = {
    v => 1.1,
    summary => 'Complete from list of ISO-4217 currency codes',
    args => {
        word => {
            schema => 'str*',
            req => 1,
            pos => 0,
        },
    },
    result_naked => 1,
};
sub complete_currency_code {
    require Complete::Util;

    state $codes = do {
        require Locale::Codes::Currency_Codes;
        my $codes = {};
        my $id2names = $Locale::Codes::Data{'currency'}{'id2names'};
        my $id2alpha = $Locale::Codes::Data{'currency'}{'id2code'}{'alpha'};

        for my $id (keys %$id2names) {
            if (my $c = $id2alpha->{$id}) {
                $codes->{'alpha'}{$c} = $id2names->{$id}[0];
            }
        }
        $codes;
    };

    my %args = @_;
    my $word = $args{word} // '';
    my $hash = $codes->{alpha};
    return [] unless $hash;

    Complete::Util::complete_hash_key(
        word  => $word,
        hash  => $hash,
        summaries_from_hash_values => 1,
    );
}

1;
#ABSTRACT:

=head1 SYNOPSIS

 use Complete::Currency qw(complete_currency_code);
 my $res = complete_currency_code(word => 'V');
 # -> [qw/VEF VND VUV/]


=head1 SEE ALSO

L<Complete::Country>

L<Complete::Language>
