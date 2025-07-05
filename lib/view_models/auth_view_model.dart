import 'package:aiso/locator.dart';
import 'package:aiso/models/subscriptions_model.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/services/auth_service_supabase.dart';
import 'package:aiso/services/navigation_service.dart';
import 'package:aiso/services/store_service_supabase.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/auth_state_enum.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {

  final AuthServiceSupabase _authService = AuthServiceSupabase();
  final StoreServiceSupabase _storeService = StoreServiceSupabase();
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

  bool _isSubscribed = false;
  bool get isSubscribed => _isSubscribed;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  AuthViewModel() {
    checkAuthStatus();
  }

  // subscribe to supabase
  void subscribeToSubscriptionStatus() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    final stripeCustomerId = await _storeService.fetchStripeCustomerId(userId);
    if (stripeCustomerId == null) return;

    _subscriptionChannel = Supabase.instance.client
        .channel('public:subscriptions')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'subscriptions',
          filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'stripe_customer_id', value: stripeCustomerId),
          callback: (payload) {
            final newValue = payload.newRecord['stripe_status'];
            _isSubscribed = newValue == 'active';
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
        _isSubscribed = subs.isNotEmpty;
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
        debugPrint('subs: $subs');
        _isSubscribed = subs.isNotEmpty;
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

  // Sign in
  Future<String?> anonSignIn() async {
    _authState = MyAuthState.loading;
    notifyListeners();

    try {
      _currentUser = await _authService.anonSignIn();
    
      if (_currentUser != null) {
        _authState = MyAuthState.anon;
        _isAnonymous = _authService.isAnonymous;
        return _currentUser!.id;
      } else {
        _authState = MyAuthState.unauthenticated;
        return null;
      }
    } catch (e) {
      _authState = MyAuthState.unauthenticated;
      debugPrint('Anon sign-in error: $e');
      return null;
    } finally {
      notifyListeners();
    }
  }

  Future<void> anonSignInIfUnauth() async {

    try {

      if (_authState == MyAuthState.authenticated) return;

      _currentUser = await _authService.anonSignIn();
    
      if (_currentUser != null) {
        _authState = MyAuthState.anon;
        _isAnonymous = _authService.isAnonymous;
      } else {
        _authState = MyAuthState.unauthenticated;
      }
      
    } catch (e) {
      _authState = MyAuthState.unauthenticated;
      debugPrint('Anon sign-in error: $e');
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

  // // anonSignIn
  // Future<String?> anonSignIn() async {
  //   // _authState = MyAuthState.loading;
  //   _errorMessage = null;
  //   // notifyListeners();

  //   try {
  //     _currentUser = await _authService.anonSignIn();

  //     if (_currentUser != null) {
  //       // _authState = MyAuthState.anon;
  //       _isAnonymous = true;

  //       // final List<Subscription> subs = await _authService.fetchUserSubscriptions();
  //       // isSubscribed = subs.isNotEmpty;
  //       // subscribeToSubscriptionStatus();

  //       return _currentUser!.id;
  //     } else {
  //       // _authState = MyAuthState.unauthenticated;
  //       _errorMessage = 'Anonymous sign-in failed.';
  //       return null;
  //     }
  //   } catch (e) {
  //     _authState = MyAuthState.error;
  //     _errorMessage = e.toString();
  //     return null;
  //   } finally {
  //     // notifyListeners();
  //   }
  // }



  // Auth Screen Setter method:
  void setAuthScreenState(AuthScreenState state) {
    print('DEBUG: setAuthScreenState called. New state: $state');
    _authScreenState = state;
    print('DEBUG: _authScreenState updated to: $_authScreenState');
    notifyListeners();
    print('DEBUG: notifyListeners called');
  }

  Future<void> launchBillingPortalUrl() async {

    try {
      final String? url = await _storeService.generateBillingPortal();

      if (url == null) {
        debugPrint('Checkout URL is null');
        return;
      }

      final Uri uri = Uri.parse(url);

      if (kIsWeb) {
        // Open in new browser tab
        await launchUrl(
          uri,
          webOnlyWindowName: '_blank',
        );
      } else {
        // Open in external browser
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          debugPrint('Could not launch $url');
        }
      }
    } catch (e) {
      debugPrint('launchCheckoutUrl error: $e');
    } finally {
      notifyListeners();
    }

  }

}