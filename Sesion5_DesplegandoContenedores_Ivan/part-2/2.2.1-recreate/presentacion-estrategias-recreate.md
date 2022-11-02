---
theme: gaia
_class: lead
paginate: false
backgroundColor: #e7252f
backgroundImage: url('./../../img/background-white.png')
color: #e7252f
marp: true
---
<!-- _backgroundImage: url('./../../img/background-red.png') -->
<!-- _color: white -->

# 4 Desplegando Contenedores

---
![bg opacity:.2](https://media.giphy.com/media/MS0fQBmGGMaRy/giphy.gif)
# Recreate

---
# Recreate

Reemplazar la actual versión por una nueva.

Apagar y encender.

---
# Recreate - ¿Cuándo utilizarlo?

- Cuando nuestra aplicación no esté preparada para trabajar con más de una réplica.
- Cuando nuestro despliegue sea manual, e.g. ftp a un directorio.
- En un estado embrionario de nuestro producto nos puede simplificar el despliegue (no producción)

---
# Recreate

- `docker run hello-world`

```
Hello from Docker!
This message shows that your installation appears to be working correctly.

[...]
```
---
# Recreate

Construimos el contenedor de nuestra aplicación y le decimos a docker que la ejecute:

```
docker build -t first-app:v1 .
docker run --rm -d -p 8080:80 first-app:v1
```

---
# Recreate

Podemos comprobar que está desplegada con:
`curl localhost:8080`

y como respuesta:

```
<h1>GeeksHubs - DevOps Bootcamp</h1>
<p>Version 1.0</p>
```

---
![bg opacity:.2](https://imagenes.20minutos.es/files/image_656_370/uploads/imagenes/2019/05/21/957237.jpg)
# Recreate

---
# Recreate

Ahora vamos a por la `v2`.

```
vim index.html
```
Y sustituimos `<p>Version 1.0</p>` por `<p>Version 2.0</p>`

Entonces hacemos `build` de nuestra nueva versión.

`docker build -t first-app:v2 .`

---
# Recreate

Podemos ver las imágenes que tenemos con `docker images`.

Ahora paramos el contenedor con la versión 1.

`docker stop containerId`

Y lanzamos la v2:

`docker run --rm -d -p 8080:80 first-app:v2`

Y comprobamos de nuevo el output:

`curl localhost:8080`

---
# Recreate

- Downtime.
- Fácil de implementar.

---
# Recreate

Ejercicio:

- Construir v3 y desplegarla.
