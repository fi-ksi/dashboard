from db import engine, session
from sqlalchemy.exc import SQLAlchemyError
from sqlalchemy import desc

import model
from db import session

fake_year_shim_enabled = False
fake_year_shim_id = 5  # 2020/21

def years():
    return session.query(model.Year).all()


year = None

try:
    year = session.query(model.Year).order_by(desc(model.Year.id)).first()
except SQLAlchemyError:
    session.rollback()
    raise


if fake_year_shim_enabled:
    try:
        year = years()[fake_year_shim_id]
    except:
        raise "Year probably out of range"
