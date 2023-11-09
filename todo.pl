use Dancer2;
use lib '/usr/src/myapp' ;
use planetscale ; #magic array_of_hash to quoted sql crud 
set template => 'mustache';

my $db = dbconnect() ;# planetscale:database=$ENV{DB_NAME},host=$ENV{DB_HOST},$ENV{DB_USERNAME},$ENV{DB_PASSWORD}  
sqldo( $db, {rows => ['CREATE TABLE IF NOT EXISTS todos (id int PRIMARY KEY AUTO_INCREMENT, task varchar(255), status varchar(16), user varchar(16), project varchar(16));']} ); 

get '/' => sub {
	send_file '/index.html' ;
};
any '/delete' => sub {
	my $q = request->params ;
	sqldelete( $db, { table=>'todos', key=>'id', rows=>[ $q ] } );
	template 'list' => {list => sqlquery( $db, { table=>'todos', columns=>['id','task'] } )}; 
} ;
any '/add' => sub {
	my $q = request->params ;
	sqlinsert( $db, { table=>'todos', rows=>[ $q ] } );
	template 'list' => {list => sqlquery( $db, { table=>'todos', columns=>['id','task'] } )}; 
};
any '/list' => sub {
	template 'list' => {list => sqlquery( $db, { table=>'todos', columns=>['id','task'] } )}; 
};
 
start;
