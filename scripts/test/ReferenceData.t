# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use strict;
use warnings;
use vars (qw($Self));
use utf8;

use Kernel::System::ReferenceData;
use Kernel::Config;

# create local object
my $ConfigObject = Kernel::Config->new();

# use ReferenceData ISO list
$ConfigObject->Set(
    Key   => 'ReferenceData::OwnCountryList',
    Value => undef,
);

my $ReferenceDataObject = Kernel::System::ReferenceData->new(
    %{ $Self, },
    ConfigObject => $ConfigObject,
);

# tests the method to make sure there are at least 100 countries
my $CountryList = $ReferenceDataObject->CountryList();

my $CountryListLength = scalar keys %$CountryList;

$Self->True(
    $CountryListLength > 100,
    "There are $CountryListLength countries registered",
);

# let's assume these countries don't go anywhere

my @CountryList = ( 'Netherlands', 'Germany', 'Switzerland', 'United States', 'Japan' );

for my $Country (@CountryList) {
    $Self->True(
        $$CountryList{$Country},
        "Testing existence of country ($Country)",
    );
}

# set configuration to small list

$ConfigObject->Set(
    Key   => 'ReferenceData::OwnCountryList',
    Value => {
        'FR' => 'France',
        'NL' => 'Netherlands',
        'DE' => 'Germany'
    },
);

$CountryList = $ReferenceDataObject->CountryList();

@CountryList = ( 'Switzerland', 'United States', 'Japan' );

for my $Country (@CountryList) {
    $Self->False(
        $$CountryList{$Country},
        "OwnCountryList: Testing non-existence of country ($Country)",
    );
}

@CountryList = ( 'France', 'Netherlands', 'Germany' );

for my $Country (@CountryList) {
    $Self->True(
        $$CountryList{$Country},
        "OwnCountryList: Testing existence of country ($Country)",
    );
}

1;
