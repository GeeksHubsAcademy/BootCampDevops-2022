# Cloud-init

## 1. Servir HTML básico

El fichero tiene que realizar las siguientes operaciones en nuestro servidor:
- Actualizar el gestor de paquetes y los paquetes (update & upgrade)
- Instalar nginx
- Copiar un HTML básico para que lo sirva ese nginx. Si no quiero configurar el nginx valdría con esto:
  - Permisos: `root:root`
  - Path: `/var/www/html/index.html`
- Restar el nginx para que cargue la configuración

## 2. Crear un usuario de administración

El fichero, además, hará lo siguiente:
- Crear un usuario "administrator" (o el usuario que quiera)
- Darle capacidad de hacer sudo sin password
- Meterle en los grupos "users" y "admin"
- Asignarle una clave ssh autorizada.

Nota:
- Tenemos que crear un par de claves ssh (`ssh-keygen`)


## Anexo: ejemplo de HTML

```html
<!DOCTYPE html>
<html>
<head>
<title>your-name-here did this!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Hello World!</h1>
<p>This is my supersite set up by cloud-init</p>
</body>
</html>
```
