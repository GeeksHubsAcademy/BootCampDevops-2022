Este stack crea los elementos necesarios en la cuenta de GeeksHubs para que los alumnos puedan hacer los ejercicios

## Elementos no contemplados
Aquellos necesarios para el uso de AWS como backend (S3+DynamodB). Han sido creados con un código ajeno a este repositorio.
- El bucket que se utilizará para almacenar el estado (`terraform-devops-dev`).
- La tabla de DynamoDB utilizada para el locking (`terraform_state_locking-devops-dev`).

## Elementos contemplados
- Las cuentas de cada uno de los alumnos
- El grupo con los permisos necesarios
- La política con dichos permisos
