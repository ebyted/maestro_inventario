import paramiko

# Parámetros de conexión
host = "168.231.67.221"
port = 22
username = "root"
password = "H6+&3w?gPXjY)T?wODKo"

def ssh_connect():
    try:
        # Crear cliente SSH
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        # Conexión al servidor
        print(f"Conectando a {host}...")
        client.connect(hostname=host, port=port, username=username, password=password)

        # Comando remoto (puedes cambiarlo)
        command = "docker-compose logs backend"
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
