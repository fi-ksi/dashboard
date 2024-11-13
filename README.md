# KSI dashboard

## Docker version

```
git clone https://github.com/fi-ksi/dashboard.git
# edit config.py to set database secret
docker-compose up --build
```

By default, the docker is set to build static HTML files. If you want to use the Jupyter development server instead, comment the entrypoint and command in `docker-compose.yaml` and uncomment the port assigments.

## Non Docker version


## Installation

 1. Clone this repository.
 2. Install virtualenv & packages into `ksi-py3-venv` directory.

```
python3.9 -m venv ksi-py3-venv
source ksi-py3-venv/bin/activate
python -m pip install wheel
python -m pip install -r requirements.txt
```

 3. Enter db url into `config.py` file. Format:

```
SQL_ALCHEMY_URI = 'mysql://username:password@server/db_name?charset=utf8mb4'
```

## Serve static files

You can make static html files and then serve them via web server:
```
$ make all
```

## Edit files

You can run jupyter notebook and edit all the files:
```
$ jupyter notebook
```
