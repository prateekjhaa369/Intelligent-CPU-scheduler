$docker = 'C:\Program Files\Docker\Docker\resources\bin\docker.exe'
& $docker system prune -af --volumes
& $docker system df
