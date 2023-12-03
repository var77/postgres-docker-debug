## Postgres Debug Image
This image can help you to debug the postgres database crash, as it has postgres built in debug mode and gdb installed which can help you in debugging.

Image is published under `varik77/postgres:15-debug`

## Instructions
```
# To use GDB inside container run docker like this:
 docker build . -t pg-lantern-debug
 docker run --cap-add=SYS_PTRACE -p 5433:5432 -d --name debug-pg pg-lantern-debug
# Then exec to it docker exec -ti debug-bg bash
sudo su # the password is postgres
gdb -p $pid_of_pg_backend
```
