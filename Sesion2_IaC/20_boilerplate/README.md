# BOILERPLATE

## Backend
Os dejo este archivo con lo básico para inicializar un proyecto en terraform con su estado.

El backend (archivo `_backend.tf`) para almacenar el estado es S3 y todos guardaremos el estado en el mismo bucket `terraform-devops-dev` . Este se indica en la key "bucket"

El valor de la key "key" indica el path al fichero de estado que usaremos. Recuerda cambiar `<tu_nombre>` para que se cree una carpeta con tu nombre y recíclalo para todos los proyectos que utilicemos. El valor de `<ejercicio>` será diferente para cada uno de los ejemplos que queramos hacer. Os comento en la segunda clase cómo se modela esto en la vida real.

El valor de "dynamodb_table" es la tabla de dynamodb para hacer los locks. Podríamos quitar este valor porque, en realidad, no vamos a compartir el estado con nadie.

## Provider
El único provider a usar es AWS. Podríamos declarar otros si quisiésemos. Además, se podrían instanciar varios providers de AWS, os cuento en la segunda clase en qué casos nos interesa y cómo podemos hacerlo

## Archivos
Es buena práctica tener un `main.tf` aunque esté vacío. Aquí suele venir bien declarar lo principal del módulo (depende de lo que queramos modelar). Todo esto lo cubrimos en la segunda clase.

También tendremos un `versions.tf` aunque a veces se deja todo el bloque terraform junto. Yo lo prefiero aparte.

Además deberíamos tener si existen:
- `variables.tf`
- `outputs.tf`
- `data.tf` (aunque este es más opcional)
