"""
Script para extraer y analizar categorías y marcas únicas de un archivo CSV
Genera un reporte detallado sin modificar la base de datos
"""

import csv
import json
from datetime import datetime
from typing import Set, Dict, List
from collections import Counter
import os

class CSVCatalogAnalyzer:
    def __init__(self, csv_file_path: str):
        self.csv_file_path = csv_file_path
        self.categories = set()
        self.brands = set()
        self.category_counts = Counter()
        self.brand_counts = Counter()
        self.row_count = 0
        
    def detect_delimiter(self) -> str:
        """Detectar el delimitador del CSV automáticamente"""
        with open(self.csv_file_path, 'r', encoding='utf-8-sig') as file:
            sample = file.read(1024)
            file.seek(0)
            
            # Primero verificar punto y coma que es más común en este contexto
            delimiters = [';', ',', '\t', '|']
            for delimiter in delimiters:
                # Contar cuántas veces aparece en las primeras líneas
                lines = sample.split('\n')[:3]  # Revisar las primeras 3 líneas
                total_count = sum(line.count(delimiter) for line in lines if line.strip())
                if total_count >= 3:  # Al menos 3 ocurrencias
                    print(f"Delimitador detectado: '{delimiter}' (ocurrencias: {total_count})")
                    return delimiter
                    
        print("No se pudo detectar el delimitador, usando ';' por defecto")
        return ';'
    
    def analyze_csv(self) -> Dict:
        """Analizar el CSV y extraer categorías y marcas"""
        delimiter = self.detect_delimiter()
        
        with open(self.csv_file_path, 'r', encoding='utf-8-sig') as file:
            reader = csv.DictReader(file, delimiter=delimiter)
            headers = reader.fieldnames
            
            print(f"Columnas encontradas: {headers}")
            
            # Buscar columnas de categoría y marca
            category_columns = ['CATEGORIA', 'Categoria', 'categoria', 'Category', 'category']
            brand_columns = ['Marca', 'marca', 'Brand', 'brand', 'MARCA']
            
            category_col = None
            brand_col = None
            
            for col in headers:
                clean_col = col.strip().lstrip('\ufeff')
                if clean_col in category_columns:
                    category_col = col
                if clean_col in brand_columns:
                    brand_col = col
            
            print(f"Columna de categoría: {category_col}")
            print(f"Columna de marca: {brand_col}")
            
            for row in reader:
                self.row_count += 1
                
                # Procesar categoría
                if category_col and row.get(category_col):
                    category = row[category_col].strip()
                    if category and category.lower() not in ['', 'n/a', 'na', 'null', 'none']:
                        self.categories.add(category)
                        self.category_counts[category] += 1
                
                # Procesar marca
                if brand_col and row.get(brand_col):
                    brand = row[brand_col].strip()
                    if brand and brand.lower() not in ['', 'n/a', 'na', 'null', 'none']:
                        self.brands.add(brand)
                        self.brand_counts[brand] += 1
                
                if self.row_count % 500 == 0:
                    print(f"Procesadas {self.row_count} filas...")
        
        return {
            'total_rows': self.row_count,
            'unique_categories': len(self.categories),
            'unique_brands': len(self.brands),
            'categories': sorted(list(self.categories)),
            'brands': sorted(list(self.brands)),
            'category_counts': dict(self.category_counts.most_common()),
            'brand_counts': dict(self.brand_counts.most_common())
        }
    
    def generate_report(self, results: Dict) -> str:
        """Generar reporte en formato texto"""
        report = []
        report.append("="*70)
        report.append("REPORTE DE ANÁLISIS DE CATEGORÍAS Y MARCAS EN CSV")
        report.append("="*70)
        report.append(f"Archivo analizado: {self.csv_file_path}")
        report.append(f"Fecha de análisis: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        report.append(f"Total de filas procesadas: {results['total_rows']}")
        report.append(f"Categorías únicas encontradas: {results['unique_categories']}")
        report.append(f"Marcas únicas encontradas: {results['unique_brands']}")
        report.append("")
        
        # Top 10 categorías más frecuentes
        report.append("TOP 10 CATEGORÍAS MÁS FRECUENTES:")
        report.append("-" * 40)
        for i, (category, count) in enumerate(list(results['category_counts'].items())[:10], 1):
            report.append(f"{i:2}. {category:<30} ({count} productos)")
        report.append("")
        
        # Top 10 marcas más frecuentes
        report.append("TOP 10 MARCAS MÁS FRECUENTES:")
        report.append("-" * 40)
        for i, (brand, count) in enumerate(list(results['brand_counts'].items())[:10], 1):
            report.append(f"{i:2}. {brand:<30} ({count} productos)")
        report.append("")
        
        # Todas las categorías
        report.append("TODAS LAS CATEGORÍAS ENCONTRADAS:")
        report.append("-" * 40)
        for i, category in enumerate(results['categories'], 1):
            count = results['category_counts'][category]
            report.append(f"{i:3}. {category} ({count} productos)")
        report.append("")
        
        # Todas las marcas
        report.append("TODAS LAS MARCAS ENCONTRADAS:")
        report.append("-" * 40)
        for i, brand in enumerate(results['brands'], 1):
            count = results['brand_counts'][brand]
            report.append(f"{i:3}. {brand} ({count} productos)")
        
        report.append("="*70)
        
        return "\n".join(report)
    
    def save_results(self, results: Dict):
        """Guardar resultados en archivos"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # Guardar como JSON
        json_filename = f"csv_catalog_analysis_{timestamp}.json"
        with open(json_filename, 'w', encoding='utf-8') as f:
            json.dump(results, f, indent=2, ensure_ascii=False)
        
        # Guardar como texto
        txt_filename = f"csv_catalog_report_{timestamp}.txt"
        report = self.generate_report(results)
        with open(txt_filename, 'w', encoding='utf-8') as f:
            f.write(report)
        
        # Guardar listas simples para importación
        categories_filename = f"categories_list_{timestamp}.txt"
        with open(categories_filename, 'w', encoding='utf-8') as f:
            for category in sorted(results['categories']):
                f.write(f"{category}\n")
        
        brands_filename = f"brands_list_{timestamp}.txt"
        with open(brands_filename, 'w', encoding='utf-8') as f:
            for brand in sorted(results['brands']):
                f.write(f"{brand}\n")
        
        print(f"\\nArchivos generados:")
        print(f"  - Reporte completo (JSON): {json_filename}")
        print(f"  - Reporte legible (TXT): {txt_filename}")
        print(f"  - Lista de categorías: {categories_filename}")
        print(f"  - Lista de marcas: {brands_filename}")
        
        return json_filename, txt_filename, categories_filename, brands_filename


def main():
    """Función principal"""
    import sys
    
    if len(sys.argv) != 2:
        print("Uso: python analyze_csv_catalog.py <archivo_csv>")
        print("Ejemplo: python analyze_csv_catalog.py productos.csv")
        return
    
    csv_file = sys.argv[1]
    
    if not os.path.exists(csv_file):
        print(f"Error: No se encontró el archivo {csv_file}")
        return
    
    print(f"Analizando archivo CSV: {csv_file}")
    print("="*50)
    
    analyzer = CSVCatalogAnalyzer(csv_file)
    results = analyzer.analyze_csv()
    
    print(f"\\nAnálisis completado:")
    print(f"  - Filas procesadas: {results['total_rows']}")
    print(f"  - Categorías únicas: {results['unique_categories']}")
    print(f"  - Marcas únicas: {results['unique_brands']}")
    
    # Mostrar vista previa del reporte
    print("\\n" + analyzer.generate_report(results))
    
    # Guardar archivos
    analyzer.save_results(results)


if __name__ == "__main__":
    main()
