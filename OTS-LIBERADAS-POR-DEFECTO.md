# 🎯 OTs Liberadas por Defecto - Versión 1.9

## 📊 Resumen

A partir de la versión **1.9**, la base de datos incluye **6 órdenes de trabajo (OTs) técnicas liberadas** por defecto, listas para ser asignadas al sistema de itinerarios de cuadrillas.

---

## ✅ OTs Liberadas (empleado_id = NULL)

### Del archivo `04-datos-prueba.sql` (3 OTs):

| OT ID | Estado | Socio | Dirección | Observaciones |
|-------|--------|-------|-----------|---------------|
| 4 | PENDIENTE | Miguel Ángel Sánchez | Alsina 321 | Disponible para asignación a itinerario |
| 5 | PENDIENTE | José Luis Morales | Tucumán 987 | Disponible para asignación a itinerario |
| 7 | PENDIENTE | Ana Sofía Rodríguez | Mitre 123 | Disponible para asignación a itinerario |

### Del archivo `06-reclamos-pedro.sql` (3 OTs):

| OT ID | Estado | Descripción del Reclamo | Observaciones |
|-------|--------|-------------------------|---------------|
| 14 | PENDIENTE | Corte de luz intermitente cada 2 horas en zona norte | Disponible para asignación a itinerario de cuadrilla |
| 15 | PENDIENTE | Cableado antiguo requiere inspección preventiva | Disponible para asignación a itinerario de cuadrilla |
| 16 | PENDIENTE | Solicitud de cambio de ubicación de medidor por obra | Disponible para asignación a itinerario de cuadrilla |

---

## 📋 OTs Asignadas Directamente (empleado_id ≠ NULL)

El resto de las **24 OTs** vienen con asignación directa a operarios específicos.

---

## 🎯 Uso en la Aplicación Web

### Al iniciar la aplicación:

**Ruta:** `http://localhost:3002/dashboard/admin/itinerario`

**Resultado esperado:**
- ✅ Botón: **"Solo Disponibles (6)"**
- ✅ Lista de 6 OTs técnicas sin asignar
- ✅ Posibilidad de asignarlas a cuadrillas inmediatamente

---

## 🔍 Verificar OTs Liberadas

### Consulta SQL:

```sql
SELECT 
    ot.ot_id,
    ot.estado,
    s.nombre || ' ' || s.apellido as socio,
    c.direccion,
    ot.observaciones
FROM orden_trabajo ot
JOIN reclamo r ON ot.reclamo_id = r.reclamo_id
JOIN cuenta c ON r.cuenta_id = c.cuenta_id
JOIN socio s ON c.socio_id = s.socio_id
JOIN detalle_tipo_reclamo dtr ON r.detalle_id = dtr.detalle_id
JOIN tipo_reclamo tr ON dtr.tipo_id = tr.tipo_id
WHERE tr.nombre = 'TECNICO'
    AND ot.empleado_id IS NULL
ORDER BY ot.ot_id;
```

### Desde Docker:

```bash
docker exec -i cooperativa-db psql -U coop_user -d cooperativa_ugarte_db << 'EOF'
SELECT 
    '--- OTs LIBERADAS POR DEFECTO ---' as info;
SELECT 
    COUNT(*) FILTER (WHERE empleado_id IS NULL) as liberadas,
    COUNT(*) FILTER (WHERE empleado_id IS NOT NULL) as asignadas,
    COUNT(*) as total
FROM orden_trabajo;
EOF
```

**Output esperado:**
```
 liberadas | asignadas | total 
-----------+-----------+-------
         6 |        24 |    30
```

---

## 🛠️ Si Necesitas Más OTs Liberadas

### Opción 1: Usar Scripts de Itinerarios

```bash
# Liberar 8 OTs adicionales (total: 14)
docker exec -i cooperativa-db psql -U coop_user -d cooperativa_ugarte_db \
  < scripts/07-preparar-itinerarios.sql
```

### Opción 2: Liberar Manualmente

```sql
-- Liberar una OT específica
UPDATE orden_trabajo
SET 
    empleado_id = NULL,
    observaciones = COALESCE(observaciones || ' ', '') || '[Liberada para itinerario]',
    updated_at = CURRENT_TIMESTAMP
WHERE ot_id = X;  -- Reemplazar X con el ID deseado
```

