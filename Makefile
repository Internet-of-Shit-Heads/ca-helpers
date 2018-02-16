ca.key ca.pem: ca.cnf
	openssl req -newkey rsa:4096 -sha512 -config ca.cnf -extensions v3_ca -keyout ca.key -out ca.pem -x509

.capair: ca.key/4096 ca.pem

db/index.txt:
	mkdir -p db
	touch db/index.txt

db/ca.srl:
	mkdir -p db
	echo 00 > db/ca.srl

certs:
	mkdir -p certs

.cadb: certs db/index.txt db/ca.srl

ca: .capair .cadb

.PRECIOUS: db/index.txt db/ca.srl ca.pem %.key %.crt %.csr %.key.der %.crt.der

%.key.der: %.key
	openssl rsa -in $< -outform DER -out $@

%.crt.der: %.crt
	openssl x509 -in $< -outform DER -out $@

%.der: %.pem
	openssl x509 -in $< -outform DER -out $@

KEYSIZE=2048
%.key:
	openssl genrsa -out $@ $(KEYSIZE)

%.key/1536: KEYSIZE=1536
%.key/1536: %.key
	@echo -n

%.key/2048: KEYSIZE=2048
%.key/2048: %.key
	@echo -n

%.key/4096: KEYSIZE=4096
%.key/4096: %.key
	@echo -n

%/dashboard: CERT_EXTENSION=dashboard_ext
%/dashboard: REQUEST_CONFIG=dashboard_req.cnf
%/dashboard: %
	@echo -n

%/coordinator: CERT_EXTENSION=coordinator_ext
%/coordinator: REQUEST_CONFIG=coordinator_req.cnf
%/coordinator: KEYSIZE=1536
%/coordinator: %
	@echo -n

%/broker: CERT_EXTENSION=broker_ext
%/broker: REQUEST_CONFIG=broker_req.cnf
%/broker: %
	@echo -n

CERT_EXTENSION=dashboard_ext
%.crt: %.csr | ca
	openssl ca -config ca.cnf -md sha512 -notext -in $< -extensions $(CERT_EXTENSION) -days 365 -out $@

REQUEST_CONFIG=dashboard_req.cnf
%.csr: %.key
	openssl req -new -sha512 -key $< -out $@ -days 365 -config $(REQUEST_CONFIG)

clean-ca:
	rm -rf certs db ca.pem ca.key ca.der

clean-crt:
	rm -rf *.crt
	rm -rf *.crt.der

clean-csr:
	rm -rf *.csr

clean-key:
	rm -rf *.key
	rm -rf *.key.der

clean: clean-csr

purge: clean clean-ca clean-crt clean-key

.PHONY: .capair .cadb ca clean-ca clean-crt clean-csr clean-key clean
