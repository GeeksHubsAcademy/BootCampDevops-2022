# Construir un Devops pipeline

## Levantar un nuevo clúster de Kubernetes (con Kind)

:warning: Lanza el comando desde la raíz del repositorio :warning:

`./kind/cluster.sh`

## Requisitos del ejercicio

Vamos a imitar un entorno de producción con múltiples dominios para las aplicaciones del stack.
Si tienes gestor de DNS en tu red pridada, ¡genial! aprovéchalo.
Si no, puedes añadir los siguientes dominios en el fichero `/etc/hosts`:

```
127.0.0.1 www.acme.com gogs.acme.com jenkins.acme.com
```


:warning: Cambia al directorio del ejercicio :warning:
```
cd part-3/
```

1) `kubectl apply -f manifests/ingress.yml`
2) `kubectl apply -f manifests/gogs.yml`
3) `kubectl apply -f manifests/jenkins-sa.yml`
4) `kubectl apply -f manifests/jenkins.yml`


## Configurar GOGS

URL -> http://gogs.acme.com/

Seguir el wizard y crear un repositorio.
- Seleccionar SQLlite con ruta absoluta
- Configurar la URL de la interfaz web igual al dominio `http://gogs.acme.com/`

## Configurar Jenkins

URL -> http://jenkins.acme.com/

1) `kubectl get pods`
2) `kubectl logs -f jenkins-xxxxx`
Extraer el token

Seguir el wizard.

Plugins adicionales:

- Kubernetes
- Blue Ocean (opcional)
- Web for Blue Ocean (opcional)

### Configurar Kubernetes

Jenkins > Configuration

Add cloud:
- Kubernetes Namespace: default
- Jenkins URL: http://jenkins.default:8000
- Crear credenciales de tipo Kubernetes

### Crear job

Crear nuevo `Multibranch pipeline` apuntando al repositorio de Gogs

## Un poco de limpieza

¡Hemos llegado al final! Y por el camino hemos construido y utilizado un montón de herramientas y contenedores.
Para eliminarlos, ejecuta los siguientes comandos:

```
kind delete cluster --name produccion
docker rm -f kind-registry
```

:warning: Estos comandos son un poco más "delicados" ya que eliminarán todas las imagenes, redes y volumenes de docker :warning:

```
docker system prune -fa
docker volume prune
```