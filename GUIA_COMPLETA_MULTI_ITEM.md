# Guía Completa del Sistema Multi-Item - Maestro Inventario

## Resumen del Sistema

El sistema Maestro Inventario ahora soporta operaciones de inventario multi-item (múltiples productos en una sola operación) tanto en backend como frontend. Esta funcionalidad permite procesar entradas, salidas y ajustes de inventario con varios productos de manera eficiente.

## Arquitectura Implementada

### Backend (FastAPI + Python)

#### 1. Esquemas Pydantic (`backend/app/schemas/inventory.py`)

**Esquemas Multi-Item Implementados:**

- `InventoryEntryMultiCreate`: Entrada con múltiples productos
- `InventoryExitMultiCreate`: Salida con múltiples productos  
- `InventoryAdjustmentMultiCreate`: Ajuste con múltiples productos
- `InventoryMovementMultiResponse`: Respuesta unificada para operaciones multi-item
- `InventoryBatchOperationSummary`: Resumen de operaciones en lote

**Características clave:**
- Validación automática con Pydantic
- Soporte para información específica por tipo de movimiento
- Campos opcionales para flexibilidad
- Validaciones personalizadas (ej: almacenes diferentes en transferencias)

#### 2. Endpoints API (`backend/app/api/v1/endpoints/inventory.py`)

**Endpoints Multi-Item:**

```
POST /api/v1/inventory/entries/multi
POST /api/v1/inventory/exits/multi  
POST /api/v1/inventory/adjustments/multi
GET /api/v1/inventory/movements/multi/{movement_id}
```

**Funcionalidades:**
- Procesamiento transaccional (todo o nada)
- Validación de stock disponible para salidas
- Creación automática de registros de inventario
- Manejo de errores con rollback automático
- Respuestas detalladas con información de cada item

#### 3. Scripts de Prueba

**`backend/test_multi_item_endpoints.py`:**
- Pruebas automatizadas para todos los endpoints multi-item
- Datos de prueba realistas
- Validación de respuestas
- Manejo de errores

### Frontend (React Native + TypeScript)

#### 1. Pantalla Multi-Item (`frontend/src/screens/inventory/InventoryMultiItemFormScreen.tsx`)

**Características:**
- Interfaz intuitiva para múltiples productos
- Validación en tiempo real
- Formularios dinámicos (agregar/quitar productos)
- Selección modal para productos, unidades, almacenes
- Campos específicos por tipo de operación
- Manejo de errores y estados de carga

#### 2. Navegación Actualizada

**Rutas agregadas:**
- `InventoryMultiItemForm`: Formulario multi-item
- Integración con el stack de inventario existente

#### 3. Traducciones Completas

**Textos en español:**
- Títulos y etiquetas de formularios
- Mensajes de error y validación
- Placeholders y ayudas contextuales

## Tipos de Operaciones Multi-Item

### 1. Entrada Multi-Producto

**Casos de uso:**
- Recepción de órdenes de compra con múltiples productos
- Entrada de mercancía de diferentes proveedores
- Recepción de devoluciones con varios artículos

**Campos específicos:**
- Proveedor (opcional)
- Costo por unidad por producto
- Números de lote individuales
- Fechas de vencimiento

### 2. Salida Multi-Producto

**Casos de uso:**
- Ventas con múltiples productos
- Transferencias entre almacenes
- Despachos de órdenes de venta

**Campos específicos:**
- Cliente (opcional)
- Precio de venta por producto
- Almacén destino para transferencias

### 3. Ajuste Multi-Producto

**Casos de uso:**
- Inventarios físicos con múltiples discrepancias
- Correcciones de stock después de auditorías
- Ajustes por mermas o pérdidas múltiples

**Campos específicos:**
- Cantidad de ajuste (positiva o negativa)
- Razón específica por producto
- Ajuste de costo opcional

## Estructura de Datos

### Esquema de Entrada Multi-Item

```json
{
  "warehouse_id": 1,
  "supplier_id": 1,
  "reference_number": "ENTRY-MULTI-20250705-143022",
  "reason": "Compra de mercancía múltiple",
  "notes": "Entrada de prueba con múltiples productos",
  "items": [
    {
      "product_variant_id": 1,
      "unit_id": 1,
      "quantity": 50.0,
      "cost_per_unit": 15.50,
      "batch_number": "BATCH-001",
      "notes": "Producto A - Lote 001"
    },
    {
      "product_variant_id": 2,
      "unit_id": 1,
      "quantity": 30.0,
      "cost_per_unit": 25.75,
      "expiry_date": "2026-07-05T14:30:22",
      "batch_number": "BATCH-002",
      "notes": "Producto B - Lote 002"
    }
  ]
}
```

