## Example docker swarm

## Vagrant
Arrancar vagrant:
* vagrant up 

Ver el estado de vagrant:
*   vagrant status[machine]

Acceder a una máquina:
* vagrant ssh [node]

Destruir infraestructura:

* vagrant destroy

### Docker Swarm 
Visualizar las ips dentro de las máquinas:
* ip addr show

Iniciar Docker Swarm:
* docker swarm init --advertise-addr [ip]

Obtener información de la máquina:
* docker info

Obtener instrucción de acceso a la máquina:
* docker swarm join-token worker

Obtener información de los nodos:
[Manager]
* sudo docker node ls

Obtener información de un nodo:
* sudo docker node inspect worker01 --pretty
 
Elevar un nodo como nanager:
* sudo docker node promote worker03 

Eliminar un manager:
* sudo docker node demote manager

Extraer un nodo del nodo:
[worker eliminado]
* sudo docker swarm leave

Eliminar el nodo:
[Manager]
* sudo docker node rm manager


### Servicios.
Creación de un servicio:
[Manager]
* sudo docker service create --replicas 1 --name servicio1 alpine ping google.com

Listar los servicios:
* sudo docker service ls

Inspeccionar el servicio:
* sudo docker service inspect --pretty servicio1

Crear un servicio con rélicas:
* sudo docker service create --replicas 3 --name servicio2 alpine ping google.com

Obtener información del servicio:
* sudo docker service ps servicio2

Borramo el servicio 2
* sudo docker service rm servicio2

Escalar un servicio
* sudo docker service scale [nombre servicio]=[número de réplicas]