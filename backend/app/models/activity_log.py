from sqlalchemy import Column, Integer, String, DateTime, Text, func
from app.db.database import Base

class ActivityLog(Base):
    __tablename__ = "activity_log"
    id = Column(Integer, primary_key=True, index=True)
    user_email = Column(String(255), nullable=True)
    action = Column(String(100), nullable=False)
    details = Column(Text)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
