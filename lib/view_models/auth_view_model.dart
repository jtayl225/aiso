import 'package:aiso/models/subscriptions_model.dart';
import 'package:aiso/services/auth_service_supabase.dart';
import 'package:aiso/services/store_service_supabase.dart';
import 'package:aiso/services/url_launcher_service.dart';
import 'package:aiso/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
import '../models/auth_state_enum.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {

  final AuthServiceSupabase _authService = AuthServiceSupabase();
  final StoreServiceSupabase _storeService = StoreServiceSupabase();
  RealtimeChannel? _subscriptionChannel;

  // State variables
  bool get isAuthenticated => _authService.isAuthenticated;

  AuthScreenState _authScreenState = AuthScreenState.welcome;
  AuthScreenState get authScreenState => _authScreenState;

  MyAuthState _authState = MyAuthState.initial;
  MyAuthState get authState => _authState;

  UserModel? _newUser; 
  UserModel? get newUser => _newUser;

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  bool _isVerified = false;
  bool get isVerified => _isVerified;

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
  // void subscribeToSubscriptionStatus() async {

  //   if (_subscriptionChannel != null) return; // Already subscribed

  //   final userId = Supabase.instance.client.auth.currentUser?.id;
  //   if (userId == null) return;
  //   // final String env = 'test';
  //   final String env = _storeService.env;
  //   final stripeCustomerId = await _storeService.fetchStripeCustomerId(userId, env);
  //   if (stripeCustomerId == null) return;

  //   _subscriptionChannel = Supabase.instance.client
  //       .channel('public:subscriptions')
  //       .onPostgresChanges(
  //         event: PostgresChangeEvent.update,
  //         schema: 'public',
  //         table: 'subscriptions',
  //         filter: PostgresChangeFilter(type: PostgresChangeFilterType.eq, column: 'stripe_customer_id', value: stripeCustomerId),
  //         callback: (payload) {
  //           final newValue = payload.newRecord['stripe_status'];
  //           _isSubscribed = newValue == 'active';
  //           notifyListeners();
  //         },
  //       )
  //       .subscribe();
  // }

  // subscribe to supabase
  void subscribeToSubscriptionStatus() async {
    if (_subscriptionChannel != null) return; // Already subscribed
    
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    
    final String env = _storeService.env;
    final stripeCustomerId = await _storeService.fetchStripeCustomerId(userId, env);
    if (stripeCustomerId == null) return;

    _subscriptionChannel = Supabase.instance.client
        .channel('subscription-updates')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'subscriptions',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq, 
            column: 'stripe_customer_id', 
            value: stripeCustomerId
          ),
          callback: (payload) {
            final newValue = payload.newRecord['stripe_status'];
            _isSubscribed = newValue == 'active';
            debugPrint('DEBUG: subscription status changed to: $_isSubscribed');
            notifyListeners();
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'stripe_users',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq, 
            column: 'user_id', 
            value: userId
          ),
          callback: (payload) async {
            // Re-fetch subscription status when stripe_users changes
            final newStripeCustomerId = await _storeService.fetchStripeCustomerId(userId, env);
            if (newStripeCustomerId != null) {
              final response = await Supabase.instance.client
                  .from('subscriptions')
                  .select('stripe_status')
                  .eq('stripe_customer_id', newStripeCustomerId)
                  .maybeSingle();
              _isSubscribed = response?['stripe_status'] == 'active';
              notifyListeners();
            }
          },
        )
        .subscribe();
  }

  // Check authentication status
  Future<void> checkAuthStatus() async {
    _authState = MyAuthState.loading;
    notifyListeners();
    _authState = MyAuthState.unauthenticated;

    // Use local session
    final UserModel? currentUser = await _authService.getCurrentUser(); 
    if (currentUser != null) {
      _currentUser = currentUser;
      _isAnonymous = _authService.isAnonymous;
      // printDebug('DEBUG: is anon? $_isAnonymous'); 
      _authState = MyAuthState.authenticated;
      subscribeToSubscriptionStatus();
      notifyListeners();
      return;
    }

    // // signIn('jdtay.90+aiso00@gmail.com', '123456');
    // _currentUser = await _authService.signInWithEmailAndPassword('jdtay.90+aiso00@gmail.com', '123456');
    //  if (_currentUser != null) {
    //   _authState = AuthState.authenticated;
    //   _isAnonymous = _authService.isAnonymous;
    // }

    printDebug('is anon? $_isAnonymous'); 
    printDebug('current user ID: ${_currentUser?.id}'); 

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

  // sign in or sign up
  // Future<bool> signInOrSignUp(String email, String password) async {
  //   _authState = MyAuthState.loading;
  //   _errorMessage = null;
  //   notifyListeners();

  //   try {
  //     // Try sign in first
  //     _currentUser = await _authService.signInWithEmailAndPassword(email, password);

  //     _authState = MyAuthState.authenticated;

  //     final subs = await _authService.fetchUserSubscriptions();
  //     _isSubscribed = subs.isNotEmpty;
  //     subscribeToSubscriptionStatus();

  //     return true;

  //   } on AuthApiException catch (e) {
  //     printDebug('Auth error: ${e.message} (status: ${e.statusCode}, code: ${e.code})');
  //     if (e.code?.trim().toLowerCase() == 'invalid_credentials') {
  //       // Attempt to sign up if credentials were invalid
  //       try {
  //         printDebug('Trying to signup.');
  //         final newUserx = await _authService.signUp(email, password);
  //         printDebug('Signup response: ${newUserx?.email}');

  //         if (newUser != null) {
  //            _newUser = newUserx;
  //           _currentUser = newUserx;
  //           _authState = MyAuthState.authenticated;

  //           final subs = await _authService.fetchUserSubscriptions();
  //           _isSubscribed = subs.isNotEmpty;
  //           subscribeToSubscriptionStatus();

  //           return true;
  //         } else {
  //           _authState = MyAuthState.unauthenticated;
  //           _errorMessage = 'Sign up failed. Please try again.';
  //           return false;
  //         }
  //       } on AuthException catch (signupError) {
  //         _authState = MyAuthState.error;
  //         _errorMessage = 'Sign-up failed: ${signupError.message}';
  //         return false;
  //       } catch (e) {
  //         _authState = MyAuthState.error;
  //         _errorMessage = 'Unexpected sign-up error: ${e.toString()}';
  //         return false;
  //       }
  //     } else {
  //       _authState = MyAuthState.error;
  //       _errorMessage = 'Sign-in failed: ${e.message}';
  //       return false;
  //     }

  //   } catch (e) {
  //     _authState = MyAuthState.error;
  //     _errorMessage = 'Unexpected error: ${e.toString()}';
  //     return false;
  //   } finally {
  //     notifyListeners();
  //   }
  // }

  Future<bool> signInOrSignUp(String email, String password) async {
    _authState = MyAuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Try sign in first
      _currentUser = await _authService.signInWithEmailAndPassword(email, password);

      _authState = MyAuthState.authenticated;

      final subs = await _authService.fetchUserSubscriptions();
      _isSubscribed = subs.isNotEmpty;
      subscribeToSubscriptionStatus();

      return true;

    } on AuthApiException catch (e) {
      printDebug('Auth error: ${e.message} (status: ${e.statusCode}, code: ${e.code})');

      if (e.code?.trim().toLowerCase() == 'invalid_credentials') {
        try {
          printDebug('Trying to signup.');
          final authResponse = await _authService.signUp(email, password);
          final user = authResponse?.user;
          final session = authResponse?.session;

          if (user != null) {
            final userModel = UserModel(
              id: user.id,
              email: user.email ?? '',
              username: '',
              displayName: '',
            );

            if (session != null) {
              _currentUser = userModel;
              _authState = MyAuthState.authenticated;

              final subs = await _authService.fetchUserSubscriptions();
              _isSubscribed = subs.isNotEmpty;
              subscribeToSubscriptionStatus();

              return true;
            } else {
              // Email verification required
              _newUser = userModel;
              _authState = MyAuthState.unauthenticated;
              _errorMessage = 'Please check your inbox to verify your email.';
              return true;
            }
          } else {
            _authState = MyAuthState.unauthenticated;
            _errorMessage = 'Sign up failed. Please try again.';
            return false;
          }
        } on AuthException catch (signupError) {
          _authState = MyAuthState.error;
          _errorMessage = 'Sign-up failed: ${signupError.message}';
          return false;
        } catch (e) {
          _authState = MyAuthState.error;
          _errorMessage = 'Unexpected sign-up error: ${e.toString()}';
          return false;
        }
      }

      // Handle other sign-in failures (e.g., email_not_confirmed)
      _authState = MyAuthState.error;
      _errorMessage = 'Sign-in failed: ${e.message}';
      return false;

    } catch (e) {
      _authState = MyAuthState.error;
      _errorMessage = 'Unexpected error: ${e.toString()}';
      return false;
    } finally {
      notifyListeners();
    }
  }


  // Sign up
  // Future<bool> signUp(String email, String password) async {
  //   _authState = MyAuthState.loading;
  //   _errorMessage = null;
  //   notifyListeners();

  //   try {
  //     // final newUserx = await _authService.signUp(email, password);
  //     final authResponse = await _authService.signUp(email, password);
  //     final user = authResponse?.user;
  //     final session = authResponse?.session;

  //     if (user != null) {

  //       final UserModel u = UserModel(
  //         id: user.id,
  //         email: user.email!,
  //         username: '',
  //         displayName: '',
  //       );

  //     }

      

  //     // if (newUserx != null) {

  //     //   _newUser = newUserx;
  //     //   _currentUser = newUserx;
  //     //   _authState = MyAuthState.authenticated;

  //     //   final List<Subscription> subs = await _authService.fetchUserSubscriptions();
  //     //   _isSubscribed = subs.isNotEmpty;
  //     //   subscribeToSubscriptionStatus();
        
  //     //   return true;
  //     // } else {
  //     //   _authState = MyAuthState.unauthenticated;
  //     //   _errorMessage = 'Sign up failed. Please try again.';
  //     //   return false;
  //     // }

  //   } catch (e) {
  //     _authState = MyAuthState.error;
  //     _errorMessage = e.toString();
  //     return false;
  //   } finally {
  //     notifyListeners();
  //   }
  // }

  Future<bool> signUp(String email, String password) async {
    _authState = MyAuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final authResponse = await _authService.signUp(email, password);
      final user = authResponse?.user;
      final session = authResponse?.session;

      if (user != null) {
        final UserModel userModel = UserModel(
          id: user.id,
          email: user.email ?? '',
          username: '',
          displayName: '',
        );

        if (session != null) {
          // ✅ Email verification disabled: user is authenticated
          _currentUser = userModel;
          _authState = MyAuthState.authenticated;

          final List<Subscription> subs = await _authService.fetchUserSubscriptions();
          _isSubscribed = subs.isNotEmpty;
          subscribeToSubscriptionStatus();

          return true;
        } else {
          // ✅ Email verification enabled: no session returned
          _newUser = userModel;
          _authState = MyAuthState.unauthenticated;
          _errorMessage = 'Please check your inbox to verify your email.';
          return true;
        }
      } else {
        _authState = MyAuthState.unauthenticated;
        _errorMessage = 'Sign up failed: no user returned.';
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
        _isVerified = await _authService.isCurrentUserVerified();

        final List<Subscription> subs = await _authService.fetchUserSubscriptions();
        printDebug('subs: $subs');
        _isSubscribed = subs.isNotEmpty;
        subscribeToSubscriptionStatus();

        return _currentUser!.id;
      } else {
        _authState = MyAuthState.unauthenticated;
        return null;
      }
    } catch (e) {
      _authState = MyAuthState.unauthenticated;
      printDebug('Sign-in error: $e');
      return null;
    } finally {
      notifyListeners();
    }
  }

  // anon Sign in
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

      // Unsubscribe from real-time updates
      _subscriptionChannel?.unsubscribe();
      _subscriptionChannel = null;

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
    printDebug('setAuthScreenState called. New state: $state');
    _authScreenState = state;
    printDebug('_authScreenState updated to: $_authScreenState');
    notifyListeners();
    printDebug('notifyListeners called');
  }

  // Future<void> launchBillingPortalUrl() async {

  //   try {
  //     final String? url = await _storeService.generateBillingPortal();

  //     if (url == null) {
  //       debugPrint('Checkout URL is null');
  //       return;
  //     }

  //     final Uri uri = Uri.parse(url);

  //     if (kIsWeb) {
  //       // Open in new browser tab
  //       await launchUrl(
  //         uri,
  //         webOnlyWindowName: '_blank',
  //       );
  //     } else {
  //       // Open in external browser
  //       if (await canLaunchUrl(uri)) {
  //         await launchUrl(uri, mode: LaunchMode.externalApplication);
  //       } else {
  //         debugPrint('Could not launch $url');
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint('launchCheckoutUrl error: $e');
  //   } finally {
  //     notifyListeners();
  //   }

  // }

  void launchBillingPortalUrl() {
    UrlLauncherService.launchFromAsyncSource(() {
      return _storeService.generateBillingPortal();
    });
  }


}