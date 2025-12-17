# 🧪 TEST DE VALIDACIÓN - Basdonax AI RAG
**Proyecto:** asistente-test (asistente.au-rex.cl)  
**Fecha:** 17 Diciembre 2024  
**Objetivo:** Validar mejoras con max_tokens=500 y prompt anti-contaminación

---

## 📋 CRITERIOS DE EVALUACIÓN

### ✅ RESPUESTA CORRECTA:
- Información precisa del documento relevante
- Respuesta concisa (2-4 oraciones o pasos)
- NO menciona aplicaciones específicas en preguntas generales
- Cita herramientas/comandos correctos

### ❌ RESPUESTA INCORRECTA:
- Menciona "Wigos" o aplicaciones específicas en preguntas generales
- Información mezclada de documentos no relacionados
- Respuesta demasiado larga (>200 palabras)
- Comandos incorrectos o en orden incorrecto

---

## 🎯 CATEGORÍA 1: PREGUNTAS GENERALES (Anti-contaminación)

### TEST 1: Mantenimiento básico Windows
**Pregunta:**  
```
¿Cuál es la secuencia correcta de comandos DISM para verificar la salud del sistema en Windows?
```

**RESPUESTA ESPERADA:**
- Debe mencionar: CheckHealth → ScanHealth → RestoreHealth (en ese orden)
- NO debe mencionar Wigos, Excel, COM, ni ninguna aplicación específica
- Debe ser concisa (2-3 oraciones)

**CONTAMINACIÓN SI MENCIONA:** Wigos, Office, exportación Excel

---

### TEST 2: Limpieza de archivos temporales
**Pregunta:**  
```
¿Cómo limpio archivos temporales en Windows usando comandos?
```

**RESPUESTA ESPERADA:**
- Debe mencionar: `cleanmgr` (con /sageset y/o /sagerun)
- Alternativamente: comandos PowerShell con `Remove-Item`
- NO debe mencionar Wigos, componentes COM, ni Office

**CONTAMINACIÓN SI MENCIONA:** Wigos, Excel, componentes COM, Office

---

### TEST 3: Diferencia HDD vs SSD
**Pregunta:**  
```
¿Cuál es la diferencia principal entre HDD y SSD en términos de rendimiento?
```

**RESPUESTA ESPERADA:**
- Debe explicar diferencia de velocidad y tecnología (mecánico vs estado sólido)
- NO debe mencionar ninguna aplicación específica
- Respuesta general y técnica

**CONTAMINACIÓN SI MENCIONA:** Wigos, UltraVNC, o cualquier aplicación específica

---

## 🎯 CATEGORÍA 2: PREGUNTAS ESPECÍFICAS (Precisión técnica)

### TEST 4: Problema específico de Wigos
**Pregunta:**  
```
Tengo un error en Wigos que dice "No se puede convertir el objeto COM". ¿Qué hago?
```

**RESPUESTA ESPERADA:**
- Debe identificar el problema como error de componentes COM de Excel
- Debe sugerir: Reparar Office (Reparación rápida/en línea)
- Debe ser específica para Wigos
- Puede mencionar: registro de componentes COM como solución alternativa

**INCORRECTO SI:**
- Responde con soluciones generales de Windows no relacionadas
- No menciona Office o componentes COM

---

### TEST 5: Instalación UltraVNC
**Pregunta:**  
```
¿Cómo instalo UltraVNC de forma silenciosa en un equipo remoto?
```

**RESPUESTA ESPERADA:**
- Debe mencionar: PsExec
- Debe incluir el comando: `psexec \\IP-Host -s C:\Temp\UltraVNC_Setup.exe /silent /norestart`
- Puede mencionar: copiar instalador con xcopy primero

**INCORRECTO SI:**
- No menciona PsExec
- Sugiere instalación manual o GUI

---

### TEST 6: Configuración UltraVNC discreto
**Pregunta:**  
```
¿Qué archivo debo modificar para configurar UltraVNC en modo discreto?
```

**RESPUESTA ESPERADA:**
- Debe mencionar: UltraVNC.ini
- Puede mencionar ubicación: Carpeta de instalación de UltraVNC
- Respuesta directa y técnica

**INCORRECTO SI:**
- Menciona archivos de configuración incorrectos
- Respuesta demasiado genérica sin mencionar el archivo específico

---

## 🎯 CATEGORÍA 3: PREGUNTAS TRAMPOSAS (Filtrado de contexto)

### TEST 7: Pregunta ambigua sobre errores
**Pregunta:**  
```
¿Cómo soluciono errores de sistema en Windows?
```

**RESPUESTA ESPERADA:**
- Debe dar respuesta GENERAL (DISM, SFC)
- NO debe mencionar Wigos, Excel, COM
- Debe ser genérica y aplicable a cualquier error

**CONTAMINACIÓN SI MENCIONA:** Wigos, Office, UltraVNC, o cualquier app específica

---

### TEST 8: Pregunta sobre Office sin mencionar Wigos
**Pregunta:**  
```
¿Cómo reparo Microsoft Office?
```

**RESPUESTA ESPERADA:**
- Debe mencionar: Panel de Control → Cambiar → Reparar
- Puede mencionar: Reparación rápida vs en línea
- NO debe mencionar Wigos específicamente (aunque el manual lo incluya)

