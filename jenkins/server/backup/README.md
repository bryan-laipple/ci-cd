The backups in this directory were created by running the `backupJenkins.sh` as the `jenkins` user inside a Docker container of the Jenkins Server .  The backups are just a copy of the `/var/jenkins_home` directory so should be able to be restored running the following as the `jenkins` user:
```bash
$ tar xvfz <backup_name>.tar.gz
```