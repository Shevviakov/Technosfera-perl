package Local::App::GenCalc;

use strict;
use warnings;
use Time::HiRes qw/alarm/;
use IO::Socket;

my $file_path = './calcs.txt';
our $server;

sub new_one {
    # Функция вызывается по таймеру каждые 100
    my $new_row = join $/, int(rand(5)).' + '.int(rand(5)), 
                  int(rand(2)).' + '.int(rand(5)).' * '.int(int(rand(10))), 
                  '('.int(rand(10)).' + '.int(rand(8)).') * '.int(rand(7)), 
                  int(rand(5)).' + '.int(rand(6)).' * '.int(rand(8)).' ^ '.int(rand(12)), 
                  int(rand(20)).' + '.int(rand(40)).' * '.int(rand(45)).' ^ '.int(rand(12)), 
                  (int(rand(12))/(int(rand(17))+1)).' * ('.(int(rand(14))/(int(rand(30))+1)).' - '.int(rand(10)).') / '.rand(10).'.0 ^ 0.'.int(rand(6)),  
                  int(rand(8)).' + 0.'.int(rand(10)), 
                  int(rand(10)).' + .5',
                  int(rand(10)).' + .5e0',
                  int(rand(10)).' + .5e1',
                  int(rand(10)).' + .5e+1', 
                  int(rand(10)).' + .5e-1', 
                  int(rand(10)).' + .5e+1 * 2';
    # Далее происходить запись в файл очередь
	open (my $fh, '>>', $file_path) or die "Can't open '$file_path' to append: $!";
	if (-s $file_path <= 10000000) {syswrite( $fh, $new_row, length($new_row));}
	close ($fh);

    return;
}

#Определение обрабатываемых сигналов
$SIG{ALRM} = sub {
	new_one();
	alarm(0.1);
};

$SIG{INT} = sub {
	unlink $file_path;
	exit 0;	
};

sub start_server {
	# На вход приходит номер порта который будет слушат сервер для обработки запросов на получение данных
	my $port = shift;
	# Создание сервера и обработка входящих соединений, форки не нужны 
	
        my $server = IO::Socket::INET->new(
                LocalAddr => 'localhost',
                LocalPort => $port,
                Type      => SOCK_STREAM,
                ReuseAddr => 1,
                Listen    => 1)
        or die "Can't create server on port $port : $@ $/";

        alarm (0.1);
        while(1) {
	        while(my $client = $server->accept()){
        	        print "accepted\n";
			alarm(0);
			my $msg_len;
			
			# Входящее сообщение это 2-х байтовый инт (кол-во сообщений которое надо отдать в ответ)
			if (sysread($client, $msg_len, 2) == 2){
				my $limit = unpack 'S', $msg_len;
				my $ex = Local::App::GenCalc::get($limit);
				
				# Исходящее сообщение: ROWS_CNT ROW; ROW := ROW [ROW]; ROW := LEN MESS; LEN - 4-х байтовый инт; MESS - сообщение указанной длины
				syswrite($client, pack('L', scalar($ex)), 4);
				while (@$ex) {
					syswrite($client, pack('w/a*', $_));

				}
			}
			close( $client );
			alarm(0.1);
		}
	}
}

sub get {
	# На вход получаем кол-во запрашиваемых сообщений
	my $limit = shift;
	
	# Открытие файла, чтение N записей
	new_one() unless (-e $file_path);
	open (my $fh, '<', $file_path) or die "Can't open '$file_path' to read: $!";
	my @file = <$fh>;
	close($fh);

	# Надо предусмотреть, что файла может не быть, а так же в файле может быть меньше сообщений чем запрошено
	while (@file <= $limit) {
		new_one();
		open (my $fh, '<', $file_path) or die "Can't open '$file_path' to read: $!"; 
		my @new_list = <$fh>;
		close($fh);
		push @file, @new_list;
	}
	
	#Записываем остаток в файл
	open ($fh, '>', $file_path) or die "Can't open '$file_path' to append: $!";
	print $fh, (join $/, @file[$limit..$#file]);
	my @ret = @file[0..($limit-1)]; # Возвращаем ссылку на массив строк
	
	return \@ret;
}

1;
