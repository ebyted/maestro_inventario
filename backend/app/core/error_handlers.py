from fastapi import Request
from fastapi.responses import HTMLResponse
from fastapi.templating import Jinja2Templates
from starlette.exceptions import HTTPException as StarletteHTTPException
import os

# Setup templates directory
current_file = os.path.abspath(__file__)
core_dir = os.path.dirname(current_file)
app_dir = os.path.dirname(core_dir)
backend_dir = os.path.dirname(app_dir)
templates_dir = os.path.join(backend_dir, "templates")
templates = Jinja2Templates(directory=templates_dir)

def add_error_handlers(app):
    @app.exception_handler(StarletteHTTPException)
    async def custom_http_exception_handler(request: Request, exc: StarletteHTTPException):
        status_code = exc.status_code
        if status_code == 401:
            return templates.TemplateResponse("error_401.html", {"request": request, "detail": exc.detail}, status_code=401)
        elif status_code == 403:
            return templates.TemplateResponse("error_403.html", {"request": request, "detail": exc.detail}, status_code=403)
        elif status_code == 404:
            return templates.TemplateResponse("error_404.html", {"request": request, "detail": exc.detail}, status_code=404)
        elif status_code == 500:
            return templates.TemplateResponse("error_500.html", {"request": request, "detail": exc.detail}, status_code=500)
        return HTMLResponse(str(exc.detail), status_code=status_code)

    @app.exception_handler(Exception)
    async def custom_exception_handler(request: Request, exc: Exception):
        return templates.TemplateResponse("error_500.html", {"request": request, "detail": str(exc)}, status_code=500)