---

## 🔄 Asignar OTs a Itinerarios

### Opción 1: Usar Script Automático

```bash
# Asignar las 6 OTs disponibles a cuadrillas
docker exec -i cooperativa-db psql -U coop_user -d cooperativa_ugarte_db \
  < scripts/08-asignar-ots-a-itinerarios.sql
```

### Opción 2: Asignar Manualmente

```sql
-- Asignar a itinerario de cuadrilla 1 para hoy
UPDATE orden_trabajo
SET 
    observaciones = COALESCE(observaciones || ' ', '') || '[ITINERARIO: 2025-10-10 1]',
    updated_at = CURRENT_TIMESTAMP
WHERE ot_id = 4;  -- O cualquier otro ID de OT liberada
```

---

## 📚 Flujo Completo del Sistema

```
┌─────────────────────────────────────────┐
│  1️⃣  Base de Datos Inicial             │
│     - 30 OTs totales                    │
│     - 6 OTs liberadas (empleado_id NULL)│
│     - 24 OTs asignadas                  │
└──────────────┬──────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────┐
│  2️⃣  Aplicación Web                    │
│     - Muestra "Solo Disponibles (6)"    │
│     - Admin puede asignar a cuadrillas  │
└──────────────┬──────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────┐
│  3️⃣  Asignar a Cuadrilla               │
│     - Se agrega [ITINERARIO: fecha ID]  │
│     - OT visible para operarios         │
└──────────────┬──────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────┐
│  4️⃣  Operario Toma OT                  │
│     - Actualiza empleado_id             │
│     - OT asignada al operario           │
└──────────────┬──────────────────────────┘
               │
               ↓
┌─────────────────────────────────────────┐
│  5️⃣  Operario Completa Trabajo         │
│     - Cambia estado a COMPLETADA        │
│     - Trabajo finalizado                │
└─────────────────────────────────────────┘
```

---

## ❓ Preguntas Frecuentes

### ¿Por qué 6 OTs liberadas?
- Suficientes para probar el sistema de itinerarios
- Proporción realista: 20% liberadas, 80% asignadas
- Permite demostrar la funcionalidad sin saturar

### ¿Puedo cambiar qué OTs están liberadas?
Sí, modifica los archivos:
- `scripts/04-datos-prueba.sql`
- `scripts/06-reclamos-pedro.sql`

Luego reconstruye la imagen Docker.

### ¿Las OTs liberadas afectan la estructura?
No, solo modifican datos:
- `empleado_id = NULL` (en lugar de un ID)
- `observaciones` con texto informativo

### ¿Qué pasa si libero todas las OTs?
Funcionará correctamente, pero no tendrás ejemplos de asignación directa. Se recomienda mantener un balance.

---

## 📝 Notas Técnicas

### Cambios en 04-datos-prueba.sql:
```sql
-- ANTES (v1.8):
(4, 9, '2024-10-03 15:00:00', 'PENDIENTE', 'Mitre 123'),

-- DESPUÉS (v1.9):
(4, NULL, '2024-10-03 15:00:00', 'PENDIENTE', 'Mitre 123', 'Disponible para asignación a itinerario'),
```

### Cambios en 06-reclamos-pedro.sql:
```sql
-- ANTES (v1.8): Todas asignadas a Pedro
INSERT INTO orden_trabajo (reclamo_id, empleado_id, ...)
SELECT r.reclamo_id, 1, ...  -- empleado_id = 1 (Pedro)

-- DESPUÉS (v1.9): Divididas
-- 3 asignadas a Pedro
INSERT INTO orden_trabajo (reclamo_id, empleado_id, ...)
SELECT r.reclamo_id, 1, ...

-- 3 liberadas para itinerarios
INSERT INTO orden_trabajo (reclamo_id, empleado_id, ...)
SELECT r.reclamo_id, NULL, ...  -- empleado_id = NULL
```

---

**Versión:** 1.9  
**Fecha:** 2025-10-10  
**Proyecto:** Cooperativa Eléctrica "Gobernador Ugarte"
