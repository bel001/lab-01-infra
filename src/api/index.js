const http = require("http");
const { getDatabaseStatus } = require("./db");

const hostname = "0.0.0.0";
const port = 3000;
const environment = process.env.APP_ENV || "localhost";

function setCorsHeaders(response) {
  response.setHeader("Access-Control-Allow-Origin", "*");
  response.setHeader("Access-Control-Allow-Methods", "GET, OPTIONS");
  response.setHeader("Access-Control-Allow-Headers", "Content-Type");
}

function sendJson(response, statusCode, payload) {
  response.statusCode = statusCode;
  setCorsHeaders(response);
  response.setHeader("Content-Type", "application/json");
  response.end(JSON.stringify(payload));
}

async function buildStatusPayload() {
  const databaseStatus = await getDatabaseStatus();

  return {
    message: "Backend conectado a MySQL",
    api: "api01",
    environment,
    database: {
      host: process.env.DB_HOST || "db",
      port: Number(process.env.DB_PORT || 3306),
      name: databaseStatus.databaseName,
      serverTime: databaseStatus.serverTime,
    },
  };
}

const server = http.createServer(async (request, response) => {
  if (request.method === "OPTIONS") {
    response.statusCode = 204;
    setCorsHeaders(response);
    response.end();
    return;
  }

  if (request.method !== "GET") {
    sendJson(response, 405, {
      message: "Metodo no permitido",
    });
    return;
  }

  if (request.url !== "/" && request.url !== "/health") {
    sendJson(response, 404, {
      message: "Ruta no encontrada",
    });
    return;
  }

  try {
    const payload = await buildStatusPayload();
    sendJson(response, 200, payload);
  } catch (error) {
    sendJson(response, 500, {
      message: "No se pudo conectar a MySQL",
      error: error.message,
    });
  }
});

server.listen(port, hostname, () => {
  console.log(`Bienvenido http://${hostname}:${port}/`);
});
