# Use latest or what you need version of Swift docker container
FROM swift:latest

# Install packages needed by Perfect
RUN apt-get update && DEBIAN_FRONTEND=noninteractive 
RUN apt-get install -y --no-install-recommends apt-utils
RUN apt-get install -y openssl libssl-dev uuid-dev software-properties-common

# cURL usado na biblioteca PerfectCURL
RUN apt-get install -y libcurl4-openssl-dev

# conector do MySQL
RUN apt-get install -y libmysqlclient-dev

# conector do SQLite
# RUN apt-get install -y sqlite3
# RUN apt-get install -y libsqlite3-dev

# conector do PostgreSQL
# RUN apt-get install -y libpq-dev
