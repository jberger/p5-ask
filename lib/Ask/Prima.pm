use 5.010;
use strict;
use warnings;

package Ask::Prima;

use Moo;
use namespace::sweep;

use Prima;
use Prima::Application;
use Prima::MsgBox;

with 'Ask::API';

sub quality {
  return 90;
}

sub entry {
  my ($self, %o) = @_;
  input_box( $o{title}, $o{text}, '');
}

sub info {
  my ($self, %o) = @_;
  $o{title} //= 'Information';
  $o{message_type} //= mb::Information;
  message_box( $o{title}, $o{text}, mb::Ok|$o{message_type});
}

sub warning {
  my ($self, %o) = @_;
  $o{title} //= 'Warning';   #/# highlight fix
  $o{message_type} ||= mb::Warning;
  $self->info(%o);
}

sub error {
  my ($self, %o) = @_;
  $o{title} //= 'Error';   #/# highlight fix
  $o{message_type} ||= mb::Error;
  $self->info(%o);
}

sub file_selection {
  my ($self, %o) = @_;
  require Prima::FileDialog;
  return $o{directory}
    ? $self->_dir_selection(\%o)
    : $self->_file_selection(\%o);
}

sub _file_selection {
  my ($self, $o) = @_;
  my $open = Prima::OpenDialog->new(
    multiSelect => $o->{multiple},
  );
  return $open->fileName if $open->execute;
}

sub _dir_selection {
  my ($self, $o) = @_;
  $o->{text} //= 'Select a directory';   #/# highlight fix
  my $open = Prima::ChDirDialog->new(
    text => $o->{text},
  );
  my $res = $open->execute;
  return unless $res and $res & mb::Ok;
  return $open->directory;
}

sub question {
  my ($self, %o) = @_;

  my %profile;
  $profile{buttons}{mb::Yes}{text} = $o{ok_label} 
    if defined $o{ok_label};
  $profile{buttons}{mb::No}{text} = $o{cancel_label} 
    if defined $o{cancel_label};

  $o{title} //= 'Question';   #/# highlight fix

  my $res = message( $o{text}, mb::YesNo|mb::Question , %profile);
  return 1 if $res & mb::Yes;
  return;
}

1;

