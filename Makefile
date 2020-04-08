.PHONY: install all reflect_db1 reflect_db0 revision migrate format reset_db0 reset_db1 wipe


HERE := $(shell pwd)
VENV := $(shell pipenv --venv)

ARTIFACTS := ${HERE}/artifacts
MIGRATIONS := ${HERE}/migrations/versions
SCRIPTS := ${HERE}/scripts

MODEL := ${ARTIFACTS}/model.py
REFLECTION := ${ARTIFACTS}/reflection.py

ATM := $(shell date +%Y%m%d_%H%M%S)
DB0 := $(shell pipenv run dynaconf list | grep DB0 | sed -e 's/.*DB0: *//g')
DB1 := $(shell pipenv run dynaconf list | grep DB1 | sed -e 's/.*DB1: *//g')


format:
	pipenv run isort --virtual-env "${VENV}" --apply
	pipenv run black .


install:
	pipenv update --dev


all: reflect_db1 revision format reset_db1


reflect_db1:
	@pipenv run sqlacodegen ${DB1}
	pipenv run sqlacodegen --outfile "${REFLECTION}" ${DB1}
	mv "${MODEL}" "${MODEL}.bak.${ATM}"
	mv "${REFLECTION}" "${MODEL}"


reflect_db0:
	@pipenv run sqlacodegen ${DB0} > /dev/null 2>&1
	pipenv run sqlacodegen --outfile "${REFLECTION}" ${DB0}
	mv "${MODEL}" "${MODEL}.bak.${ATM}"
	mv "${REFLECTION}" "${MODEL}"


revision:
	PYTHONPATH="${HERE}" pipenv run alembic revision --autogenerate -m "autogen"


migrate:
	PYTHONPATH="${HERE}" pipenv run alembic upgrade head


reset_db1:
	pipenv run python "${SCRIPTS}/reset_db1.py"


reset_db0:
	pipenv run python "${SCRIPTS}/reset_db0.py"


wipe: reset_db0 reset_db1
	echo "from sqlalchemy.ext.declarative import declarative_base\n\nBase = declarative_base()" > "${MODEL}"
	rm -rf "${REFLECTION}"
	rm -rf "${ARTIFACTS}/*.bak"
	rm -rf "${MIGRATIONS}"
	install -m 0755 -d "${MIGRATIONS}"
	rm -rf Pipfile.lock
