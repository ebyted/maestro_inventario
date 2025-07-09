import logging
from logging.config import dictConfig

def setup_logging():
    logging_config = {
        "version": 1,
        "disable_existing_loggers": False,
        "formatters": {
            "default": {
                "format": "%(asctime)s [%(levelname)s] %(name)s: %(message)s",
            },
        },
        "handlers": {
            "console": {
                "class": "logging.StreamHandler",
                "formatter": "default",
            },
            "file": {
                "class": "logging.FileHandler",
                "filename": "/app/backend_logs/backend.log",
                "formatter": "default",
                "mode": "a",
            },
        },
        "root": {
            "handlers": ["console", "file"],
            "level": "INFO",
        },
    }
    dictConfig(logging_config)