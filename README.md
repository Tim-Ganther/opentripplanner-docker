# OpenTripPlanner Docker for Berlin/Brandenburg

## Build container

`docker build -t opentripplanner-brb .`

## Run container

`docker run -p 80:8080 opentripplanner-brb --router brandenburg --server`

Access OpenTripPlanner at `http://localhost:80/`.

You can also run with the --analyst option to use OTP Analyst features, or run without any optional arguments to see all available command line options.
