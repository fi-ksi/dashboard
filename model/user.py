import datetime

from sqlalchemy import Column, Integer, String, Boolean, Enum, Text, text
from sqlalchemy.types import TIMESTAMP
from sqlalchemy.orm import relationship
from sqlalchemy.ext.hybrid import hybrid_property

from . import Base


class User(Base):
    __tablename__ = 'users'
    __table_args__ = {
        'mysql_engine': 'InnoDB',
        'mysql_charset': 'utf8mb4'
    }

    id = Column(Integer, primary_key=True)
    email = Column(String(50), nullable=False, unique=True)
    phone = Column(String(15))
    first_name = Column(String(50), nullable=False)
    nick_name = Column(String(50))
    last_name = Column(String(50), nullable=False)
    sex = Column(Enum('male', 'female', 'other'), nullable=False)
    password = Column(String(255), nullable=False)
    short_info = Column(Text, nullable=False)
    profile_picture = Column(String(255))
    role = Column(
        Enum('admin', 'org', 'participant', 'participant_hidden', 'tester'),
        nullable=False, default='participant', server_default='participant')
    enabled = Column(Boolean, nullable=False, default=True, server_default='1')
    registered = Column(TIMESTAMP, nullable=False,
                        default=datetime.datetime.utcnow,
                        server_default=text('CURRENT_TIMESTAMP'))

    @hybrid_property
    def name(self):
        return self.first_name + ' ' + self.last_name

    tasks = relationship('Task', primaryjoin='User.id == Task.author')
    evaluations = relationship('Evaluation',
                               primaryjoin='User.id == Evaluation.user')

    def __str__(self):
        return self.name

    __repr__ = __str__
