const http = require("http");
const { getDatabaseStatus } = require("./db");

const hostname = "0.0.0.0";
const port = 3000;

const server = http.createServer(async (_request, response) => {
  try {
    const databaseStatus = await getDatabaseStatus();

    response.statusCode = 200;
    response.setHeader("Content-Type", "application/json");
    response.end(
      JSON.stringify({
        message: "Backend conectado a MySQL",
        api: "api01",
        database: {
          host: process.env.DB_HOST || "db",
          port: Number(process.env.DB_PORT || 3306),
          name: databaseStatus.databaseName,
          serverTime: databaseStatus.serverTime,
        },
      })
    );
  } catch (error) {
    response.statusCode = 500;
    response.setHeader("Content-Type", "application/json");
    response.end(
      JSON.stringify({
        message: "No se pudo conectar a MySQL",
        error: error.message,
      })
    );
  }
});

server.listen(port, hostname, () => {
  console.log(`Bienvenido http://${hostname}:${port}/`);
});
