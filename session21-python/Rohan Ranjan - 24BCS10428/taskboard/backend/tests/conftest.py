# Fix: test_api.py builds TestClient(app) without a `with` block, so FastAPI's
# startup hook (Base.metadata.create_all) never runs and the tasks table is
# missing in the SQLite test DB. Create the schema once per test session here.
import os

os.environ.setdefault("DATABASE_URL", "sqlite:///./test.db")

import pytest

from app.db import Base, engine


@pytest.fixture(scope="session", autouse=True)
def create_schema():
    Base.metadata.create_all(bind=engine)
    yield
    Base.metadata.drop_all(bind=engine)
