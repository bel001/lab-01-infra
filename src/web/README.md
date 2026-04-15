# Frontend Web

Este modulo corresponde al frontend estatico servido con Nginx.

## Cambios realizados

- Se actualizo `index.html` para detectar si se esta ejecutando en `localhost` o en `dev`.
- El frontend ahora consulta automaticamente a la API del ambiente correcto.
- Se muestran en pantalla el contenedor web, el endpoint de la API y el puerto externo de la base de datos.
- Se presenta el estado de la conexion con el backend y la informacion devuelta por MySQL.

## Como funciona el cambio

- Si el frontend se abre en `4001`, consulta a la API en `4002`.
- Si el frontend se abre en `5001`, consulta a la API en `5002`.

## Resultado esperado

- `http://localhost:4001` muestra el ambiente `localhost`.
- `http://localhost:5001` muestra el ambiente `dev`.
- En ambos casos el frontend renderiza la respuesta del backend y confirma el acceso a MySQL.
