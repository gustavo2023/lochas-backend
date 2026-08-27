from collections.abc import AsyncGenerator

from sqlalchemy.ext.asyncio import AsyncSession

from app.db import AsyncSessionLocal


async def get_db() -> AsyncGenerator[AsyncSession]:
    """
    Dependency to create an AsyncSession.
    It closes the session once the request is finished.
    """
    async with AsyncSessionLocal() as session:
        yield session
