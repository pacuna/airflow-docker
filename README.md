# airflow-docker

Run Airflow using docker containers

## Run

```sh
docker-compose up --build
```

## Description

This project creates a full working Airflow environment using Docker containers.

It uses the Celery Executor with Redis as the broker/backend and PostgreSQL as the core Airflow database.

All the configuration is done via environmental variables. If you want change these values or add
new variables, you can modify the `env/airflow.env` file using the Airflow convention of
`AIRFLOW__SECTION__VAR_NAME` where the section and var name are defined in the `airflow.cfg` file that
comes with the airflow installation. The environmental variables will override any value from the cfg file.   

The airflow.env file contains an example fernet key that is used by all containers so they can all decrypt encrypted values. For any production use, this should be changed by creating a new value using

```
python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
```


All the necessary Airflow processes including `airflow initdb` command, webserver, scheduler and worker are
isolated in their own Docker container and with a proper startup control using custom scripts (`sh/wait-for-migrations.sh`, `sh/wait-for-postgres.sh`).
So the project should start with not errors the first time. If not, please create an issue describing your case.

By default, the webserver forwards the port 8080 to the host so you can go to `localhost:8080` after starting the project.

The python dependencies are specified in the Dockerfile for now in case you need to add more packages.

The Dags and Plugins folder are mounted into the webserver, worker and scheduler so you can modify them and see the changes immediatly. If you see
some file stuck in an old state, it's better to restart (and maybe rebuild) the whole project.

## Tips

- Use `docker-compose logs -f` to troubleshoot errors
- You can open bash sessions inside the containers to test airflow commands: `docker-compose exec worker bash` or `docker-compose run --rm worker airflow list_dags`
