# 🚀 INSTRUCCIONES DE EJECUCIÓN - Maestro Inventario

## 📦 Sistema de Inventario con Almacenes Específicos

### ✅ OBJETIVO COMPLETADO
✅ **Entrada de inventario** con almacén específico obligatorio  
✅ **Salida de inventario** con almacén específico obligatorio  
✅ **Ajustes de inventario** con almacén específico obligatorio  
✅ **Transferencias entre almacenes** con validación completa

---

## 🏃‍♂️ CÓMO EJECUTAR EL SISTEMA

### 1️⃣ BACKEND (API)

```powershell
# Ir al directorio backend
cd "c:\Users\dell\Documents\Proyectos\Maestro Inventario\maestro_inventario\backend"

# Activar entorno virtual
& "C:/Users/dell/Documents/Proyectos/Maestro Inventario/maestro_inventario/venv/Scripts/Activate.ps1"

# OPCIÓN A: Servidor de pruebas (recomendado para testing)
python simple_server.py

# OPCIÓN B: Servidor con uvicorn
uvicorn simple_server:app --host 127.0.0.1 --port 8000 --reload

# OPCIÓN C: Servidor completo (requiere BD configurada)
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

**📡 Backend estará disponible en:** http://localhost:8000  
**📚 Documentación automática:** http://localhost:8000/docs

### 2️⃣ FRONTEND (React Native)

```powershell
# Ir al directorio frontend
cd "c:\Users\dell\Documents\Proyectos\Maestro Inventario\maestro_inventario\frontend"

# Instalar dependencias (solo primera vez)
npm install

# Iniciar servidor de desarrollo
npm start

# O usar Expo directamente
npx expo start --web
```

**📱 Frontend estará disponible en:** http://localhost:19006 (web) o app móvil

---

## 🧪 PROBAR EL SISTEMA

### 📝 SCRIPT DE PRUEBAS AUTOMÁTICAS
```powershell
# Con el backend ejecutándose, probar endpoints:
cd backend
python test_inventory_endpoints.py
```

### 🖱️ PRUEBAS MANUALES EN FRONTEND

1. **Abrir aplicación** → Pantalla principal de Inventario
2. **Botón "Entrada de Inventario"** → Formulario de entrada
3. **Seleccionar Almacén** → Modal con lista de almacenes
4. **Seleccionar Producto** → Modal con productos disponibles
5. **Ingresar Cantidad** → Validación en tiempo real
6. **Registrar Movimiento** → Confirmación de éxito

**🔄 Repetir para:** Salida, Ajuste, Transferencia

---

## 📋 ENDPOINTS DISPONIBLES

### 🏢 Almacenes
- `GET /api/v1/inventory/warehouses` - Lista almacenes activos

### 📦 Productos
- `GET /api/v1/inventory/products` - Productos con stock
- `GET /api/v1/inventory/units` - Unidades de medida

### 📥📤 Movimientos
- `POST /api/v1/inventory/movements/entry` - Entrada con almacén
- `POST /api/v1/inventory/movements/exit` - Salida con almacén  
- `POST /api/v1/inventory/movements/adjustment` - Ajuste con almacén
- `POST /api/v1/inventory/movements/transfer` - Transferencia entre almacenes

---

## 🎯 EJEMPLOS DE REQUESTS

### Entrada de Inventario
```json
POST /api/v1/inventory/movements/entry
{
  "warehouse_id": 1,
  "product_variant_id": 1,
  "unit_id": 1,
  "quantity": 100,
  "cost_per_unit": 15.50,
  "batch_number": "LOTE001",
  "reason": "Compra a proveedor",
  "notes": "Ingreso inicial de producto"
}
```

### Transferencia entre Almacenes
```json
POST /api/v1/inventory/movements/transfer
{
  "source_warehouse_id": 1,
  "destination_warehouse_id": 2,
  "product_variant_id": 1,
  "unit_id": 1,
  "quantity": 25,
  "reason": "Rebalanceo de stock",
  "notes": "Transferencia por demanda"
}
```

---

## 🔐 VALIDACIONES IMPLEMENTADAS

### ✅ Backend
- `warehouse_id` es **obligatorio** en todos los movimientos
- Validación de existencia de almacén, producto y unidad
- Stock suficiente para salidas y transferencias
- Almacenes diferentes en transferencias

### ✅ Frontend  
- Selección obligatoria de almacén antes de enviar
- Validación de cantidad > 0
- Campos requeridos resaltados en rojo
- Mensajes de error informativos

---

## 📂 ARCHIVOS PRINCIPALES IMPLEMENTADOS

### Backend
- `app/schemas/inventory.py` - Esquemas específicos con almacén
- `app/api/v1/endpoints/inventory.py` - Endpoints con validaciones  
- `simple_server.py` - Servidor de pruebas funcional

### Frontend
- `screens/inventory/InventoryMovementFormScreen.tsx` - Formulario completo
- `screens/inventory/InventoryScreen.tsx` - Pantalla principal
- `navigation/AppNavigator.tsx` - Navegación configurada
- `i18n/locales/es.json` - Traducciones actualizadas

---

## ✨ CARACTERÍSTICAS DESTACADAS

🎯 **Almacén Siempre Especificado**: Todos los movimientos requieren y registran el almacén afectado  
🔒 **Validaciones Robustas**: Verificación de stock, existencia de datos, reglas de negocio  
🎨 **Interfaz Intuitiva**: Formularios fáciles de usar con validación en tiempo real  
🌐 **Multiidioma**: Totalmente traducido al español  
📱 **Responsive**: Optimizado para móviles y web  
🧪 **Testeable**: Scripts de prueba automatizados incluidos  

---

## 🎉 RESULTADO FINAL

**✅ OBJETIVO ALCANZADO**: El sistema ahora maneja completamente las entradas y salidas de inventario especificando **siempre** el almacén que será afectado.

**🚀 LISTO PARA USAR**: Sistema funcional, probado y preparado para integración en producción.

---

*📦 Maestro Inventario - Sistema Completo de Gestión Multi-Almacén* ✨
