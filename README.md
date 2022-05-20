# KSI dashboard

## Docker version

```
git clone https://github.com/fi-ksi/dashboard.git
# edit config.py, see instruction from the non docker version
docker-compose up --build
```

## Non Docker version

### Software needed

 * Python 3.6 (including dev package)
 * virtualenv
 * packages from `requirements.txt` (building of the packages requires gcc and libmysqlclient-dev)
 * make
 
```
sudo apt install -y python3.6 python3.6-dev python3.6-venv libmysqlclient-dev virtualenv gcc make
```


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
