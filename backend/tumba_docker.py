import paramiko

# Parámetros de conexión
host = "168.231.67.221"
port = 22
username = "root"
password = "Arkano-IA2025"

def ssh_connect():
    try:
        # Crear cliente SSH
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        # Conexión al servidor
        print(f"Conectando a {host}...")
        client.connect(hostname=host, port=port, username=username, password=password)

        # Comando remoto (puedes cambiarlo)
        #command = "docker rm a8ced9a74184"
        #command = "docker rm postgres:15

        
       # command = "docker rm -f mixpreparados-web-1"
       # command = "docker rm -f 8dadd70c3174"
        command = "docker exec -it sancho-distribuidora-app-vaekv1-db-1 psql -U postgres -d maestro_inventario -c 'SELECT * FROM users;'"  

       
       # command = " docker ps -a"
        #command = "sudo lsof -i :5432"
       # command = "sudo kill -9 805" 
        
# respaldar en la terminal: docker exec -t maestro-postgres pg_dump -U postgres -d maestro_inventario > respaldo.sql
# resaurar:  docker exec -it sancho-distribuidora-app-vaekv1-db-1 psql -U postgres -d maestro_inventario -f /respaldo.sql
# conectarse a la BD:  docker exec -it sancho-distribuidora-app-vaekv1-db-1 psql -U postgres -d maestro_inventario
# ejecutar SQL: docker exec -it sancho-distribuidora-app-vaekv1-db-1 psql -U postgres -d maestro_inventario -c "SELECT * FROM users;"

# $2b$12$mEGX8Kq6XfXrstNo1A0Ga.rm3ofvCi3HEHTEoFsWjQEZ2QhLnjaa.

        
        stdin, stdout, stderr = client.exec_command(command)

        # Mostrar resultados
        print("Salida del comando:")
        print(stdout.read().decode())

        client.close()
        print("Conexión cerrada.")

    except Exception as e:
        print("❌ Error durante la conexión SSH:")
        print(e)

if __name__ == "__main__":
    ssh_connect()
