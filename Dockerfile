# To use GDB inside container run docker like this:
# docker build . -t pg-debug
# docker run --cap-add=SYS_PTRACE -p 5433:5432 -d --name debug-pg pg-debug
# Then exec to it docker exec -ti debug-bg bash
# sudo su # the password is postgres
# gdb -p $pid_of_pg_backend

FROM ubuntu:22.04
ARG VERSION=15.3

RUN apt update && apt install wget git make build-essential libreadline8 libreadline-dev zlib1g zlib1g-dev cmake gdb tmux vim sudo -y

# Build and install postgres
RUN cd /root && wget https://ftp.postgresql.org/pub/source/v${VERSION}/postgresql-${VERSION}.tar.bz2 && \
    tar xf postgresql-${VERSION}.tar.bz2 && \
    rm -rf postgresql-${VERSION}.tar.bz2 && \
    cd postgresql-${VERSION} && ./configure --enable-debug && \
    make && make install

ENV PATH="${PATH}:/usr/local/pgsql/bin"

# Add postgres user
RUN pass=$(perl -e 'print crypt("postgres", "postgres")' $password) && \
		useradd -m -p "$pass" "postgres" && \
		echo 'postgres  ALL=(ALL:ALL) ALL' >> /etc/sudoers

# Run initdb
USER postgres

RUN mkdir /home/postgres/db && /usr/local/pgsql/bin/initdb -D /home/postgres/db && \
    echo "listen_addresses '*' " >> /home/postgres/db/postgresql.conf && \
    echo "host    all             all             0.0.0.0/0               trust" >> /home/postgres/db/pg_hba.conf

CMD ["/usr/local/pgsql/bin/postgres", "-D", "/home/postgres/db"]