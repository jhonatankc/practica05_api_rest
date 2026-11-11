
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class PostService {
  static const String _url =
      'https://jsonplaceholder.typicode.com/posts';

  Future<List<Post>> obtenerPosts() async {
    final respuesta = await http.get(Uri.parse(_url));

    if (respuesta.statusCode == 200) {
      final List<dynamic> datos = jsonDecode(respuesta.body);

      return datos
          .map((json) => Post.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Error al cargar las publicaciones: ${respuesta.statusCode}',
      );
    }
  }
}
