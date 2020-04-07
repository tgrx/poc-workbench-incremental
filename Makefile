.PHONY: revision migrate install format reset_db1

VENV := $(shell pipenv --venv)
PYTHONPATH := $(shell pwd)

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
