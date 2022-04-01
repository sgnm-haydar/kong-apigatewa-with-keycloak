docker-compose build kong
docker-compose up -d kong-db
docker-compose run --rm kong kong migrations bootstrap
docker-compose run --rm kong kong migrations up
docker-compose up -d kong
docker-compose up -d konga
docker-compose ps

#connect oidc driver to kong
#curl -s -X POST http://localhost:8001/plugins \-d name=oidc \-d config.client_id=ifm_facility_client \-d config.client_secret=cBh97xovn2wC70DbnZfupiH4t1vQoDrU \-d config.bearer_only=yes \-d config.introspection_endpoint=http://172.19.100.120:8080/auth/realms/ifm/protocol/openid-connect/token/introspect \-d config.discovery=http://172.19.100.120:8080/auth/realms/ifm/.well-known/openid-configuration \ | python3 -mjson.tool
#create service called facilityHistory
curl -s -X POST http://localhost:8001/services -d name=facility -d url=http://172.18.2.55:3001/ | python3 -mjson.tool
#create route (endpoint for gateway) called facilityHistory
curl -s -X POST http://localhost:8001/services/facility/routes -d paths[]=/facility | python3 -mjson.tool