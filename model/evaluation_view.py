import datetime
from sqlalchemy import (Column, Integer, Text, ForeignKey, text, DECIMAL,
                        Boolean, String, Enum)
from sqlalchemy.types import TIMESTAMP
from sqlalchemy.orm import relationship

from . import Base
from .user import User
from .module import Module, ModuleType
from .task import Task

class EvaluationParticipantsWithContext(Base):
    __tablename__ = 'evaluations_participants_with_context'
    __table_args__ = (
        {
            'mysql_engine': 'InnoDB',
            'mysql_charset': 'utf8mb4',
        })
    
    evaluation_id = Column("evaluationID", Integer, primary_key=True)
    user = Column(Integer, ForeignKey(User.id, ondelete='CASCADE'),
                  nullable=False, primary_key=True)
    module_id = Column("moduleID", Integer, ForeignKey(Module.id), nullable=False)
    module_name = Column("name", String, nullable=False)
    evaluator = Column(Integer, ForeignKey(User.id))
    points = Column(DECIMAL(precision=10, scale=1, asdecimal=False),
                    nullable=False, default=0)
    ok = Column(Boolean, nullable=False, default=False,
                server_default=text('FALSE'))
    cheat = Column(Boolean, nullable=False, default=False)
    full_report = Column(Text, nullable=False, default="")
    type = Column(Enum(ModuleType.GENERAL, ModuleType.PROGRAMMING,
                       ModuleType.QUIZ, ModuleType.SORTABLE, ModuleType.TEXT), nullable=False)
    time = Column(TIMESTAMP, default=datetime.datetime.utcnow,
                  server_default=text('CURRENT_TIMESTAMP'))
    task_id = Column("taskID", Integer, ForeignKey(Task.id), nullable=False)
    task_name = Column("title", String, nullable=False)
    wave_id = Column("waveID", Integer, nullable=False)
    year_id = Column("yearID", Integer, nullable=False)

    r_module = relationship(Module)
    r_evaluator = relationship(User, foreign_keys=[evaluator])
    r_user = relationship(User, foreign_keys=[user])
    r_task = relationship(Task)

    def __str__(self):
        shown_attrs = ("user", "module_id", "module_name", "points", "ok", "type", "task_id", "task_name")
        return f"EvaluationV({', '.join(attr + '=' + str(getattr(self, attr)) for attr in shown_attrs)})"
