.PHONY: makemigrations install

VENV := $(shell pipenv --venv)

makemigrations:
	pipenv run alembic revision --autogenerate -m "AUTOGEN $(shell date)"

install:
	pipenv update --dev

format:
	pipenv run isort --virtual-env "${VENV}" --apply
	pipenv run black .
