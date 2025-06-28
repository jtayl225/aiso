import 'package:aiso/models/subscriptions_model.dart';
import 'package:aiso/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServiceSupabase {

  final SupabaseClient _supabase = Supabase.instance.client;

  bool get isAnonymous {
    debugPrint('DEBUG: serivce is checking if anon.');
    final user = _supabase.auth.currentUser;
    return user != null &&
          (user.email == null || user.email!.isEmpty) &&
          (user.identities == null || user.identities!.isEmpty);
  }

  Future<UserModel?> anonSignIn() async {
    try {
      final response = await _supabase.auth.signInAnonymously();
      final user = response.user;
      if (user == null) return null;
      return UserModel(
          id: user.id,
          email: '',
          username: '',
          displayName: '',
        );
    } catch (e) {
      debugPrint('Error signing in: $e');
      return null;
    }
  }

  // Create a new user with email and password
  Future<UserModel?> signUp(String email, String password, {String? username, String? displayName}) async {
    try {
      final AuthResponse response = await _supabase.auth.signUp(
        email: email, 
        password: password,
      );
      final user = response.user;
      if (user == null) return null;
      return UserModel(
          id: user.id,
          email: user.email!,
          username: username ?? '',
          displayName: displayName ?? '',
        );
    } catch (e) {
      debugPrint('Error creating user: $e');
      return null;
    }

  }

  // Sign in with email and password
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) return null;
      return UserModel(
          id: user.id,
          email: user.email!,
          username: user.userMetadata?['username'] ?? '',
          displayName: user.userMetadata?['displayName'] ?? '',
        );
    } catch (e) {
      debugPrint('Error signing in: $e');
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
    }
  }

  // Get the current authenticated user
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;
      return UserModel(
          id: user.id,
          email: user.email ?? '',
          username: user.userMetadata?['username'] ?? '',
          displayName: user.userMetadata?['displayName'] ?? '',
        );
    } catch (e) {
      debugPrint('Error fetching current user: $e');
      return null;
    }
  }

  Future<String?> fetchCurrentUserId() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null || user.id.isEmpty) return null;
      return user.id;
    } catch (e) {
      debugPrint('Error fetching current user: $e');
      return null;
    }
  }

  Future<List<Subscription>> fetchUserSubscriptions() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return [];

      final response = await _supabase
        .from('subscriptions')
        .select()
        .eq('user_id', user.id)
        .eq('stripe_status', 'active');

    final List<Subscription> subscriptions = (response as List).map((item) {
      return Subscription.fromJson(item);
    }).toList();

    return subscriptions;

    } catch (e) {
      debugPrint('Error fetching current user: $e');
      return [];
    }
  }
  
}
