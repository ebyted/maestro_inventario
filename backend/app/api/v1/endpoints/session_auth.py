from fastapi import Request, Depends
from fastapi.responses import RedirectResponse
from app.models.models import User
from app.db.database import get_db
from sqlalchemy.orm import Session

def get_current_user_session(request: Request, db: Session = Depends(get_db)):
    user_id = request.cookies.get("user_id")
    if not user_id:
        return RedirectResponse(url="/login")
    user = db.query(User).filter(User.id == int(user_id)).first()
    if not user:
        return RedirectResponse(url="/login")
    return user
