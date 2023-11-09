# todoapp
to do app with HTMX, Perl Dancer2 and planetscale 

    #run local
    git clone https://github.com/ktown007/todoapp.git
    cd todoapp
    #get .env from planetscale
    cp ../.env .
    export $(grep -v '^#' .env | xargs)
    perl todo.pl

    
open http:://localhost:3000

    #run on docker
    sudo docker build -t todoappimg .
    sudo docker run -d --name todoapp1 --env-file .env -p 3000:3000 todoappimg

    #run on fly.io
    fly secrets set $(grep -v '^#' .env | xargs)
    fly launch

see tutorial here: [naughtylist](/ktown007/todoapp/blob/main/naughty.md)
