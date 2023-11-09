# todoapp
to do app with HTMX, Perl Dancer2 and planetscale 


    git clone https://github.com/ktown007/todoapp.git
    cd todoapp
    #get .env from planetscale
    cp ../.env .
    export $(grep -v '^#' .env | xargs)
    #fly secrets set $(grep -v '^#' .env | xargs)
    sudo docker build -t todoappimg .
    sudo docker run -d --name todoapp1 --env-file .env -p 3000:3000 todoappimg
    
open http:://localhost:3000
