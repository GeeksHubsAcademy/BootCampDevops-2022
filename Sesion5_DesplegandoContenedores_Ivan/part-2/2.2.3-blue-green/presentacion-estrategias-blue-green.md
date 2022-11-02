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
# Blue/Green
![bg opacity:.2](https://i.gifer.com/8H4k.gif)

---
# Blue/Green

Consiste en desplegar de forma simultanea 2 versiones distintas y entonces mover el tráfico de Blue a Green.
Una vez pasamos de A a B, si tenemos problemas podemos hacer `roll back` instantáneo.

---
# Blue/Green

- Sin _downtime_
- Cambio de A a B
- Rollback inmediato

:warning: Cambia al directorio del ejericio :warning:
`cd part-2/2.2.3-blue-green`

---
# Blue/Green

Vamos a subir las imágenes de docker al registry local para que kubernetes las "encuentre".

- `docker build -t localhost:5001/third-lb:v1 -f Dockerfile-third-lb .`
- `docker build -t localhost:5001/third-app:v1 -f Dockerfile-third-app .`
- Modificamos `index.html` y:
- `docker build -t localhost:5001/third-app:v2 -f Dockerfile-third-app .`

---
# Blue/Green

Vamos a subir las imágenes de docker al registry local para que kubernetes las "encuentre".

```
docker push localhost:5001/third-lb:v1
docker push localhost:5001/third-app:v1
docker push localhost:5001/third-app:v2
```

---
# Blue/Green

Es hora de desplegar nuestra aplicación. Ahora vamos a deplegar la `v1` y la `v2` de forma simultanea, pero únicamente la `v1` recibe tráfico.

`kubectl -n default apply -f third-app.yml`

Y luego exponerla mediante el balanceador:

`kubectl apply -f third-lb.yml`

---
# Blue/Green

Tenemos `v1` recibiendo tráfico. Ahora es momento de cambiar a `v2`. Para ello:

- Editamos el `service` para decirle que ahora conecte a los `pods` de `v2`.
- `kubectl edit service third-app`

---
# Blue/Green
```
  selector:
    app: third-app
    version: v1
```
Se convierte en:
```
  selector:
    app: third-app
    version: v2
```

---
![bg opacity:.2](https://imagenes.20minutos.es/files/image_656_370/uploads/imagenes/2019/05/21/957237.jpg)
# Blue/Green

---
# Blue/Green
- Sin _downtime_
- Implementación sencilla.
- Requiere un segundo paso en el despliegue (hacer el cambio de versiones).

---
# Blue/Green

Ejercicio:

- Construir v3 y desplegarla.
- Ir alternando entre v1, 2 y 3
