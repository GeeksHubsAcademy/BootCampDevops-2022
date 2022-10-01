# Sesión 2: IaC

## Boilerplate
Aquí podéis encontrar un ejemplo de cómo empezaría yo a modelar un Stack en TF. Recordar cambiar vuestro nombre y el nombre del proyecto en el estado de TF (`_backend.tf`) y poner actualizar las tags que se usarán en el provider (`_provider.tf`)

## Simple Instance Examples
Estos ejemplos levantan una instancia sencilla de nginx. Recordad, si los vais a utilizar, de cambiar las tags y el estado como en el caso del boilerplate.

### 21 Simple Instance
Ejemplo con el modelado de la VPC y la instancia

### 22 Simple Instance Improved
Ejemplo con la instancia pero con una gestión más limpia de los archivos y utilizando la VPC y el security group ya existente.

### 23 Simple Instance Module
Aquí agrupo el stack como un módulo y lo llamo desde el módulo raíz.

### 24 Simple Instance Environments
Ejemplo de, como con módulos, podemos modelar diferentes stacks (en este caso los entornos de staging y producción)
