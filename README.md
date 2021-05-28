# Intial Setup

    docker-compose build
    docker-compose up mariadb
    # Once mariadb says it's ready for connections, you can use ctrl + c to stop it
    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml build

# To run migrations

    docker-compose run short-app rails db:migrate
    docker-compose -f docker-compose-test.yml run short-app-rspec rails db:test:prepare

# To run the specs

    docker-compose -f docker-compose-test.yml run short-app-rspec

# Run the web server

    docker-compose up

# Adding a URL

    curl -X POST -d "full_url=https://google.com" http://localhost:3000/short_urls.json

# Getting the top 100

    curl localhost:3000

# Checking your short URL redirect

    curl -I localhost:3000/abc

# Features a bitjective function to convert ID to a ShortUrl

    Bitjective functions are a type of function that work in both directions.
    i.e. f(a) = 1 & f(1) = a
    
    An in-depth explanation of how exactly bitjective functions operate may be found here: https://stackoverflow.com/questions/742013/how-do-i-create-a-url-shortener/742047#742047