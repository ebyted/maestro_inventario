from typing import List
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.models import Unit
from app.schemas import Unit as UnitSchema, UnitCreate, UnitUpdate
from app.api.v1.endpoints.auth import get_current_user
from app.models import User

router = APIRouter()


@router.get("/", response_model=List[UnitSchema])
def read_units(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    units = db.query(Unit).offset(skip).limit(limit).all()
    return units


@router.post("/", response_model=UnitSchema)
def create_unit(
    unit: UnitCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    db_unit = Unit(**unit.dict())
    db.add(db_unit)
    db.commit()
    db.refresh(db_unit)
    return db_unit
