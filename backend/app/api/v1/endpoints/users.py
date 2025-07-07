from typing import List
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.models import User, UserRole
from app.schemas import User as UserSchema, UserRole as UserRoleSchema, UserRoleCreate
from app.api.v1.endpoints.auth import get_current_user

router = APIRouter()


@router.get("/", response_model=List[UserSchema])
def read_users(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    users = db.query(User).filter(User.is_active == True).offset(skip).limit(limit).all()
    return users


@router.get("/{user_id}/roles", response_model=List[UserRoleSchema])
def read_user_roles(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    roles = db.query(UserRole).filter(UserRole.user_id == user_id).all()
    return roles


@router.post("/{user_id}/roles", response_model=UserRoleSchema)
def create_user_role(
    user_id: int,
    role_data: UserRoleCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    role_dict = role_data.dict()
    role_dict['user_id'] = user_id
    
    db_role = UserRole(**role_dict)
    db.add(db_role)
    db.commit()
    db.refresh(db_role)
    return db_role
