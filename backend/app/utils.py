from app.models.models import UserRole

def get_user_role(role_str: str) -> UserRole:
    """
    Convierte cualquier string a un UserRole válido, normalizando a mayúsculas.
    Lanza ValueError si el rol no es válido.
    """
    if not isinstance(role_str, str):
        raise ValueError("El rol debe ser un string")
    role_normalized = role_str.strip().upper()
    # Permite tanto el valor como el nombre del Enum
    for r in UserRole:
        if role_normalized == r.value or role_normalized == r.name:
            return r
    raise ValueError(f"Rol inválido: {role_str}")
