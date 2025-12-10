<h1 align="center">Sweetcakes</h1>

###

<p align="center">El Sistema de pedidos para pastelería</p>


<p align="left">Grupo #3<br><br>Ingeniería de Software 2 — Sección 233<br><br>John Fithgerald Ramos Escobar – 62321444<br><br>Miguel Angel Carranza Avilez – 62211533<br><br>Fernanda Nicole Dubón – 62311253<br><br>Génesis Jusselphy Medina Anariba – 62251243<br><br>Liza Valentina Torres Mena – 62311470</p>

###

<div align="center">
  <img height="400" src="https://files.catbox.moe/casghl.jpeg"  />
</div>

###

<div align="center">
  <img height="400" src="https://files.catbox.moe/0w84xp.jpeg"  />
</div>

###

<div align="center">
  <img height="400" src="https://files.catbox.moe/2g16tg.jpeg"  />
</div>

###

<p align="left">SweetCakes es una aplicación desarrollada en Flutter para digitalizar el proceso de pedidos de repostería. Los clientes pueden ver productos, seleccionar pasteles, hacer pedidos y pagar; mientras que los administradores gestionan inventario, productos y órdenes desde un panel interno.<br><br>La app utiliza Firebase como backend, específicamente:<br><br>Firestore para la base de datos NoSQL.<br><br>Authentication para el registro y login de usuarios.<br><br>El proyecto sigue una estructura modular, basada en Historias de Usuario, y está acompañado de diagramas de clases, contenedores, contexto, reglas de negocio y diseño UI/UX en tonos pastel definidos por el equipo.<br><br>🔹 Backend (Firebase)<br><br>No se usa API clásica.<br>El sistema trabaja con:<br><br>usuarios<br><br>productos<br><br>pedidos<br><br>detalle (array dentro de pedidos)<br><br>La transformación SQL → NoSQL simplificó las relaciones convirtiendo DETALLE_PEDIDO en un arreglo dentro de cada pedido.<br><br>🔹 Frontend (Flutter)<br><br>Dividido en módulos:<br><br>1. Login y Registro (HU-001 / HU-002)<br><br>Conexión a FirebaseAuth<br><br>Bloqueo por intentos fallidos<br><br>Validación de correo único<br><br>2. Catálogo de Productos (HU-003)<br><br>GridView conectado a Firestore<br><br>Imágenes desde assets o URL externa<br><br>3. Módulo de Pedidos (HU-004)<br><br>Selección de productos<br><br>Validación de stock<br><br>Carrito y confirmación del pedido<br><br>🔹 Diseño visual<br><br>Colores pastel<br><br>Tipografía suave<br><br>Interfaz minimalista<br><br>Mockups realizados para cada pantalla principal<br><br>🔹 Diagramas del proyecto<br><br>Incluyen:<br><br>Diagrama de clases<br><br>Diagrama de contexto<br><br>Diagrama de contenedores<br><br>Flujo TO-BE (pedido automatizado)<br><br>Reglas de negocio definidas<br><br>Estos explican cómo funciona el sistema y cómo se organiza la arquitectura.<br><br>🔹 Ejecución del proyecto (rápido)<br><br>Clonar el repo<br><br>Instalar dependencias con flutter pub get<br><br>Ejecutar:<br><br>flutter run (móvil)<br><br>flutter run -d chrome (web)<br><br>🔹 Imágenes en la app<br><br>Dos métodos:<br><br>Locales (assets/) → Recomendado<br><br>Catbox u otro hosting → Usando Image.network()<br><br>🔹 Colaboración<br><br>Crear ramas por función<br><br>Commits descriptivos<br><br>Subir cambios y abrir Pull Requests<br><br>Mantener main estable</p>

###
