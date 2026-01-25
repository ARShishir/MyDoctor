import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client;

  AuthRepository(this._client);

  Session? get currentSession => _client.auth.currentSession;
  User? get currentUser => _client.auth.currentUser;

  Stream<AuthState> authStateChanges() {
    return _client.auth.onAuthStateChange;
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );

    // Avoid inserting into `profiles` immediately if RLS prevents anonymous inserts.
    // In many Supabase projects a DB trigger creates the profile on auth.sign_up,
    // or a policy allows authenticated inserts. If the client is not yet
    // authenticated after signUp, inserting now will fail with RLS errors.
    if (response.user != null) {
      try {
        // Only attempt to insert if the client has an authenticated user/session.
        if (_client.auth.currentUser != null) {
          await _client.from('profiles').insert({
            'id': response.user!.id,
            'name': name,
            'email': email,
          });
        }
      } catch (e) {
        // If insert fails (likely due to RLS), ignore here — profile can be
        // created by a DB trigger or by a subsequent authenticated call.
      }
    }

    return response;
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() {
    return _client.auth.signOut();
  }

  /// Fetch profile row from `profiles` table by user id.
  Future<Map<String, dynamic>?> fetchProfile(String userId) async {
    try {
      final res = await _client.from('profiles').select().eq('id', userId).maybeSingle();
      if (res is Map<String, dynamic>) return res;
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Upsert profile: update if exists, otherwise insert.
  Future<void> upsertProfile(Map<String, dynamic> payload) async {
    final id = payload['id'];
    if (id == null) throw Exception('profile id required');
    try {
      final existing = await _client.from('profiles').select().eq('id', id).maybeSingle();
      if (existing != null) {
        await _client.from('profiles').update(payload).eq('id', id);
      } else {
        await _client.from('profiles').insert([payload]);
      }
    } catch (_) {
      // ignore failures (RLS may block until authenticated)
    }
  }
}
