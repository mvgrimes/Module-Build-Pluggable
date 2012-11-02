package Module::Build::Pluggable::PPPort;
use strict;
use warnings;
use utf8;
use parent qw/Module::Build::Pluggable::Base/;
use Class::Accessor::Lite (
    ro => [qw/version filename/],
);

our $VERSION = '0.01';

sub HOOK_configure {
    my ($self) = @_;
    my $version = $self->version || '3.19';
    $self->build_requires('Devel::PPPort' => $version);
    $self->configure_requires('Devel::PPPort' => $version);
}

sub HOOK_build {
    my ($self, $builder) = @_;
    require Devel::PPPort;
    my $filename = $self->filename || 'ppport.h';
    $self->add_before_action_modifier('build', sub {
        my $self = shift;
        $self->depends_on('ppport_h');
    });
    $self->add_action('ppport_h', sub {
        my $self = shift;
        unless (-e $filename) {
            $self->log_info("Writing $filename\n");
            Devel::PPPort::WriteFile($filename);
        }
        $self->add_to_cleanup($filename);
    });
}

1;

