# 📱 App Wiston Patiño — Flutter

Aplicación desarrollada en Flutter con login, SharedPreferences y gestión de datos.

**Creado por:** Wiston Patiño

---

## 🚀 MÉTODO MÁS FÁCIL — Obtener el APK con GitHub Actions

### Paso 1 — Crear cuenta en GitHub
Ve a https://github.com y crea una cuenta gratuita (si no tienes).

### Paso 2 — Crear un repositorio nuevo
1. Haz clic en el botón verde **"New"**
2. Nombre: `wiston-app`
3. Visibilidad: **Public** (para que Actions sea gratis)
4. Clic en **"Create repository"**

### Paso 3 — Subir el código
En la página del repositorio vacío, haz clic en **"uploading an existing file"**:
- Arrastra TODOS los archivos y carpetas del proyecto
- Escribe el mensaje: `"Primera versión"`
- Clic en **"Commit changes"**

### Paso 4 — Esperar la compilación automática
- Ve a la pestaña **"Actions"** de tu repositorio
- Verás un workflow llamado **"Build Flutter APK"** ejecutándose
- Espera ~5-8 minutos mientras compila ☕

### Paso 5 — Descargar el APK
1. Clic en el workflow completado (ícono ✅ verde)
2. Baja hasta la sección **"Artifacts"**
3. Clic en **"WistonPatino-APK"** para descargar
4. Descomprime el `.zip` → encontrarás `WistonPatino_App_v1.0.apk`

### Paso 6 — Instalar en Android
1. Transfiere el APK a tu teléfono (USB, WhatsApp, Drive, etc.)
2. En Android: **Ajustes → Seguridad → Fuentes desconocidas → Activar**
3. Abre el archivo `.apk` desde el administrador de archivos
4. Toca **"Instalar"**

---

## 💻 MÉTODO ALTERNATIVO — Compilar localmente

```bash
# Requiere Flutter SDK instalado (flutter.dev)
flutter pub get
flutter build apk --release
# APK en: build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔐 Credenciales de la app
- **Usuario:** `admin`
- **Contraseña:** `admin123`

---

## 📋 Funcionalidades
- ✅ Login con sesión persistente (SharedPreferences)
- ✅ CRUD completo de registros
- ✅ Búsqueda y filtros por categoría
- ✅ Menú lateral (Drawer)
- ✅ AlertDialogs y SnackBars
- ✅ "Creado por Wiston Patiño" en toda la app
