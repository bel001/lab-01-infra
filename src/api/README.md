# API Backend

Este modulo corresponde al backend en Node.js del laboratorio.

## Cambios realizados

- Se agrego la dependencia `mysql2` para conectarse a MySQL.
- Se separo la logica de acceso a base de datos en `db.js`.
- `index.js` ahora consulta MySQL y responde con un JSON que confirma la conexion.
- Se agrego soporte CORS para que el frontend pueda consultar a la API desde otro puerto.
- Se habilito la ruta `/health` para verificar el backend desde navegador o pruebas manuales.
- El `Dockerfile` ahora instala dependencias antes de copiar el resto del codigo.
- Se agrego `.gitignore` para evitar subir `node_modules`.

## Variables de entorno usadas

- `APP_ENV`
- `DB_HOST`
- `DB_PORT`
- `DB_NAME`
- `DB_USER`
- `DB_PASSWORD`

## Archivos principales

- `index.js`: servidor HTTP y respuesta del endpoint.
- `db.js`: conexion y consulta a MySQL.
- `package.json`: dependencias y script de inicio.
- `Dockerfile`: construccion de la imagen del backend.

## Rutas disponibles

- `/`: estado general del backend y la base de datos.
- `/health`: misma respuesta de estado, util para pruebas y monitoreo basico.

## Resultado esperado

Cuando el contenedor de la API y el contenedor de MySQL estan levantados, el backend responde en el puerto `4002` para `localhost` con un JSON similar a este:

```json
{
  "message": "Backend conectado a MySQL",
  "api": "api01",
  "environment": "localhost",
  "database": {
    "host": "db",
    "port": 3306,
    "name": "lab_db"
  }
}
```