### Respuesta Unificada

```json
{
  "id": 123,
  "warehouse_id": 1,
  "movement_type": "entry",
  "reference_number": "ENTRY-MULTI-20250705-143022",
  "supplier_id": 1,
  "reason": "Compra de mercancía múltiple",
  "notes": "Entrada de prueba con múltiples productos",
  "total_items": 2,
  "total_value": 1547.50,
  "status": "completed",
  "items": [
    {
      "id": 456,
      "product_variant_id": 1,
      "unit_id": 1,
      "quantity": 50.0,
      "cost_per_unit": 15.50,
      "batch_number": "BATCH-001",
      "notes": "Producto A - Lote 001",
      "created_at": "2025-07-05T14:30:22"
    }
  ],
  "created_at": "2025-07-05T14:30:22",
  "created_by": 1
}
```

## Instrucciones de Ejecución

### 1. Configuración del Backend

```bash
# Navegar al directorio backend
cd backend

# Activar entorno virtual (si existe)
venv\Scripts\activate

# Instalar dependencias
pip install -r requirements.txt

# Iniciar servidor
python main.py
```

### 2. Configuración del Frontend

```bash
# Navegar al directorio frontend
cd frontend

# Instalar dependencias
npm install

# Iniciar servidor de desarrollo
npm start
```

### 3. Pruebas de Endpoints

```bash
# Ejecutar pruebas multi-item
cd backend
python test_multi_item_endpoints.py
```

### 4. Uso en la Aplicación

1. **Abrir la aplicación móvil**
2. **Navegar a Inventario**
3. **Seleccionar operación multi-item:**
   - "Entrada Multi-Producto"
   - "Salida Multi-Producto" 
   - "Ajuste Multi-Producto"
4. **Llenar formulario:**
   - Seleccionar almacén
   - Agregar productos con botón "+"
   - Completar datos específicos por producto
   - Agregar información general
5. **Guardar movimiento**

## Validaciones Implementadas

### Backend
- Validación de existencia de almacenes, productos y unidades
- Verificación de stock disponible para salidas
- Validación de datos numéricos
- Transacciones atómicas (rollback en caso de error)

### Frontend
- Validación de campos obligatorios
- Verificación de cantidades positivas
- Validación de almacenes diferentes en transferencias
- Validación de al menos un producto

## Manejo de Errores

### Errores del Backend
- Respuestas HTTP detalladas
- Información específica por item fallido
- Rollback automático en transacciones

### Errores del Frontend
- Alertas amigables al usuario
- Validación en tiempo real
- Estados de carga durante envío

## Casos de Prueba

### 1. Entrada Multi-Item Exitosa
- 3 productos diferentes
- Costos y lotes variados
- Validación de stock actualizado

### 2. Salida Multi-Item con Validación de Stock
- Verificación de stock insuficiente
- Manejo de errores parciales
- Validación de reservas

### 3. Ajuste Multi-Item Mixto
- Incrementos y decrementos
- Validación de stock negativo
- Ajustes de costo

## Beneficios del Sistema Multi-Item

1. **Eficiencia Operativa:**
   - Procesamiento de múltiples productos en una operación
   - Reducción de tiempo en capturas repetitivas
   - Mejor trazabilidad con números de referencia únicos

2. **Integridad de Datos:**
   - Transacciones atómicas
   - Validaciones exhaustivas
   - Manejo consistente de errores

3. **Experiencia de Usuario:**
   - Interface intuitiva
   - Validación en tiempo real
   - Feedback inmediato de errores

4. **Escalabilidad:**
   - Soporte para grandes volúmenes de productos
   - Arquitectura modular y extensible
   - APIs bien documentadas

## Próximos Pasos

1. **Integración con API Real:**
   - Reemplazar datos mock con llamadas a API
   - Implementar autenticación JWT
   - Configurar manejo de errores de red

2. **Funcionalidades Adicionales:**
   - Búsqueda de productos con código de barras
   - Importación de movimientos desde archivos
   - Reportes de movimientos multi-item

3. **Optimizaciones:**
   - Caché de productos y unidades
   - Optimización de consultas de base de datos
   - Validación de stock en tiempo real

4. **Pruebas:**
   - Pruebas unitarias completas
   - Pruebas de integración end-to-end
   - Pruebas de rendimiento con grandes volúmenes

## Conclusión

El sistema multi-item de Maestro Inventario proporciona una solución robusta y completa para el manejo de inventarios con múltiples productos. La implementación incluye tanto backend como frontend con validaciones exhaustivas, manejo de errores robusto y una experiencia de usuario intuitiva.

La arquitectura modular permite fácil extensión y mantenimiento, mientras que las pruebas automatizadas garantizan la calidad y confiabilidad del sistema.
