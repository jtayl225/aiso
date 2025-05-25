import 'package:aiso/models/subscriptions_model.dart';
import 'package:aiso/services/auth_service_supabase.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auth_state_enum.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  bool isSubscribed = false;
  final AuthServiceSupabase _authService = AuthServiceSupabase();
  RealtimeChannel? _subscriptionChannel;

  // State variables
  AuthScreenState _authScreenState = AuthScreenState.welcome;
  AuthScreenState get authScreenState => _authScreenState;

  MyAuthState _authState = MyAuthState.initial;
  MyAuthState get authState => _authState;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool _isAnonymous = false;
  bool get isAnonymous => _isAnonymous;


  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AuthViewModel() {
    checkAuthStatus();
  }

  // subscribe to supabase
  void subscribeToSubscriptionStatus() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    _subscriptionChannel = Supabase.instance.client
        .channel('public:subscriptions')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'subscriptions',
          filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'user_id', value: userId),
          callback: (payload) {
            final newValue = payload.newRecord['stripe_status'];
            isSubscribed = newValue == 'active';
            notifyListeners();
          },
        )
        .subscribe();
  }

  // Check authentication status
  Future<void> checkAuthStatus() async {
    _authState = MyAuthState.loading;
    notifyListeners();
    _authState = MyAuthState.unauthenticated;

    // // Use local session
    // final UserModel? currentUser = await _authService.getCurrentUser(); 
    // if (currentUser != null) {
    //   _currentUser = currentUser;
    //   _isAnonymous = _authService.isAnonymous;
    //   debugPrint('DEBUG: is anon? $_isAnonymous'); 
    //   _authState = AuthState.authenticated;
    //   notifyListeners();
    //   return;
    // }

    // // signIn('jdtay.90+aiso00@gmail.com', '123456');
    // _currentUser = await _authService.signInWithEmailAndPassword('jdtay.90+aiso00@gmail.com', '123456');
    //  if (_currentUser != null) {
    //   _authState = AuthState.authenticated;
    //   _isAnonymous = _authService.isAnonymous;
    // }

    debugPrint('DEBUG: is anon? $_isAnonymous'); 
    debugPrint('DEBUG: current user ID: ${_currentUser?.id}'); 

    // // If no session, sign in anonymously
    // _currentUser = await _authService.anonSignin();
    // _isAnonymous = _authService.isAnonymous;

    // if (_currentUser != null) {
    //   _authState = AuthState.anon;
    // } else {
    //   _authState = AuthState.unauthenticated;
    // }

    notifyListeners();
  }


  // Sign up
  Future<bool> signUp(String email, String password) async {
    _authState = MyAuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final newUser = await _authService.signUp(email, password);
      if (newUser != null) {

        _currentUser = newUser;
        _authState = MyAuthState.authenticated;

        final List<Subscription> subs = await _authService.fetchUserSubscriptions();
        isSubscribed = subs.isNotEmpty;
        subscribeToSubscriptionStatus();
        
        return true;
      } else {
        _authState = MyAuthState.unauthenticated;
        _errorMessage = 'Sign up failed. Please try again.';
        return false;
      }
    } catch (e) {
      _authState = MyAuthState.error;
      _errorMessage = e.toString();
      return false;
    } finally {
      notifyListeners();
    }
  }



  // Sign in
  Future<String?> signIn(String email, String password) async {
    _authState = MyAuthState.loading;
    notifyListeners();

    try {
      _currentUser = await _authService.signInWithEmailAndPassword(email, password);
    
      if (_currentUser != null) {
        _authState = MyAuthState.authenticated;
        _isAnonymous = _authService.isAnonymous;

        final List<Subscription> subs = await _authService.fetchUserSubscriptions();
        isSubscribed = subs.isNotEmpty;
        subscribeToSubscriptionStatus();

        return _currentUser!.id;
      } else {
        _authState = MyAuthState.unauthenticated;
        return null;
      }
    } catch (e) {
      _authState = MyAuthState.unauthenticated;
      debugPrint('Sign-in error: $e');
      return null;
    } finally {
      notifyListeners();
    }
  }


  // Sign out
  Future<bool> signOut() async {
    try {
      _authState = MyAuthState.loading;
      notifyListeners();

      await _authService.signOut(); // Perform sign-out

      _currentUser = null;
      _authState = MyAuthState.unauthenticated;
      notifyListeners();

      return true; // ✅ Sign-out successful
    } catch (e) {
      _authState = MyAuthState.error;
      notifyListeners();
      return false; // ❌ Sign-out failed
    }
  }


  // Auth Screen Setter method:
  void setAuthScreenState(AuthScreenState state) {
    print('DEBUG: setAuthScreenState called. New state: $state');
    _authScreenState = state;
    print('DEBUG: _authScreenState updated to: $_authScreenState');
    notifyListeners();
    print('DEBUG: notifyListeners called');
  }

}