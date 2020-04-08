# coding: utf-8
from sqlalchemy import BigInteger
from sqlalchemy import Column
from sqlalchemy import DateTime
from sqlalchemy import Text
from sqlalchemy import text
from sqlalchemy.dialects.mysql import TINYINT
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()
metadata = Base.metadata


class NewTable(Base):
    __tablename__ = "new_table"

    id = Column(BigInteger, primary_key=True)
    _created = Column(
        DateTime, nullable=False, server_default=text("CURRENT_TIMESTAMP")
    )
    _updated = Column(DateTime)
    _deleted = Column(TINYINT(1), nullable=False, server_default=text("'0'"))
    data0 = Column(Text)
