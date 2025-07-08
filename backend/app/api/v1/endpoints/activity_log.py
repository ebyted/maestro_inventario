from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.models.activity_log import ActivityLog
from datetime import datetime

router = APIRouter()

@router.get("/", response_model=list)
def get_activity_logs(
    limit: int = 20,
    user_email: str = Query(None),
    action: str = Query(None),
    start: str = Query(None),
    end: str = Query(None),
    db: Session = Depends(get_db)
):
    query = db.query(ActivityLog)
    if user_email:
        query = query.filter(ActivityLog.user_email == user_email)
    if action:
        query = query.filter(ActivityLog.action == action)
    if start:
        try:
            start_dt = datetime.fromisoformat(start)
            query = query.filter(ActivityLog.created_at >= start_dt)
        except Exception:
            pass
    if end:
        try:
            end_dt = datetime.fromisoformat(end)
            query = query.filter(ActivityLog.created_at <= end_dt)
        except Exception:
            pass
    logs = query.order_by(ActivityLog.created_at.desc()).limit(limit).all()
    return [
        {
            "id": log.id,
            "user_email": log.user_email,
            "action": log.action,
            "details": log.details,
            "created_at": log.created_at.isoformat() if log.created_at else None
        }
        for log in logs
    ]
