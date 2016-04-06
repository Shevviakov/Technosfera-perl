package Local::Hackathon::Worker::Images;

use Mouse::Role;
use Mojo::DOM;
use DDP;

has '+source',       default => 'imgs';
has '+destination',  default => 'pic';


sub process {
	my $self = shift;
	my $task = shift;
	
	my $dom = Mojo::DOM->new($task->{HTML});
	$task->{image_links} = $dom->find('img[src]')->map(attr => 'src')->to_array;
	p $task->{image_links};
	#print "\n\nOLOLOOLOLOLO\n\n";
	return $task;
}

1;
