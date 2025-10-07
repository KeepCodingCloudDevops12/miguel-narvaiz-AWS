# 🚀 Práctica Final Keepcoding AWS: Website Estático con Terraform en S3

Este repositorio contiene la solución a la Práctica Final del Bootcamp de AWS de Keepcoding. Se utiliza **Terraform** para desplegar un sitio web estático simple alojado en un bucket de **AWS S3** en la región **N. Virginia** (`us-east-1`).

El diseño del sitio web utiliza el framework **Pico.css** para un aspecto moderno, ligero y con soporte para **Modo Oscuro (Dark Mode)**.

---

## 📋 Requisitos Previos

Antes de ejecutar el código de Terraform, asegúrate de tener instalado y configurado lo siguiente:

1.  **Terraform CLI:** Versión 1.0 o superior.
2.  **AWS CLI:** Configurado y autenticado en tu terminal.
3.  **Credenciales de AWS:** El usuario de IAM configurado debe tener los permisos necesarios para gestionar los recursos S3, incluyendo `s3:PutBucketPolicy` y el manejo de los Bloques de Acceso Público.

---

## 📂 Estructura del Proyecto

El proyecto se compone de los siguientes archivos:

````
.
├── main.tf             # Plantilla principal de Terraform.
├── index.html          # Página principal del sitio web.
├── error.html          # Página personalizada de error 404.
└── README.md           # Instrucciones de ejecución y evaluación.
````

---

## ⚙️ Configuración y Despliegue

Sigue estos pasos en tu terminal para desplegar la infraestructura.

### 1. Clonación del Repositorio

Clona este repositorio de GitHub y navega al directorio del proyecto:

```bash
git clone https://github.com/KeepCodingCloudDevops12/miguel-narvaiz-AWS
cd miguel-narvaiz-AWS
````


### 2. Inicialización

Inicializa Terraform para descargar el proveedor de AWS y preparar el entorno.

```bash
terraform init
````

3. Planificación
Ejecuta el plan para ver qué recursos serán creados por Terraform.

````
terraform plan
````

4. Aplicación (Despliegue)
Aplica los cambios para crear la infraestructura en AWS. Confirma con yes cuando se te solicite.

````
terraform apply
````

✅ Evaluación y Acceso
Una vez que la aplicación finalice, Terraform imprimirá los Endpoints de conexión.

Output Requerido
El output solicitado por la práctica es:
````
terraform output website_endpoint
````

# Cómo Acceder y Probar el Sitio

1.- Página Principal (index.html):


  Utiliza la URL completa proporcionada en el output "website_url" para acceder al sitio.

2.- Página de Error (error.html - Prueba de 404):

  Para probar la página de error personalizada, añade una ruta inexistente al final de la URL del sitio 

````
(Ej: [URL_DEL_SITIO]/recurso-que-no-existe).
````

Verifica que se muestre la página error.html con el diseño de alerta.


🗑️ Limpieza (Destrucción de Recursos)
Para eliminar todos los recursos de AWS creados por esta práctica y evitar costos, ejecuta el siguiente comando y confirma con *yes*:

````
terraform destroy
````













