# OpenTripPlanner Docker for Northern Germany

## Requirements
- Docker is installed
- Internet Connection
- at least 16GB RAM available (24 preferred)

## Build container

`docker build -t otp-ngermany .`
This takes up to 15GB of RAM and lasts about 18 minutes.

## Run container

`docker run -p 8080:8080 otp-ngermany --router ngermany --server`
This takes up to 10GB of RAM and needs nearly 8 minutes to start.

Access OpenTripPlanner at `http://localhost:8080/`.

You can also run with the --analyst option to use OTP Analyst features, or run without any optional arguments to see all available command line options.

## Get it from DockerHub

`docker pull serge4nt/otp-ngermany:latest`


