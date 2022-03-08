import 'dart:convert';

import 'package:http/http.dart';

class NetworkService {
  final baseUrl = 'http://192.168.43.88:3000';

  Future<List> fetchTodos() async {
    try {
      final response = await get(Uri.parse(baseUrl + '/todos'));
      // print(response.body);
      return jsonDecode(response.body) as List;
    } catch (e) {
      // print(e);
      return [];
    }
  }

  Future<bool> patchTodo(Map<String, String> patchObj, int id) async {
    try {
      await patch(Uri.parse(baseUrl + '/todos/$id'), body: patchObj);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map> addTodo(Map<String, String> todoObj) async {
    try {
      final response = await post(Uri.parse(baseUrl + '/todos'), body: todoObj);
      return jsonDecode(response.body);
    } catch (e) {
      return {};
    }
  }

  Future<bool> deleteTodo(int id) async {
    try {
      await delete(Uri.parse(baseUrl + '/todos/$id'));
      return true;
    } catch (e) {
      return false;
    }
  }
}
