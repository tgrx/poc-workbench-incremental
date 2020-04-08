from dynaconf import settings
from sqlalchemy import create_engine
from sqlalchemy import MetaData


def reset_db(db_url):
    engine = create_engine(db_url)
    meta = MetaData()
    meta.reflect(bind=engine)
    meta.drop_all(bind=engine)


if __name__ == "__main__":
    assert settings.DB0, "DB0 url is not configured"
    reset_db(settings.DB0)
