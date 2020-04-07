import sqlalchemy as sa
from dynaconf import settings

print(
    f"""
{sa.__version__=}
{settings.DB0=}
{settings.DB1=}
{settings.ENV_FOR_DYNACONF=}
"""
)
