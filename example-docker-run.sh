docker run -e DATABASE_URL="postgres://$DB_USERNAME:$DB_PASSWORD@$DB_ENDPOINT:$DB_PORT/$DB_NAME" -e RAILS_ENV="$RAILS_ENV" -p $PORT:3000 my-rails-image
