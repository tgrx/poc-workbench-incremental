from dynaconf import settings
from sqlalchemy import create_engine

engine0 = create_engine(settings.DB0, echo=True)
engine1 = create_engine(settings.DB1, echo=True)
