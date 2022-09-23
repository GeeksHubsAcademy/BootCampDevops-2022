## Ejemplo de Packer con Ansible.

### Pasos
1º Debes adherir tu ssh pública de Digital Ocean para poder autentificarte por ssh.
2º generar en digital Ocean un Access Token que añadiremos posteriormente a las variables de entorno.
3º Declarar las siguientes variables de entorno:

    export DO_PAT="YOUR ACCES TOKEN"


### Instrucciones.
Para crear una imagen deberemos ejecutar:
* make packer-init