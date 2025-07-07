"""
Script simple para leer productos.csv y mostrar su contenido
"""

import csv
import os

def read_productos_csv_simple():
    """Lee el archivo productos.csv y muestra información básica"""
    print("=== ANÁLISIS DEL ARCHIVO productos.csv ===\n")
    
    try:
        if not os.path.exists('productos.csv'):
            print("❌ El archivo productos.csv no se encuentra en el directorio actual")
            print(f"Directorio actual: {os.getcwd()}")
            return
        
        # Contar líneas totales
        with open('productos.csv', 'r', encoding='utf-8') as file:
            total_lines = sum(1 for line in file)
        print(f"📊 Total de líneas en el archivo: {total_lines}")
        
        # Leer las primeras líneas para análisis
        with open('productos.csv', 'r', encoding='utf-8') as file:
            csv_reader = csv.reader(file, delimiter=';')
            
            # Leer header
            header = next(csv_reader)
            print(f"📋 Columnas detectadas ({len(header)}):")
            for i, col in enumerate(header):
                print(f"  {i+1}. {col}")
            
            print(f"\n📝 Primeras 10 filas de productos:")
            print("-" * 80)
            
            productos_procesados = 0
            productos_validos = 0
            
            for row_num, row in enumerate(csv_reader, start=2):
                productos_procesados += 1
                
                if productos_procesados <= 10:
                    # Mostrar información de las primeras 10 filas
                    producto_nombre = row[0].strip() if len(row) > 0 and row[0] else "SIN NOMBRE"
                    marca = row[2].strip() if len(row) > 2 and row[2] else "SIN MARCA"
                    categoria = row[3].strip() if len(row) > 3 and row[3] else "SIN CATEGORÍA"
                    
                    print(f"  {row_num:3d}. {producto_nombre[:50]:<50} | {marca[:15]:<15} | {categoria[:20]}")
                
                # Contar productos válidos (con nombre)
                if len(row) > 0 and row[0] and row[0].strip():
                    productos_validos += 1
                
                # Salir después de procesar todas las filas
                if productos_procesados >= total_lines - 1:  # -1 porque excluimos el header
                    break
            
            print("-" * 80)
            print(f"\n📈 RESUMEN:")
            print(f"  • Total de líneas: {total_lines}")
            print(f"  • Productos procesados: {productos_procesados}")
            print(f"  • Productos con nombre válido: {productos_validos}")
            print(f"  • Productos sin nombre: {productos_procesados - productos_validos}")
            
            # Análisis de categorías únicas
            print(f"\n🏷️  ANÁLISIS DE CATEGORÍAS:")
            categorias = set()
            marcas = set()
            
            # Reiniciar lectura para análisis completo
            file.seek(0)
            next(csv_reader)  # Skip header
            
            for row in csv_reader:
                if len(row) > 3 and row[3] and row[3].strip():
                    categorias.add(row[3].strip())
                if len(row) > 2 and row[2] and row[2].strip():
                    marcas.add(row[2].strip())
            
            print(f"  • Categorías únicas encontradas: {len(categorias)}")
            print(f"  • Marcas únicas encontradas: {len(marcas)}")
            
            # Mostrar algunas categorías
            if categorias:
                print(f"  • Primeras 10 categorías:")
                for i, cat in enumerate(sorted(list(categorias))[:10]):
                    print(f"    - {cat}")
                if len(categorias) > 10:
                    print(f"    ... y {len(categorias) - 10} más")
            
            print(f"\n✅ Análisis completado exitosamente!")
            print(f"🎯 El archivo está listo para ser importado a la base de datos.")
    
    except Exception as e:
        print(f"❌ Error al leer el archivo: {e}")

if __name__ == "__main__":
    read_productos_csv_simple()