**CONTAMINACIÓN SI MENCIONA:** Wigos GUI, exportación Excel (contexto muy específico)

---

### TEST 9: Monitoreo remoto genérico
**Pregunta:**  
```
¿Qué herramientas puedo usar para monitoreo remoto de equipos?
```

**RESPUESTA ESPERADA:**
- Puede mencionar UltraVNC como opción
- Respuesta breve sin entrar en detalles de instalación
- Puede listar alternativas si las conoce

**INCORRECTO SI:**
- Entra en detalles técnicos de instalación sin ser preguntado
- Mezcla información de otros documentos no relacionados

---

## 🎯 CATEGORÍA 4: VALIDACIÓN DE SÍNTESIS

### TEST 10: Comando DISM complejo
**Pregunta:**  
```
Explica para qué sirve DISM /Online /Cleanup-Image /RestoreHealth
```

**RESPUESTA ESPERADA:**
- Explicación concisa del comando (repara imagen del sistema usando Windows Update)
- 1-2 oraciones máximo
- Sin detalles excesivos

**INCORRECTO SI:**
- Respuesta demasiado larga (>100 palabras)
- Copia texto completo del manual

---

### TEST 11: Secuencia de solución Wigos
**Pregunta:**  
```
¿Cuál es el orden de soluciones para el problema de exportación Excel en Wigos?
```

**RESPUESTA ESPERADA:**
- Debe listar: 1) Reparar Office, 2) Registrar componentes COM
- Orden correcto según el documento
- Respuesta estructurada pero concisa

**INCORRECTO SI:**
- Orden incorrecto de soluciones
- Omite pasos críticos
- Demasiado detalle (>150 palabras)

---

## 📊 SISTEMA DE PUNTUACIÓN

| Categoría | Tests | Peso | Nota |
|-----------|-------|------|------|
| **Anti-contaminación (General)** | 3 | 40% | ___ / 3 |
| **Precisión técnica (Específica)** | 3 | 30% | ___ / 3 |
| **Filtrado de contexto (Tramposas)** | 3 | 20% | ___ / 3 |
| **Síntesis (Concisión)** | 2 | 10% | ___ / 2 |
| **TOTAL** | **11** | **100%** | **___ / 11** |

### 🎯 INTERPRETACIÓN:
- **10-11 correctas (91-100%):** ✅ Sistema funcionando óptimamente
- **8-9 correctas (73-90%):** ⚠️ Funcional, ajustes menores necesarios
- **6-7 correctas (55-72%):** 🔧 Requiere optimización (implementar Opción B)
- **<6 correctas (<55%):** 🚨 Problema grave, revisar configuración completa

---

## ⚡ INSTRUCCIONES DE USO

1. **Accede al chat:** https://asistente.au-rex.cl
2. **Copia cada pregunta** una por una
3. **Pega la respuesta** del RAG en este documento
4. **Marca ✅ o ❌** según cumplimiento
5. **Anota observaciones** de contaminación detectada
6. **Calcula puntuación final**

---

## 📝 PLANTILLA DE REPORTE

```
FECHA: ___________
VERSIÓN: max_tokens=500 + prompt anti-contaminación

RESULTADOS:
- Test 1: [ ] ✅ / [ ] ❌ - Observación: _____________
- Test 2: [ ] ✅ / [ ] ❌ - Observación: _____________
- Test 3: [ ] ✅ / [ ] ❌ - Observación: _____________
- Test 4: [ ] ✅ / [ ] ❌ - Observación: _____________
- Test 5: [ ] ✅ / [ ] ❌ - Observación: _____________
- Test 6: [ ] ✅ / [ ] ❌ - Observación: _____________
- Test 7: [ ] ✅ / [ ] ❌ - Observación: _____________
- Test 8: [ ] ✅ / [ ] ❌ - Observación: _____________
- Test 9: [ ] ✅ / [ ] ❌ - Observación: _____________
- Test 10: [ ] ✅ / [ ] ❌ - Observación: _____________
- Test 11: [ ] ✅ / [ ] ❌ - Observación: _____________

PUNTUACIÓN TOTAL: ___ / 11 (___%)

CONCLUSIÓN:
[ ] ✅ Listo para producción
[ ] ⚠️ Requiere ajustes menores
[ ] 🔧 Implementar Opción B (prompt ultra-restrictivo)
[ ] 🚨 Revisar configuración completa

PRÓXIMOS PASOS:
_________________________________________________
```

---

## 🚀 ACCIÓN POST-TESTING

### Si ≥9 correctas (82%+):
- ✅ Sistema aprobado
- Documentar configuración final
- Proceder con documentos adicionales

### Si 6-8 correctas (55-81%):
- ⚠️ Implementar **Opción B** (prompt ultra-restrictivo)
- Re-testear con las mismas preguntas
- Comparar resultados

### Si <6 correctas (<55%):
- 🚨 Evaluar cambio a modelo local (Phi3 con Ollama)
- Revisar configuración de ChromaDB
- Validar calidad de embeddings

---

**NOTA:** Estas preguntas están diseñadas para detectar los problemas específicos reportados en la sesión anterior (contaminación cruzada con "Wigos" en preguntas generales).
