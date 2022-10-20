# Packer

# 0. Preparación
Creamos un archivo `.pkr.hcl` que declare:
- La source adecuada para construir la imagen en AWS
- Un bloque de data para buscar la ami de Ubuntu de forma similar a TF
- El bloque build con la source adecuada, la ami y la config necesaria.

IMPORTANTE: Crear un nombre de AMI que sea único. Puedo usar algo tipo `"web_server_nacho_{{timestamp}}"`

NOTA: voy a tener que indicarle la VPC y la subnet para que haga la build. Podría usar otra VPC/subnet pero uso las que tienen tag con "Name" "GeeksHubs-DevOps".

Una vez tenga una AMI y la quiera probar, solo actualizo el bloque de data en Terraform para busque esta AMI generada (ya no es necesario cloud-init ni Ansible).

# 1. Provisión de AMI básica
- Un provisioner que actualize los paquetes
- Un provisioner (puedo usar el anterior) que installe nginx y active el servicio
- Un provisioner que suba el archivo `index.html` a `/tmp/index.html`
- Un provisioner que mueva el archivo a `/var/www/html/index.html`

# 2. Provisionar con Ansible
Creo otro `.pkr.hcl` o modifico el anterior pero ahora la provisión la hago con Ansible utilizando un playbook de ansible que utilice los roles creados en el ejercicio 2.

Ojo! ya no aplico a un grupo del inventario!
