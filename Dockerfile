FROM ubuntu
RUN apt-get update
RUN apt-get install -y mysql-client default-libmysqlclient-dev libdancer2-perl libdbd-mysql-perl cpanminus libtest-taint-perl libtest-www-mechanize-psgi-perl liblist-allutils-perl  build-essential vim libmoose-perl libtest-requires-perl libtest2-suite-perl libmoosex-mungehas-perl libparse-recdescent-perl
RUN cpanm Dancer2::Template::Mustache 
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
EXPOSE 3000
CMD [ "perl", "./todo.pl" ]
