# Ejercicios IaC

El objetivo de todos los ejercicios es el mismo: Crear un servidor Nginx en Ubuntu para servir una web simple en HTML.

Lo interesante es ver que se puede llegar al mismo resultado de varias formas y ver las ventajas y desventajas de cada una de ellas.

## 0. Boilerplate
En esta carpeta encontramos el código Terraform básico para crear una instancia a partir de una AMI que vimos en la sesión anterior.

Recuerda que tenemos que hacer los cambios necesarios en esta carpeta:
- Providers
- Backend

(vamos a utilizar una VPC común y ahorrarnos un balanceador para no andar generando y destruyendo infra, que es tiempo)

Comprobamos que, como el otro día, somos capaces de generar una instancia de Bitnami y verla en la IP proporcionada como output.

## 1. Cloud-admin
Antes de nada vamos a dejar de utilizar esta AMI de Bitnami y vamos a gestionar nosotros directamente una Ubuntu. Por tanto actualizo la AMI.

El objetivo del ejercicio es crear un fichero de cloud-init en formato cloud-config (YAML)

Una vez hecho parcial o totalmente y modifico la instancia en el boilerplate para que utilice el fichero que me interese.


## 2. Ansible
Empiezo de forma similar al ejercicio anterior ya que necesito provisionar de alguna forma el acceso de Ansible. Para ello uso un fichero simplificado de cloud-admin que solo me cree el usuario con la clave SSH.

El resto será todo gestionado usando Ansible

## 3. Packer
Aquí no voy a gestionar una instancia provisionada sino que voy a generar una AMI. Para ello, modificaré el bloque `data` en Terraform para que busque la AMI en cuestión.
