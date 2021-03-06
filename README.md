# CENtree Install and Run Guide
Use this guide to help you run a full standalone version of CENtree from the same server or computer.

For other advanced topics, including **updating CENtree**, please check the [wiki](https://github.com/SciBiteLtd/centree-devops/wiki). Note: Changes made to the application configuration file will require a restart of the server to apply them.

## Minimum Requirements

* Docker engine
* Docker compose
* Valid Scibite CENtree license
* Dockerhub user with access to [CENtree dockerhub repository] (access will be granted by SciBite on valid licence)

You will need docker and docker-compose installed in your server/computer. This version has being
tested with docker ([installing docker]) **19.03.4-ce** 
and docker compose ([installing docker compose]) **1.24.1**. But is very likely it will work 
also with older/newer versions.

You also need a valid CENTree license. Please replace the example [license](docker/data/license/centree_licence.xml.sample)
with the one we provide you into that same location. If not, the server will refuse to start.

Your server requires a minimum of 16GB of ram. If you only have 8GB at your disposal, you may
still run CENtree, but you will need to lower the available memory for CENtree on the 
[Application configuration] file

```yaml
      - _JAVA_OPTIONS=-Xmx5g
```

You will not be able to load the biggest ontologies, but that would be all. Please refer to the CENtree user manual for minimum/recommended server requirements.

You will also need to have a dockerhub user that has access to 
[CENtree dockerhub repository]. If not, you will not be able to pull the docker containers 
images needed to run CENtree.

## Installing and Starting CENtree

Clone or download the docker file (above) which contains the start and stop scripts, the yml config and license folder:

https://github.com/SciBiteLtd/centree-devops/tree/master/docker



Ensure you are logged into Docker:

```
docker login
```

If you have not previously saved credentials it will prompt for your username and password. Use the same account that has access to the CENtree Dockerhub which you have previously sent to SciBite.

If both requirements are satisfied (docker compose and access to 
[CENtree dockerhub repository]) you just need to run the following command: 

```
cd docker
./start-centree.sh
```

Depending on your environment and how you install docker, you may need to run as **sudo**. The script will first pull the **latest image** (no action is taken if you already have the latest release image downloaded), then initiate the platform to start. If you want to pull a specific verson of CENtree and not the latest release please use a named version - see the **[updating CENtree wiki page](https://github.com/SciBiteLtd/centree-devops/wiki/Updating-CENtree)** 

To check if everything went well, run:

```
./show-logs.sh
```

And you should get a similar output as this at the end:

```
15:42:46.306+0000 INFO  [main] OntologyManagerApp: Started OntologyManagerApp in 30.441 seconds (JVM running for 32.011)
15:42:46.314+0000 INFO  [main] OntologyManagerApp: 
----------------------------------------------------------
	Application 'OntologyManager' is running! Access URLs:
	Local: 		https://localhost:8443/
	External: 	https://192.168.48.2:8443/
	Profile(s): 	[prod, swagger]
----------------------------------------------------------

```

If you can see this output, you should be able now to access your server at https://localhost:8443/ 
if you are running the service locally.

## (Optional) Mail configuration
If you want to make use of the email outgoing service, you will need to provide the following necessary properties editing
the [Application configuration] file:

```
      - JHIPSTER_MAIL_FROM=Centree@centree.scibite.io 
      - JHIPSTER_MAIL_BASE_URL=https://centree.scibite.io
      - SPRING_MAIL_HOST=email-smtp.eu-west-1.amazonaws.com
      - SPRING_MAIL_PORT=587
      - SPRING_MAIL_USERNAME=REPLACE_WITH_USERNAME
      - SPRING_MAIL_PASSWORD=REPLACE_WITH_PASSWORD
      
```
In this example, amazon mail service is used, but you can use whatever smtp server you prefer.
Make sure you change the base url to match a public address that a person receiving an email is able to access your Centree
instance, so he can be able to open any links that gets into his email (Ex. password resets)

## (Mandatory) Specifying a secret to generate web tokens

You have to provide a secret to that will be used to generate and validate the JWT used for authentication and authorization of users. Use the same secret if you want users to be able to authenticate against multiple instances or a different one if not. Provide the following property to the [Application configuration] file:

```
 	- JHIPSTER_SECURITY_AUTHENTICATION_JWT_BASE64_SECRET=SCIbitelihuOouyljb23eljbljwbhf98hiluLJBHoIUH9RzoGog8YG82630J04ldIjeH

```
You can generate a random secrect with the command:

```
    openssl rand -base64 64
```

The server will require restarting to use this specified secret if it has already been started. One (possibly desired) consequence of this to be aware of: if you change secrets at any point in a server that has been running and has active users, the existing JWTs generated will no longer be valid and will require regenerating by the users concerned. For more details on specifying a key (including length) see: https://www.jhipster.tech/security/#jwt


## (Optional) SSL/TLS configuration

By default, CENtree comes with a self-signed certificate, which can lead to browser warnings and a "Not secure" warning in the URL bar. To remove this, an SSL certificate should be generated, and then CENtree should be configured to use it.

You will need to create a suitable SSL certificate, or request one from whoever is responsible for such things in your organisation. The certificate shoud be in PKCS12 format (the extension will be `.p12` or `.pfx`) 

Once you have the certificate put it in `centree-devops/docker/data/ssl` and take note of the name (here `cert.p12`), then edit the [Application Configuration] file as follows; note paths are relative to the directory in which the [Application configuration] file is stored:

SSS/TLS is enabled by default. A generated self signed certificate is included on centree by default. You can leave it as it is, override it with a certificate of your own or disable ssl/tls if you so desire it.

To disable ssl/tls, change the server profile to **no-tls**:

```
    - SPRING_PROFILES_ACTIVE=no-tls,swagger
```

Once the server has started, you should see something similar to this on the logs:

```
11:01:58.046+0000 INFO  [main] OntologyManagerApp: Started OntologyManagerApp in 12.906 seconds (JVM running for 13.448)
11:01:58.051+0000 INFO  [main] OntologyManagerApp: 
----------------------------------------------------------
        Application 'OntologyManager' is running! Access URLs:
        Local:          http://localhost:8443/
        External:       http://172.25.0.3:8443/
        Profile(s):     [no-tls,swagger]
----------------------------------------------------------

```
As you can see, the port is now http instead of https.

You can override the default self signed certificate with your own, please uncomment the ssl properties editing
the [Application configuration] file and it should look something like this:

```
      # Uncomment the next lines if you want to override the self signed certificate with your own
      - SERVER_SSL_KEY_STORE=/var/lib/app/data/ssl/cert.p12
      - SERVER_SSL_KEY_STORE_TYPE=PKCS12
      - SERVER_SSL_KEY_ALIAS=ontologymanager
      - SERVER_SSL_KEY_STORE_PASSWORD=changeme
    volumes:
      - ontologymanager-app:/var/lib/app/data/
      - ./data/license/:/var/lib/app/data/license/
      # You will need to provide a volume that stores your certificate if ssl is overriden
      - ./data/ssl/:/var/lib/app/data/ssl/
      
```

The `SERVER_SSL_KEY_ALIAS` will need to be set to the alias or "friendly name" of the certificate. If you don't know this intially it can be obtained using one of the two following commands; note that `keytool` is part of the JDK:

```
keytool -list -keystore data/ssl/cert.p12 

or 

openssl pkcs12 -info -in cert.p12
```

## (Optional) File upload limits configuration

By default, CENtree specifies file upload requests at 510MB. To override this to a higher (or lower) value the following can be added to the  [Application configuration] file:

```
      - SPRING_SERVLET_MULTIPART_MAX_FILE_SIZE=800MB
      - SPRING_SERVLET_MULTIPART_MAX_REQUEST_SIZE=1024MB
```

The max file size restricts the file size allowed to be sent to CENtree when uploading an ontology file. The request is the overall request size (including any attached files). If the file size is larger than either of these limits it will be rejected. 

[installing docker]: https://docs.docker.com/install/
[installing docker compose]: https://docs.docker.com/compose/install/
[CENtree dockerhub repository]: https://hub.docker.com/repository/docker/scibite/omp
[Application configuration]: docker/app.yml
