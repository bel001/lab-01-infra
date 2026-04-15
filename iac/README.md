# Despliegue

Este modulo usa Terraform para desplegar tres servicios dockerizados:

- `web`: frontend con Nginx
- `api`: backend en Node.js
- `db`: base de datos MySQL

## Inicializacion

```bash
cd iac
terraform init
terraform validate
```

## Ambientes

### Localhost

- Web: `http://localhost:4001`
- API: `http://localhost:4002`
- MySQL: `localhost:4003`

```bash
cd iac
terraform workspace select default
terraform apply -auto-approve -lock=false
```

### Dev

- Web: `http://localhost:5001`
- API: `http://localhost:5002`
- MySQL: `localhost:5003`

```bash
cd iac
terraform workspace select dev || terraform workspace new dev
terraform apply -auto-approve -lock=false
```

## Destruir infraestructura

### Localhost

```bash
cd iac
terraform workspace select default
terraform destroy -auto-approve -lock=false
```

### Dev

```bash
cd iac
terraform workspace select dev
terraform destroy -auto-approve -lock=false
```
