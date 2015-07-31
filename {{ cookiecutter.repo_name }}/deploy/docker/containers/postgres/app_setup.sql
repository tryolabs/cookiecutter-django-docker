CREATE USER {{ cookiecutter.postgresql_app_user }} PASSWORD '{{ cookiecutter.postgresql_app_user_password }}' CREATEDB;
CREATE DATABASE "{{ cookiecutter.postgresql_app_db_name }}" OWNER {{ cookiecutter.postgresql_app_user }} ENCODING 'UTF-8' LC_COLLATE 'en_US.utf8' LC_CTYPE 'en_US.utf8' TEMPLATE template0;
