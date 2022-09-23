
## Ejemplo de Terraform con el proveedor DigitalOcean

### Pasos
1º Debes adherir tu ssh pública de Digital Ocean para poder autentificarte por ssh.
2º generar en digital Ocean un Access Token que añadiremos posteriormente a las variables de entorno.
3º Declarar las siguientes variables de entorno:
    export DO_PAT="YOUR ACCES TOKEN"
    export TF_LOG=1

### Instrucciones.

Iniciar terraform:
 *    make terraform-init

Aplicar el plan:
  *  make terraform-plan

Ejecutar la infraestructura:
   * make terraform-apply

Mostrar el estado de la infra creada:
* make terraform-show

Destruir Infra.
   * make terraform-destroy