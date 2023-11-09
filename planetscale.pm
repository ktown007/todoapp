package planetscale;

use Exporter ;
@ISA = ('Exporter')  ;
@EXPORT = qw(&to_json &from_json &jsontidy &version &sqlinsert &sqlupdate &apipost &sqldelete &sqlquery &sqldo &dbconnect ) ;

use utf8 ;
use HTTP::Tiny ;
use JSON;
use DBI ;
use common::sense ;

use feature(qw(signatures)) ;
no warnings qw(experimental::signatures) ;
require feature;
feature->import (qw(say fc state signatures));
warnings->unimport( qw(experimental::signatures ));

sub version {
	return '2023-10-31' ; #boo
}
sub jsontidy( $data ) {
	if( ref($data) ) {
		return to_json( $data , {pretty=>1 , indent=>2} ) ;
	}
	my $r = from_json( $data) ;
	return to_json( $r , {pretty=>1 , indent=>2} ) ;
}
sub dbconnect {
	my $dsn = "DBI:mysql:database=$ENV{DB_NAME};host=$ENV{DB_HOST};mysql_ssl=1;mysql_ssl_verify_server_cert=1;mysql_ssl_ca_file=/etc/ssl/certs/ca-certificates.crt";
	return DBI->connect($dsn, $ENV{DB_USERNAME}, $ENV{DB_PASSWORD}, {mysql_auto_reconnect => 1});
}
sub sqlquery( $dbh, $data ) { #table  optional: columns where key rows[0] 
	$dbh //= dbconnect() ;
	my ( $statement , @res , $sth , @where, @wherevalues);
	my $cols = $data->{columns} ? "`".join("`,`",@{$data->{columns}})."`" : "*" ;
	if( $data->{where} ) {
		foreach my $key ( keys %{$data->{where}} ) {
			push @where , "`$key` = ? ";
			push @wherevalues , $data->{where}{$key} ;
		}
		$statement = "SELECT $cols FROM `$data->{table}` where " .join(" and ", @where);
		$sth = $dbh->prepare( $statement ) ;
		$sth->execute( @wherevalues ) ;
	} elsif ( $data->{rows}[0]{ $data->{key} } ) { # this could be done with where, maybe change to "in" for all rows
		$statement = "SELECT $cols FROM `$data->{table}` where `$data->{key}` = ?";
		$sth = $dbh->prepare( $statement ) ;
		$sth->execute( $data->{rows}[0]{ $data->{key} } ) ;
	} else {
		$statement = "SELECT $cols FROM `$data->{table}`" ;
		$sth = $dbh->prepare( $statement) ;
		$sth->execute() ;
	}
	while (my $ref = $sth->fetchrow_hashref()) {
		push @res, $ref ;
	}
	$sth->finish;
	return \@res ;
}
sub sqlinsert( $dbh, $data ) { # table rows
	$dbh //= dbconnect() ;
	my ( @res );
	foreach my $row ( @{$data->{rows}}) {
		my ( @fields, @values , @ph );
		foreach my $field ( keys %{$data->{rows}[0]} ) {
			push @fields, "`$field`";
			push @ph, "?";
			push @values, $row->{$field};
		}
		my $statement = "INSERT INTO `$data->{table}` (". join(",", @fields) .") VALUES(".join(",",@ph).")";
		my $rv = $dbh->do($statement , undef, @values ) ;
		push @res, $dbh->{'mysql_insertid'} ;
	}
	return \@res ;
}
sub sqlupdate( $dbh, $data ) { # table key rows where
	$dbh //= dbconnect() ;
	my ( @res );
	foreach my $row ( @{$data->{rows}}) {
		my( @set, @values )  ;
		foreach my $field (keys %{$row} ) {
			if( $data->{key} ne $field ){
				push @set, "`$field` = ? ";
				push @values , $row->{$field} ;
			}
		}
		my $statement = "UPDATE `$data->{table}` SET ". join(", ", @set) ." WHERE `$data->{key}` = ? " ;
		my $rv = $dbh->do( $statement , undef, @values , $row->{ $data->{key} }  ) ;
		push @res , $rv ;
	}
	return \@res ;
}
sub sqldelete( $dbh, $data ) { #table key rows
	$dbh //= dbconnect() ;
	my ( @res );
	foreach my $row ( @{$data->{rows}}) {
		my $statement = "DELETE FROM `$data->{table}` WHERE `$data->{key}` = ?" ;
		my $rv = $dbh->do($statement , undef, $row->{ $data->{key} } ) ;
		push @res , $rv ;
	}
	return \@res ;
}
sub sqldo( $dbh, $data ){ #rows = sql
	$dbh //= dbconnect() ;
	my ( @res );
	foreach my $sql ( @{$data->{rows}}) {
		my $rv = $dbh->do( $sql ) ;
		push @res , $rv ;
	}
	return \@res ;
}
sub apipost( $url , $jsondata, $headers ) {
	my $tiny = HTTP::Tiny->new( verify_SSL=>1, agent => 'foo', timeout => 200 );
	$headers->{'Content-Type'} = 'application/json' ;
	my $resp = $tiny->request('POST', $url, {headers => $headers , content => to_json($jsondata) });
	return ($resp->{'status'}, from_json($resp->{'content'}) );
}

1;
