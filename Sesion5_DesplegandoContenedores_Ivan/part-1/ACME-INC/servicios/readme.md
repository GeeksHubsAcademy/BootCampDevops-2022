# Configuración del stack.

```
docker-compose -f docker-compose.yml up --build
```

## Gogs

Seleccionar SQLlite como base de datos y utilizar una ruta absoluta:

![Gogs DB config](../../../img/gogs_db_config.png)

Configurar URL del servicio:

![Gogs URL config](../../../img/gogs_domain_config.png)

Configurar cuenta de administrador:

![Gogs Admin account setup](../../../img/gogs_admin.png)

Crear un repositorio para acme-inc.

## Jenkins

Seguir el wizard. (En el output de la consola saldrá el token)
Instalar los plugins `Docker Pipeline` y reiniciar Jenkins.
Añadir un nuevo pipeline de tipo `Multibranch Pipeline` apuntando al repositorio de Gogs mediante HTTP utilizando credenciales.

## Registry

No hay que hacer ningún setup adicional
