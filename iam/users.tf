module "aaron_borden" {
  source = "./user"
  name   = "aaron.borden@gsa.gov"
  groups = [
    "developers",
    "Admin"
  ]
}

module "adam_kariv" {
  source = "./user"
  name   = "akariv@viderum.com"
  groups = [
    "developers",
    "datagov-ckan-multi"
  ]
}

module "joel_natividad" {
  source = "./user"
  name   = "joel.natividad@datopian.com"
  groups = [
    "developers",
    "datagov-ckan-multi"
  ]
}

module "anuar_ustayev" {
  source = "./user"
  name   = "austayev@viderum.com"
  groups = [
    "developers",
    "datagov-ckan-multi"
  ]
}
