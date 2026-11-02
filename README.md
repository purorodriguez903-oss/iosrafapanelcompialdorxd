# 🎮 Rafa Panel iOS - Free Fire Launcher & Floating Panel

Proyecto nativo en **Swift / UIKit** para iOS con interfaz de lanzamiento de Free Fire y panel flotante táctil con checkboxes (ON / OFF).

---

## 📱 Características

- **Botón "Free Fire Normal":** Al tocarlo, invoca el esquema de apertura de la aplicación (`freefire://`, `freefireth://` o `freefiremax://`) y activa el panel flotante.
- **Panel Flotante (Draggable):**
  - Se puede arrastrar y mover libremente con el dedo hacia cualquier lado de la pantalla (`UIPanGestureRecognizer`).
  - Botón para minimizar / expandir (`—` / `+`).
- **2 Checkboxes Interactivos:**
  - **Checkbox 1** y **Checkbox 2**.
  - Estado visual claro: Indicadores **ON** (Verde) y **OFF** (Gris).
  - Retroalimentación háptica (`UIImpactFeedbackGenerator`) y animación al pulsar.
  - Barra de estado en tiempo real.

---

## 📦 Descarga del archivo `.IPA`

Cada vez que se sube un cambio a este repositorio, **GitHub Actions** compila el proyecto automáticamente en un entorno macOS y genera el archivo `.ipa`.

1. Ve a la pestaña **[Actions](../../actions)** o a la sección **[Releases](../../releases)** de este repositorio.
2. Descarga el archivo **`RafaPanel.ipa`**.

---

## 📲 Cómo instalar en iPhone / iPad

Puedes instalar el `.ipa` utilizando cualquiera de estos métodos de sideloading:

1. **TrollStore** (Recomendado si tu versión de iOS es compatible):
   - Descarga el `.ipa` en Safari y dale a *"Abrir con TrollStore"*. Se instalará permanentemente sin necesidad de firmas semanales.
2. **Sideloadly / AltStore** (PC / Mac):
   - Conecta tu iPhone por USB.
   - Arrastra el archivo `RafaPanel.ipa` al programa.
   - Ingresa tu Apple ID y presiona *Start / Instalar*.
3. **Esign / Scarlet** (Directo en el iPhone):
   - Importa el archivo `.ipa` a tu gestor de certificados personal y firma la app.
