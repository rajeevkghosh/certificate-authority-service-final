provider "google" {

#credentials = file("../composer-sa.json")
project = "modular-scout-345114"

}
provider "tls" {

}

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

/*resource "google_privateca_ca_pool" "default" {
  name = "my-ca-pool-tf1"
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

    identity_constraints {
      allow_subject_passthrough = true
      allow_subject_alt_names_passthrough = true
      cel_expression {
        expression = "subject_alt_names.all(san, san.type == DNS || san.type == EMAIL )"
        title = "My title"
      }
    }

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

*/

resource "google_privateca_certificate_authority" "test-ca" {
  certificate_authority_id = "my-authority"
  location = "us-central1"
  project = "modular-scout-345114"
  gcs_bucket = "composer-test-bucket1"
  //pool = google_privateca_ca_pool.default.name
  pool= "my-ca-pool-tf1"
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
  //key_spec {
    //algorithm = "RSA_PKCS1_4096_SHA256"
    //cloud_kms_key_version = data.google_kms_crypto_key_version.crypto_key_version.version
  //}
}

resource "google_privateca_certificate" "default" {
  //pool = google_privateca_ca_pool.default.name
  pool = "my-ca-pool-tf1"
  certificate_authority = google_privateca_certificate_authority.test-ca.certificate_authority_id
  project = "modular-scout-345114"
  location = "us-central1"
  lifetime = "860s"
  name = "my-certificate"
  pem_csr = tls_cert_request.example.cert_request_pem
}

data "google_kms_key_ring" "keyring-1" {
  name     = "keyring-1"
  location = "us-central1"
}

data "google_kms_crypto_key" "cryptokey-1" {
  name     = "cryptokey-1"
  key_ring = data.google_kms_key_ring.keyring-1.id
}

data "google_kms_crypto_key_version" "crypto_key_version" {
  crypto_key = data.google_kms_crypto_key.cryptokey-1.id
}

