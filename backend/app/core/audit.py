import logging
from datetime import datetime
import os

# Configuración básica de logging a archivo
log_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), '../../logs')
os.makedirs(log_dir, exist_ok=True)
log_file = os.path.join(log_dir, 'audit.log')

logging.basicConfig(
    filename=log_file,
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)

def log_action(user_id, action, detail=None):
    msg = f"user_id={user_id} action={action}"
    if detail:
        msg += f" detail={detail}"
    logging.info(msg)
