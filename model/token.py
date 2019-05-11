import datetime

from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Interval
from sqlalchemy.ext.hybrid import hybrid_property, hybrid_method

from . import Base
from .user import User


class Token(Base):
    __tablename__ = 'oauth2_tokens'
    __table_args__ = {
        'mysql_engine': 'InnoDB',
        'mysql_charset': 'utf8mb4'
    }

    access_token = Column(String(150), primary_key=True)
    user = Column(Integer, ForeignKey(User.id))
    expire = Column(DateTime, default=datetime.timedelta(hours=1))
    refresh_token = Column(String(150))
    granted = Column(DateTime, default=datetime.datetime.utcnow)
