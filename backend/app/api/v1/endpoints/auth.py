from datetime import timedelta
from typing import Annotated
from fastapi import APIRouter, Depends, HTTPException, status, Request, Form
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy.orm import Session
from app.core.config import settings
from app.core.security import create_access_token, verify_password, verify_token, get_password_hash
from app.db.database import get_db
from app.models import User
from app.schemas import Token, UserLogin, UserCreate, User as UserSchema
from fastapi.responses import RedirectResponse, HTMLResponse
from fastapi.templating import Jinja2Templates
import os
from app.core.audit import log_action

router = APIRouter()
security = HTTPBearer()

# Setup de templates (igual que en admin_panel)
current_file = os.path.abspath(__file__)
endpoints_dir = os.path.dirname(current_file)
v1_dir = os.path.dirname(endpoints_dir)
api_dir = os.path.dirname(v1_dir)
app_dir = os.path.dirname(api_dir)
backend_dir = os.path.dirname(app_dir)
templates_dir = os.path.join(backend_dir, "templates")
templates = Jinja2Templates(directory=templates_dir)


def get_user_by_email(db: Session, email: str):
    return db.query(User).filter(User.email == email).first()


def authenticate_user(db: Session, email: str, password: str):
    user = get_user_by_email(db, email)
    if not user:
        return None
    if not verify_password(password, user.hashed_password):  # <-- aquí el cambio
        return None
    return user


def get_current_user(
    credentials: Annotated[HTTPAuthorizationCredentials, Depends(security)],
    db: Annotated[Session, Depends(get_db)]
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    
    email = verify_token(credentials.credentials)
    if email is None:
        raise credentials_exception
        
    user = get_user_by_email(db, email=email)
    if user is None:
        raise credentials_exception
    return user


@router.get("/login", response_class=HTMLResponse)
def login_form(request: Request):
    # Pasar variables de entorno al template
    return templates.TemplateResponse(
        "login.html",
        {
            "request": request,
            "error": None,
            "LOGIN_URL": os.getenv("LOGIN_URL", "/login"),
            "DB_PORT": os.getenv("DB_PORT", "5432"),
        }
    )


@router.post("/login", response_class=HTMLResponse)
def login_post(request: Request, email: str = Form(...), password: str = Form(...), db: Session = Depends(get_db)):
    user = authenticate_user(db, email, password)
    if not user:
        return templates.TemplateResponse(
            "login.html",
            {
                "request": request,
                "error": "Credenciales incorrectas",
                "LOGIN_URL": os.getenv("LOGIN_URL", "/login"),
                "DB_PORT": os.getenv("DB_PORT", "5432"),
            }
        )
    from fastapi.responses import RedirectResponse
    from starlette.status import HTTP_303_SEE_OTHER
    response = RedirectResponse(url="/redirect-dashboard", status_code=HTTP_303_SEE_OTHER)
    response.set_cookie(key="user_id", value=str(user.id), httponly=True)
    log_action(user.id, "login", detail=f"email={user.email}")
    return response


@router.get("/logout")
def logout():
    response = RedirectResponse(url="/login")
    response.delete_cookie("user_id")
    # No user_id disponible aquí, pero se puede registrar la acción
    log_action("unknown", "logout")
    return response


@router.get("/redirect-dashboard")
def redirect_dashboard(request: Request, db: Session = Depends(get_db)):
    user_id = request.cookies.get("user_id")
    if not user_id:
        return RedirectResponse(url="/login")
    user = db.query(User).filter(User.id == int(user_id)).first()
    if not user:
        return RedirectResponse(url="/login")
    # Redirigir según rol
    # Robust: handle missing or plural roles
    role = None
    if hasattr(user, "role") and user.role:
        role = user.role.value if hasattr(user.role, "value") else str(user.role)
    elif hasattr(user, "roles") and user.roles:
        # If roles is a list/relationship, get first or check for ADMIN
        if isinstance(user.roles, list):
            role = user.roles[0].value if hasattr(user.roles[0], "value") else str(user.roles[0])
    if role == "ADMIN":
        return RedirectResponse(url="/admin/executive-dashboard")
    elif role in ["ALMACENISTA", "CAPTURISTA"]:
        return RedirectResponse(url="/admin/warehouse-dashboard")
    else:
        return RedirectResponse(url="/admin/executive-dashboard")


@router.post("/login", response_model=Token)
def login(user_credentials: UserLogin, db: Session = Depends(get_db)):
    user = authenticate_user(db, user_credentials.email, user_credentials.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.email}, expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}


@router.post("/register", response_model=UserSchema)
def register(user_data: UserCreate, db: Session = Depends(get_db)):
    # Check if user already exists
    db_user = get_user_by_email(db, email=user_data.email)
    if db_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )
    
    # Create new user
    password_hash = get_password_hash(user_data.password)
    db_user = User(
        email=user_data.email,
        first_name=user_data.first_name,
        last_name=user_data.last_name,
        password_hash=password_hash,
        hashed_password=password_hash,  # <-- aquí el cambio
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user


@router.get("/me", response_model=UserSchema)
def read_users_me(current_user: User = Depends(get_current_user)):
    return current_user
