docker-compose build kong
docker-compose up -d kong-db
docker-compose run --rm kong kong migrations bootstrap
docker-compose run --rm kong kong migrations up
docker-compose up -d kong
docker-compose up -d konga
docker-compose ps

#connect oidc driver to kong
curl -s -X POST http://localhost:8001/plugins \-d name=oidc \-d config.client_id=ifm_facility_client \-d config.client_secret=cBh97xovn2wC70DbnZfupiH4t1vQoDrU \-d config.bearer_only=yes \-d config.introspection_endpoint=http://172.19.100.120:8080/auth/realms/ifm/protocol/openid-connect/token/introspect \-d config.discovery=http://172.19.100.120:8080/auth/realms/ifm/.well-known/openid-configuration \ | python3 -mjson.tool

#create service called facility
curl -s -X POST http://localhost:8001/services -d name=facility -d url=http://10.250.2.72:3001/ | python3 -mjson.tool

#create service called user
curl -s -X POST http://localhost:8001/services -d name=user -d url=http://10.250.2.72:3002/ | python3 -mjson.tool

#create route (endpoint for gateway) called facility
curl -s -X POST http://localhost:8001/services/facility/routes -d paths[]=/facility | python3 -mjson.tool

#create route (endpoint for gateway) called facility
curl -s -X POST http://localhost:8001/services/user/routes -d paths[]=/user | python3 -mjson.tool

 
