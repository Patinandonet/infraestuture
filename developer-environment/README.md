Developer environment
=====================

Bucket
------
Creamos el bucket para guardar el tfstate: `patinando-deveveloper-environment-tfstate`

Service account
---------------
Creamos una cuenta de servicio con los siguientes permisos:
* Project IAM Admin
* Storage Admin


Service account workflow

$ terraform output cloud_dev_ide_key