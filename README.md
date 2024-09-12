# README

# Point Tracker Server

## Setup Instructions

### A Note on Line Endings
Clrf (Windows style) line endings can cause issue for some of the server's scripts. Be sure to use lf when cloning this repo.
Here is a link to a Stack Overflow topic concerning this issue: [Git replacing LF with CRLF](https://stackoverflow.com/questions/1967370/git-replacing-lf-with-crlf)

### Instructions

1. Clone the repository.
1. Create a postgres database.
1. Set the database tcp_keepalives_idle to 200.
1. Create a .env file at the root of the project. Example:
```

SERVER_DOMAIN=<domain url of server>

# Rails
RAILS_ENV=<development or production>
PORT=<server port>
RAILS_MASTER_KEY=<128 bit hexadecimal key>
SECRET_KEY_BASE=<SHA-512 hash>

# User database
DB_USERNAME=<db username>
DB_PASSWORD=<db password>
DB_ENDPOINT=<db endpoint>
DB_PORT=<db port>
DB_NAME=<db name>

# Points database
POINTS_DB_USERNAME=<db username>
POINTS_DB_PASSWORD=<db password>
POINTS_DB_ENDPOINT=<db endpoint>
POINTS_DB_PORT=<db port>
POINTS_DB_NAME=<db name>

# Server email (Your email provider must also be configured in order for the server to send from this address)
MAILER_USERNAME=<example@example.com>
MAILER_PASSWORD=<email password>

```
1. To build the image, run `docker compose build`
1. To run in development with docker volumes, run `docker compose up`

