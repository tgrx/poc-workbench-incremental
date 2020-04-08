.PHONY: revision migrate install format reset_db1

VENV := $(shell pipenv --venv)
PYTHONPATH := $(shell pwd)


reflect:
	pipenv run sqlacodegen --outfile artifacts/models1.py $(shell pipenv run dynaconf list | grep DB1 | sed -e 's/.*DB1: *//g')
	mv artifacts/models.py artifacts/models.py.bak.$(shell date +%Y%m%d_%H%M%S)
	mv artifacts/models1.py artifacts/models.py


revision:
	PYTHONPATH="${PYTHONPATH}" pipenv run alembic revision --autogenerate -m "autogen"


migrate:
	PYTHONPATH="${PYTHONPATH}" pipenv run alembic upgrade head


install:
	pipenv update --dev


format:
	pipenv run isort --virtual-env "${VENV}" --apply
	pipenv run black .


reset_db1:
	pipenv run python artifacts/reset_db1.py
