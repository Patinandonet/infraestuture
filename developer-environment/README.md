Developer environment
=====================

Bucket
------
Creamos el bucket para guardar el tfstate: `patinando-deveveloper-environment-tfstate`

Service account
---------------
Creamos una cuenta de servicio con los siguientes permisos:
* Compute Instance Admin (v1)
* Role Administrator
* Service Account Admin
* Service Account Key Admin
* Project IAM Admin
* Storage Admin

Service account workflow

$ terraform output cloud_ide_sa_key
