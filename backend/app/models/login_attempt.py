from sqlalchemy import Column, Integer, String, DateTime, Boolean, func
from app.db.database import Base

class LoginAttempt(Base):
    __tablename__ = "login_attempts"
    id = Column(Integer, primary_key=True, index=True)
    user_email = Column(String(255), nullable=True)
    ip_address = Column(String(64), nullable=True)
    success = Column(Boolean, default=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
