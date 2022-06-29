provider google{}
provider tls{}

resource "tls_private_key" "example" {
  algorithm   = "RSA"
}

resource "tls_cert_request" "example" {
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.example.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }
}

resource "google_privateca_ca_pool" "default" {
  name = "my-ca-pool-tf7"
  location = "us-central1"
  tier = "ENTERPRISE"
  project = "modular-scout-345114"
  publishing_options {
    publish_ca_cert = true
    publish_crl = true
  }
  labels = {
    foo = "bar"
  }
  issuance_policy {
    baseline_values {
      ca_options {
        is_ca = false
      }
      key_usage {
        base_key_usage {
          digital_signature = true
          key_encipherment = true
        }
        extended_key_usage {
          server_auth = true
        }
      }
    }
  }
}

resource "google_privateca_certificate_authority" "test-ca2" {
  certificate_authority_id = "my-authority2"
  location = "us-central1"
  project = "modular-scout-345114"
  pool = google_privateca_ca_pool.default.name
  deletion_protection = false
  config {
    subject_config {
      subject {
        country_code = "us"
        organization = "google"
        organizational_unit = "enterprise"
        locality = "mountain view"
        province = "california"
        street_address = "1600 amphitheatre parkway"
        postal_code = "94109"
        common_name = "my-certificate-authority"
      }
    }
    x509_config {
      ca_options {
        is_ca = true
      }
      key_usage {
        base_key_usage {
          cert_sign = true
          crl_sign = true
        }
        extended_key_usage {
          server_auth = true
        }
      }
    }
  }
  type = "SELF_SIGNED"
  key_spec {
    //algorithm = "RSA_PSS_2048_SHA256"
    cloud_kms_key_version = trimprefix(data.google_kms_crypto_key_version.crypto_key_version.name, "//cloudkms.googleapis.com/v1/")
  }
}

resource "google_privateca_certificate" "default" {
  pool = google_privateca_ca_pool.default.name
  certificate_authority = google_privateca_certificate_authority.test-ca2.certificate_authority_id
  project = "modular-scout-345114"
  location = "us-central1"
  lifetime = "860s"
  name = "my-certificate"
  pem_csr = tls_cert_request.example.cert_request_pem
}

data "google_kms_key_ring" "keyring-1" {
  name     = "keyring-1"
  location = "us-central1"
  project = "modular-scout-345114"
}

resource "google_kms_crypto_key" "cryptokey-2" {
  name     = "cryptokey-2"
  key_ring = data.google_kms_key_ring.keyring-1.id
  purpose  = "ASYMMETRIC_SIGN"

  version_template {
    algorithm = "RSA_SIGN_PSS_2048_SHA256"
  }

  lifecycle {
    prevent_destroy = true
  }
}


data "google_kms_crypto_key_version" "crypto_key_version" {
  crypto_key = google_kms_crypto_key.cryptokey-2.id
}