// ignore_for_file: unnecessary_type_check, dead_code, duplicate_ignore

import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

class SupabaseRepository {
  static final SupabaseClient _client = getSupabaseClient();

  /// Fetch services (optionally filter by type)
  static Future<List<Map<String, dynamic>>> fetchServices({String? type}) async {
    try {
      final builder = _client.from('services').select();
      if (type != null) builder.eq('type', type);
      final dynamic res = await builder.order('created_at', ascending: false);
      if (res is List) return res.cast<Map<String, dynamic>>();
      if (res is Map<String, dynamic>) {
        final map = res;
        if (map.containsKey('error') && map['error'] != null) {
          final err = map['error'];
          final msg = err is Map && err['message'] != null ? err['message'].toString() : err.toString();
          throw Exception(msg);
        }
        if (map.containsKey('data') && map['data'] is List) {
          return List<Map<String, dynamic>>.from(map['data'] as List);
        }
      }
      return <Map<String, dynamic>>[];
    } catch (e) {
      rethrow;
    }
  }

  /// Insert a service
  static Future<void> addService(Map<String, dynamic> payload) async {
    final dynamic res = await _client.from('services').insert([payload]);
    if (res is Map<String, dynamic> && res['error'] != null) {
      final err = res['error'];
      final msg = err is Map && err['message'] != null ? err['message'].toString() : err.toString();
      throw Exception(msg);
    }
  }

  /// Fetch medicines (for now fetch all; can be filtered by user_id)
  static Future<List<Map<String, dynamic>>> fetchMedicines({String? userId}) async {
    try {
      final builder = _client.from('medicines').select();
      if (userId != null) builder.eq('user_id', userId);
      final dynamic res = await builder.order('created_at', ascending: false);
      if (res is List) return res.cast<Map<String, dynamic>>();
      if (res is Map<String, dynamic>) {
        final map = res;
        if (map.containsKey('error') && map['error'] != null) {
          final err = map['error'];
          final msg = err is Map && err['message'] != null ? err['message'].toString() : err.toString();
          throw Exception(msg);
        }
        if (map.containsKey('data') && map['data'] is List) {
          return List<Map<String, dynamic>>.from(map['data'] as List);
        }
      }
      return <Map<String, dynamic>>[];
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> addMedicine(Map<String, dynamic> payload) async {
    // ensure user_id is attached when possible
    final userId = _client.auth.currentUser?.id;
    if (!payload.containsKey('user_id') && userId != null) payload['user_id'] = userId;

    final dynamic res = await _client.from('medicines').insert([payload]);
    if (res is Map<String, dynamic> && res['error'] != null) {
      final err = res['error'];
      final msg = err is Map && err['message'] != null ? err['message'].toString() : err.toString();
      throw Exception(msg);
    }
  }

  static Future<void> updateMedicineTaken(String id, bool taken) async {
    final dynamic res = await _client.from('medicines').update({'taken': taken}).eq('id', id);
    if (res is Map<String, dynamic> && res['error'] != null) {
      final err = res['error'];
      final msg = err is Map && err['message'] != null ? err['message'].toString() : err.toString();
      throw Exception(msg);
    }
  }
}
