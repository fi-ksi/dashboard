from sqlalchemy import Column, Integer, String, Enum, ForeignKey
from sqlalchemy.orm import relationship

from . import Base
from .task import Task


class PrerequisiteType:
    ATOMIC = 'ATOMIC'
    AND = 'AND'
    OR = 'OR'


class Prerequisite(Base):
    __tablename__ = 'prerequisities'
    __table_args__ = {
        'mysql_engine': 'InnoDB',
        'mysql_charset': 'utf8mb4'
    }

    id = Column(Integer, primary_key=True)
    type = Column(Enum(PrerequisiteType.ATOMIC, PrerequisiteType.AND,
                       PrerequisiteType.OR),
                  nullable=False, default=PrerequisiteType.ATOMIC,
                  server_default=PrerequisiteType.ATOMIC)
    parent = Column(Integer, ForeignKey(__tablename__ + '.id',
                                        ondelete='CASCADE'), nullable=True)
    task = Column(Integer, ForeignKey(Task.id), nullable=True)

    children = relationship(
        'Prerequisite',
        primaryjoin='Prerequisite.parent == Prerequisite.id'
    )
