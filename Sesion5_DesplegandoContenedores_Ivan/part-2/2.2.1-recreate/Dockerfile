FROM nginx:1.17.8-alpine

# Copiar el site conf
COPY first-app.conf /etc/nginx/conf.d/default.conf

# Crear carpeta para mi aplicación
RUN mkdir -p /www/data

# Cambiar a ese directorio
WORKDIR /www/data

# Copiar el index como index.html
COPY index.html .
