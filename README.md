CA
==

To secure communication over public networks we use a PKI.
Coordinator, MQTT broker and Web Dashboard use signed certificates for mutual authentication.
This allows adding coordinators and Dashboard clients without maintaining a list of allowed devices.

Four types of certificates will be generated:
* The CA's certificate. This certificate will need to be deployed at the broker and every coordinator and client, while the private key should be kept offline.
* The MQTT broker's certificate. This certificate and its according key file are needed on the MQTT broker so that it can authenticate to clients and coordinators.
* The coordinator's certificate. The coordinator will have its own certificate and key file which will be used to authenticate to the broker.
* The client's certificate. Each client will have its own certificate and key file to authenticate to the broker.

Configuration
-------------

* Install `make` and the `openssl` commandline utility.
* The broker's certificate needs to contain the broker's IP address or DNS name.
** This can be set in the `broker_req.cnf` file in the `broker_an` section.
** Add an `IP =` entry for an IP address or a `DNS =` entry for a DNS name.

Initializing the CA
-------------------

* Run `make ca`.
* All values except for the `Common Name` can be left at their defaults.
* Choose a common name.
* Set a password for the private key file.
* The private key will be in `ca.key`. This file should never leave your machine.
* The certificate will be in `ca.pem` and should be distributed to all clients and coordinators and the MQTT broker.

MQTT Broker Certificate
-----------------------

* Make sure the broker's public IP or DNS name are configured as described above.
* Run `make broker.crt/broker`.
* All values except for the `Common Name` can be left at their defaults.
* Choose a common name.
* The private key will be in `broker.key` and should be deployed on the MQTT broker.
* The certificate will be in `broker.crt` and should be deployed on the MQTT broker.

Coordinator Certificate
-----------------------

* Run `make coordinator.crt/coordinator`.
* All values except for the `Common Name` can be left at their defaults.
* Choose a common name.
* The private key will be in `coordinator.key` and should be deployed on the coordinator.
* The certificate will be in `coordinator.crt` and should be deployed on the coordinator.

Client Certificate
-----------------------

* Run `make dashboard.crt/dashboard`.
* All values except for the `Common Name` can be left at their defaults.
* Choose a common name.
* The private key will be in `dashboard.key` and should be deployed on the client.
* The certificate will be in `dashboard.crt` and should be deployed on the client.
