package Local::App::Calc;

use Local::Calc;

use strict;

#Определение обрабатываемых сигналов
#$SIG{...} = \&...;

sub start_server {
	# На вход получаем порт который будет слушать сервер занимающийся расчетами примеров
	my $port = shift;
    
	# Создание сервера и обработка входящих соединений, форки не нужны 
	my $server = IO::Socket::INET->new(
		LocalAddr => 'localhost',
		LocalPort => $port,
		Type      => SOCK_STREAM,
		ReuseAddr => 1,
		Listen    => 10) 
	or die "Can't create server on port $port : $@ $/";
	
	# Входящее и исходящее сообщение: int 4 byte + string
	# На каждое подключение отдельный процесс. В рамках одного соединения может быть передано несколько примеров
}

sub calculate {
	my $ex = shift;
	# На вход получаем пример, который надо обработать, на выход возвращаем результат
	my $rpn = Local::Calc::rpn($ex);
	my $value = Local::Calc::evaluate($rpn);
	return $value;
}

1;
