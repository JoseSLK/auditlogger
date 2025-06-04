
build:
	-docker stop audit_server
	-docker rm audit_server
	docker build -t auditlogger .

run:
	docker run -p 5000:22 --name audit_server --hostname audit_server -d auditlogger
	docker exec -it audit_server bash