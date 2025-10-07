# -----------------------------------------------------------------------------
# 1. CONFIGURACIÓN DEL PROVEEDOR
# -----------------------------------------------------------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  # Región N. Virginia
  region = "us-east-1"
}

# -----------------------------------------------------------------------------
# 2. RECURSO DEL BUCKET S3
# -----------------------------------------------------------------------------
resource "aws_s3_bucket" "kp_bt_s3_website_static_bucket" {
  # Nombre del bucket globalmente único
  bucket = "mikelab-kc-aws"

  # Habilitar el control de versiones (opcional, pero buena práctica)
  # versioning {
  #   enabled = true
  # }

  tags = {
    Name    = "Mikelab S3 Static Website Bucket"
    Project = "KC Mikelab AWS"
  }
}

# -----------------------------------------------------------------------------
# 3. BLOQUEO DE ACCESO PÚBLICO (NECESARIO DESACTIVARLO)
# -----------------------------------------------------------------------------
resource "aws_s3_bucket_public_access_block" "kp_bt_s3_website_static_bucket_pab" {
  bucket                  = aws_s3_bucket.kp_bt_s3_website_static_bucket.id
  # Deben ser 'false' para permitir el acceso público
  block_public_acls       = false
  block_public_policy     = false  
  ignore_public_acls      = false
  restrict_public_buckets = false
  
 }

# -----------------------------------------------------------------------------
# 4. POLÍTICA DE ACCESO AL BUCKET (PERMITIR s3:GetObject A TODO EL MUNDO)
# -----------------------------------------------------------------------------
resource "aws_s3_bucket_policy" "kp_bt_s3_website_static_bucket_policy" {
  bucket = aws_s3_bucket.kp_bt_s3_website_static_bucket.id
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Sid"       = "PublicReadGetObject",
        "Effect"    = "Allow",
        "Principal" = "*",
        "Action"    = "s3:GetObject",
        "Resource"  = [
          "${aws_s3_bucket.kp_bt_s3_website_static_bucket.arn}/*" # Aplica a todos los objetos en el bucket
        ]
      }
    ]
  })
}

# -----------------------------------------------------------------------------
# 5. CONFIGURACIÓN DEL SITIO WEB ESTÁTICO
# -----------------------------------------------------------------------------
resource "aws_s3_bucket_website_configuration" "kp_bt_s3_website_static_bucket_configuration" {
  bucket = aws_s3_bucket.kp_bt_s3_website_static_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# -----------------------------------------------------------------------------
# 6. CARGA DE OBJETOS (ARCHIVOS HTML)
# -----------------------------------------------------------------------------
# Archivo de índice
resource "aws_s3_object" "kp_bt_s3_website_static_bucket_object_index" {
  bucket       = aws_s3_bucket.kp_bt_s3_website_static_bucket.bucket
  key          = "index.html"
  source       = "index.html"
  source_hash  = filemd5("index.html")
  content_type = "text/html"
  # acl          = "public-read"  <-- ¡QUITAR O COMENTAR ESTA LÍNEA!
}

# Archivo de error
resource "aws_s3_object" "kp_bt_s3_website_static_bucket_object_error" {
  bucket       = aws_s3_bucket.kp_bt_s3_website_static_bucket.bucket
  key          = "error.html"
  source       = "error.html"
  source_hash  = filemd5("error.html")
  content_type = "text/html"
  # acl          = "public-read"  <-- ¡QUITAR O COMENTAR ESTA LÍNEA!
}

# -----------------------------------------------------------------------------
# 7. OUTPUT REQUERIDO
# -----------------------------------------------------------------------------
# Creamos el output con la URL de accesso
output "website_endpoint" {
    # Usamos el atributo website_endpoint del recurso de configuración del sitio web
    value = aws_s3_bucket_website_configuration.kp_bt_s3_website_static_bucket_configuration.website_endpoint
    description = "Endpoint de conexión para el Website Estático"
}

# Output adicional para la URL completa (más amigable)
output "website_url" {
    value       = "http://${aws_s3_bucket_website_configuration.kp_bt_s3_website_static_bucket_configuration.website_endpoint}"
    description = "URL completa del sitio web estático"
}