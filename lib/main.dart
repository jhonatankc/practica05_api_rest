
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

import 'models/post.dart';
import 'services/post_service.dart';

const Color azulPrincipal = Color(0xFF173B65);
const Color azulSecundario = Color(0xFF3975B9);
const Color fondoAplicacion = Color(0xFFF3F5F8);
const Color textoPrincipal = Color(0xFF263445);
const Color textoSecundario = Color(0xFF687586);

void main() {
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Publicaciones API',

      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: fondoAplicacion,
        colorScheme: ColorScheme.fromSeed(
          seedColor: azulPrincipal,
          primary: azulPrincipal,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: azulPrincipal,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      home: const PantallaPosts(),
    );
  }
}

class PantallaPosts extends StatefulWidget {
  const PantallaPosts({super.key});

  @override
  State<PantallaPosts> createState() => _PantallaPostsState();
}

class _PantallaPostsState extends State<PantallaPosts> {
  final PostService _servicio = PostService();

  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _servicio.obtenerPosts();
  }

  // Actualizar las publicaciones.
  Future<void> _recargarPosts() async {
    final nuevaCarga = _servicio.obtenerPosts();

    setState(() {
      _postsFuture = nuevaCarga;
    });

    try {
      await nuevaCarga;
    } catch (_) {
      // FutureBuilder mostrará el mensaje de error.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicaciones'),
        actions: [
          IconButton(
            tooltip: 'Actualizar publicaciones',
            onPressed: _recargarPosts,
            icon: const Icon(Icons.refresh),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        color: azulPrincipal,
        onRefresh: _recargarPosts,
        child: FutureBuilder<List<Post>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            // Indicador de carga.
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(
                    child: CircularProgressIndicator(
                      color: azulPrincipal,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text(
                      'Cargando publicaciones...',
                      style: TextStyle(
                        color: textoSecundario,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              );
            }

            // Manejo de errores.
            if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 140),
                  const Icon(
                    Icons.cloud_off_outlined,
                    size: 65,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(height: 15),
                  const Center(
                    child: Text(
                      'No se pudieron cargar las publicaciones',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: textoPrincipal,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Verifica tu conexión a Internet.',
                      style: TextStyle(color: textoSecundario),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _recargarPosts,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Intentar nuevamente'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: azulPrincipal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            final posts = (snapshot.data ?? []).take(20).toList();

            if (posts.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Icon(
                    Icons.article_outlined,
                    size: 65,
                    color: textoSecundario,
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: Text(
                      'No hay publicaciones disponibles',
                      style: TextStyle(
                        fontSize: 16,
                        color: textoSecundario,
                      ),
                    ),
                  ),
                ],
              );
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                return ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 22,
                  ),
                  children: [
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 900,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Publicaciones disponibles',
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: textoPrincipal,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Consulta y selecciona una publicación para ver sus detalles.',
                              style: TextStyle(
                                fontSize: 14,
                                color: textoSecundario,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(
                                  Icons.article_outlined,
                                  size: 17,
                                  color: azulSecundario,
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  '${posts.length} publicaciones mostradas',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: textoSecundario,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),

                            // Lista de publicaciones.
                            ...posts.map((post) {
                              return TarjetaPost(
                                post: post,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return DetallePost(post: post);
                                      },
                                    ),
                                  );
                                },
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// Tarjeta individual de publicación.
class TarjetaPost extends StatelessWidget {
  final Post post;
  final VoidCallback onTap;

  const TarjetaPost({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
        side: const BorderSide(
          color: Color(0xFFE5E9EF),
          width: 0.8,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: const Color(0xFFE3EDF9),
                child: Text(
                  '${post.id}',
                  style: const TextStyle(
                    color: azulPrincipal,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textoPrincipal,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      post.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: textoSecundario,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF687586),
                size: 27,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pantalla de detalle de una publicación.
class DetallePost extends StatelessWidget {
  final Post post;

  const DetallePost({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publicación ${post.id}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 750),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // Encabezado del detalle.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: azulPrincipal,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.article_outlined,
                        color: Colors.white70,
                        size: 32,
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'DETALLE DE PUBLICACIÓN',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Publicación #${post.id}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Título de la publicación.
                _seccionDetalle(
                  titulo: 'Título',
                  icono: Icons.title,
                  contenido: post.title,
                ),

                const SizedBox(height: 14),

                // Contenido de la publicación.
                _seccionDetalle(
                  titulo: 'Contenido',
                  icono: Icons.subject,
                  contenido: post.body,
                ),

                const SizedBox(height: 14),

                // Información adicional.
                Card(
                  color: Colors.white,
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                    side: const BorderSide(
                      color: Color(0xFFE5E9EF),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Información general',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textoPrincipal,
                          ),
                        ),
                        const SizedBox(height: 15),
                        _datoDetalle(
                          Icons.person_outline,
                          'Usuario',
                          '${post.userId}',
                        ),
                        const Divider(height: 22),
                        _datoDetalle(
                          Icons.numbers,
                          'Número de publicación',
                          '${post.id}',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _seccionDetalle({
    required String titulo,
    required IconData icono,
    required String contenido,
  }) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
        side: const BorderSide(
          color: Color(0xFFE5E9EF),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(19),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icono, color: azulSecundario, size: 21),
                const SizedBox(width: 9),
                Text(
                  titulo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: textoPrincipal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 13),
            Text(
              contenido,
              style: const TextStyle(
                fontSize: 15,
                height: 1.6,
                color: textoSecundario,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datoDetalle(
    IconData icono,
    String etiqueta,
    String valor,
  ) {
    return Row(
      children: [
        Icon(icono, color: azulSecundario, size: 21),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            etiqueta,
            style: const TextStyle(
              color: textoSecundario,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          valor,
          style: const TextStyle(
            color: textoPrincipal,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
