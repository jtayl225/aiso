import 'package:aiso/services/auth_service_supabase.dart';
import 'package:flutter/foundation.dart';
import '../models/auth_state_enum.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  bool isSubscribed = false;
  final AuthServiceSupabase _authService = AuthServiceSupabase();

  // State variables
  AuthScreenState _authScreenState = AuthScreenState.welcome;
  AuthScreenState get authScreenState => _authScreenState;

  AuthState _authState = AuthState.initial;
  AuthState get authState => _authState;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool _isAnonymous = false;
  bool get isAnonymous => _isAnonymous;


  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AuthViewModel() {
    checkAuthStatus();
  }

  // Check authentication status
  Future<void> checkAuthStatus() async {
    _authState = AuthState.loading;
    notifyListeners();
    _authState = AuthState.unauthenticated;

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
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final newUser = await _authService.signUp(email, password);
      if (newUser != null) {
        _currentUser = newUser;
        _authState = AuthState.authenticated;
        notifyListeners();
        return true;
      } else {
        _authState = AuthState.unauthenticated;
        _errorMessage = 'Sign up failed. Please try again.';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _authState = AuthState.error;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }



  // Sign in
  Future<String?> signIn(String email, String password) async {
    _authState = AuthState.loading;
    notifyListeners();

    try {
      _currentUser = await _authService.signInWithEmailAndPassword(email, password);

      if (_currentUser != null) {
        _authState = AuthState.authenticated;
        _isAnonymous = _authService.isAnonymous;
        return _currentUser!.id;
      } else {
        _authState = AuthState.unauthenticated;
        return null;
      }
    } catch (e) {
      _authState = AuthState.unauthenticated;
      debugPrint('Sign-in error: $e');
      return null;
    } finally {
      notifyListeners();
    }
  }


  // Sign out
  Future<bool> signOut() async {
    try {
      _authState = AuthState.loading;
      notifyListeners();

      await _authService.signOut(); // Perform sign-out

      _currentUser = null;
      _authState = AuthState.unauthenticated;
      notifyListeners();

      return true; // ✅ Sign-out successful
    } catch (e) {
      _authState = AuthState.error;
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