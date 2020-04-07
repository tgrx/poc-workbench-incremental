.PHONY: makemigrations install

makemigrations:
	pipenv run alembic revision --autogenerate -m "AUTOGEN $(shell date)"

install:
	pipenv update --dev

format:
	pipenv run isort
	pipenv run black .
