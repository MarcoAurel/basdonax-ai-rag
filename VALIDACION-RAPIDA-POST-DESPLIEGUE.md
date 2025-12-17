# 🧪 VALIDACIÓN RÁPIDA POST-DESPLIEGUE - Opción B

**Objetivo:** Verificar que el prompt ultra-restrictivo y eliminación de hardcodeo funcionan correctamente.

**Tiempo estimado:** 2-3 minutos

---

## ✅ TEST 1: Anti-contaminación (CRÍTICO)

**Pregunta:**
```
¿Cómo soluciono errores de sistema en Windows?
```

**✅ RESPUESTA CORRECTA debe:**
- Mencionar: DISM, SFC, comandos de Windows
- NO mencionar: Wigos, UltraVNC, Office, o cualquier aplicación específica

**❌ RESPUESTA INCORRECTA si:**
- Menciona "soporte de Wigos"
- Menciona "contacta con X"
- Hace referencia a aplicaciones específicas

---

## ✅ TEST 2: Herramientas correctas

**Pregunta:**
```
¿Qué herramientas puedo usar para monitoreo remoto de equipos?
```

**✅ RESPUESTA CORRECTA debe:**
- Mencionar: UltraVNC (o herramientas de monitoreo)
- Ser breve y general

**❌ RESPUESTA INCORRECTA si:**
- Menciona solo PsExec (que NO es de monitoreo)
- No menciona herramientas de monitoreo

---

## ✅ TEST 3: Pregunta específica Wigos

**Pregunta:**
```
Tengo un error en Wigos que dice "No se puede convertir el objeto COM". ¿Qué hago?
```

**✅ RESPUESTA CORRECTA debe:**
- Mencionar: Reparar Office (rápida/en línea)
- Ser específica para Wigos
- Mencionar componentes COM

**❌ RESPUESTA INCORRECTA si:**
- Da soluciones genéricas de Windows
- No menciona Office o COM

---

## ✅ TEST 4: Comandos DISM

**Pregunta:**
```
¿Cuál es la secuencia correcta de comandos DISM para verificar la salud del sistema en Windows?
```

**✅ RESPUESTA CORRECTA debe:**
- Mencionar orden: CheckHealth → ScanHealth → RestoreHealth
- NO mencionar aplicaciones específicas

**❌ RESPUESTA INCORRECTA si:**
- Orden incorrecto
- Menciona Wigos u otras apps

---

## ✅ TEST 5: Configuración visible (Verificar logs)

**Acción:**
```
Revisar los logs del contenedor en Easypanel
```

**✅ LOGS CORRECTOS deben mostrar:**
```
🤖 CONFIGURACIÓN DEL MODELO:
   USE_CLOUD_API: True
   CLOUD_PROVIDER: groq
   MODEL: llama-3.1-8b-instant
   MAX_TOKENS: 500
   TEMPERATURE: 0
   SEARCH_TYPE: mmr
   MMR_FETCH_K_MULTIPLIER: 4
   MMR_LAMBDA_MULT: 0.5
   ---
```

**❌ LOGS INCORRECTOS si:**
- No aparecen las nuevas variables
- MAX_TOKENS no es 500
- Faltan líneas de configuración

---

## 📊 CRITERIO DE APROBACIÓN

**PASA si:** 4/5 tests correctos (80%)
- **Test 1 y 2 son OBLIGATORIOS** (anti-contaminación y herramientas)
- Test 3, 4, 5 pueden tener 1 fallo

**NO PASA si:** <4/5 correctos
- Revisar logs de Easypanel
- Verificar que variables de entorno estén configuradas
- Considerar rollback a backup

---

## 🎯 TESTING RÁPIDO - CHECKLIST

```
[ ] Test 1: ¿Cómo soluciono errores de sistema? 
    → NO menciona Wigos ✅ / Menciona Wigos ❌
    
[ ] Test 2: ¿Herramientas para monitoreo remoto?
    → Menciona UltraVNC ✅ / Solo PsExec ❌
    
[ ] Test 3: Error COM en Wigos
    → Reparar Office ✅ / Solución genérica ❌
    
[ ] Test 4: Secuencia DISM
    → CheckHealth→ScanHealth→RestoreHealth ✅ / Incorrecto ❌
    
[ ] Test 5: Logs de configuración
    → Muestra MAX_TOKENS=500 ✅ / No aparece ❌

RESULTADO: ___/5 correctos

[ ] ✅ APROBADO (4-5/5) → Continuar con testing completo
[ ] ❌ RECHAZADO (<4/5) → Revisar configuración
```

---

## ⚡ PRÓXIMO PASO SI APRUEBA

Si los 5 tests pasan (o 4/5 con Tests 1-2 correctos):
1. ✅ Continuar con testing completo (11 preguntas)
2. ✅ Documentar configuración final
3. ✅ Proceder con más documentos

Si falla:
1. ⚠️ Revisar logs de Easypanel
2. ⚠️ Verificar variables de entorno agregadas
3. ⚠️ Considerar rollback desde `.backup-antes-opcion-b/`
