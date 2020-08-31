# docker-django-postgres
**Disclaimer**

I'm a Python, Django and Postgres noob - so a lot of this information may already be assumed by anyone trying to configure an application as such. 

This is a reference point for myself to take advantage from the several learning points undertaken in getting the application working

This starts off by following the docs.docker.com example on building a Django Postgres admin application with some additional collated information from various other sources and docker tweaking to include PgAdmin4

## Setting up the project
Start by installing Django inside a container and symlinking those files back out to the host machine
```
sudo docker-compose run web django-admin startproject composeexample .
```
`web` is the name of the `service` as defined in the `docker-compose.yml` file.

`composeexample` is going to be the name of the `django-admin` project

> This instructs Compose to run django-admin startproject composeexample in a container, using the web service’s image and configuration. Because the web image doesn’t exist yet, Compose builds it from the current directory, as specified by the build: . line in docker-compose.yml.

**Linux Note:** If you are running Docker on **Linux**, the files django-admin created are owned by root. This is because the container runs as the **Root** user. Change the ownership of the new files.
```
sudo chown -R $USER:$USER .
```

## Connect the databse to Django
In this section, set up the database connection for Django.
1. In the project directory, edit the composeexample/settings.py file
2. Replace the `DATABASES = ...` with the following:
   ``` 
   # settings.py
   
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.postgresql',
            'NAME': 'postgres',
            'USER': 'postgres',
            'PASSWORD': 'postgres',
            'HOST': 'db',
            'PORT': 5432,
        }
    }
   ```
   These settings are determined by the postgres Docker image specified in `docker-compose.yml`
3. Save and close the file 
4. Run the `docker-compose up` command from the top level directory for your project

## Adding PgAdmin as a web service
This is already part of the `docker-compose.yml` file and will mostly be setup on the `docker-compose up` command. 
For more information view [khezen/compose-postgres github](https://github.com/khezen/compose-postgres)

**Note**: as of current I'm missing out a lot of what **khezen** has provided as I was having `volume` and `networking` issues.

## Creating django tables and viewing them in PgAdmin
1. Run the `docker-compose up` command from the top level directory for your project
2. Once the application has fully started, run migrations to create the tables `docker-compose exec web python manage.py migrate`
3. Create a super user for django-admin `docker-compose exec web python manage.py createsuperuser`
4. Open PgAdmin in a web browser `localhost:5050`
5. login using the environment variables in the `docker-compose.yml` file
   1. username: pgadmin4@pgadmin.org
   2. password: admin
6. Create a connection to the postgres db
   1. ![Create a connection to the db](../docker-django-postgresql/images/create_server.png)
7. Give the connection a reasonable name - for this example `docker_django_postgres_db`
   1. ![DB connection name](../docker-django-postgresql/images/db_connection_name.png)
8. Enter the credentials. The really cool thing about this - for the `Host name\address` we can simply use the name of the docker service. In this example, it is simply `db`
   1. Host name\address : db
   2. port: 5432
   3. Maintenance database: postgres
   4. Username: postgres
   5. Password: postgres
   6. ![DB connection details](../docker-django-postgresql/images/db_connection_details.png)
9. Check that the tables and super user are created by navigating the sidebar in `PgAdmin`
   1.  ![DB data](../images/../docker-django-postgresql/images/db_data.png)


### References
[docker django postgres example](https://docs.docker.com/compose/django/)

[create a django project](https://docs.docker.com/compose/django/#create-a-django-project)

[khezen/compose-postgres github](https://github.com/khezen/compose-postgres)
