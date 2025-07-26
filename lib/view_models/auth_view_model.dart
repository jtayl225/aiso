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
  // RealtimeChannel? _subscriptionChannel;

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
  // Two separate channels for the two-stage process
  RealtimeChannel? _stripeUsersChannel;
  RealtimeChannel? _subscriptionChannel;

  void subscribeToSubscriptionStatus() async {
    debugPrint('DEBUG: subscribeToSubscriptionStatus called.');
    
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      debugPrint('DEBUG: No user ID found.');
      return;
    }
    debugPrint('DEBUG: User ID: $userId');
    
    final String env = _storeService.env;
    debugPrint('DEBUG: Environment: $env');
    
    // First, check if user already has a stripe_customer_id
    final existingStripeCustomerId = await _storeService.fetchStripeCustomerId(userId, env);
    
    if (existingStripeCustomerId != null) {
      debugPrint('DEBUG: User already has stripe_customer_id: $existingStripeCustomerId');
      // User already has stripe customer ID, set up subscription listener directly
      await _setupSubscriptionListener(existingStripeCustomerId);
    } else {
      debugPrint('DEBUG: User has no stripe_customer_id yet, waiting for it to be created.');
    }
    
    // Always set up the stripe_users listener to catch when stripe_customer_id is created
    await _setupStripeUsersListener(userId, env);
  }

  // Listen for when stripe_customer_id gets created/updated
  Future<void> _setupStripeUsersListener(String userId, String env) async {
    if (_stripeUsersChannel != null) {
      debugPrint('DEBUG: Stripe users listener already exists.');
      return;
    }
    
    debugPrint('DEBUG: Setting up stripe_users listener for user: $userId');
    
    _stripeUsersChannel = Supabase.instance.client
        .channel('stripe-users-updates')
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
            debugPrint('DEBUG: Stripe users table change detected.');
            debugPrint('DEBUG: Event type: ${payload.eventType}');
            debugPrint('DEBUG: New record: ${payload.newRecord}');
            
            // Extract stripe_customer_id from the change
            final newStripeCustomerId = payload.newRecord['stripe_customer_id'];
            
            if (newStripeCustomerId != null) {
              debugPrint('DEBUG: New stripe_customer_id detected: $newStripeCustomerId');
              
              // Now set up the subscription listener with the new customer ID
              await _setupSubscriptionListener(newStripeCustomerId);
            }
          },
        )
        .subscribe();
  }

  // Listen for subscription changes once we have stripe_customer_id
  Future<void> _setupSubscriptionListener(String stripeCustomerId) async {
    if (_subscriptionChannel != null) {
      debugPrint('DEBUG: Subscription listener already exists.');
      return;
    }
    
    debugPrint('DEBUG: Setting up subscription listener for customer: $stripeCustomerId');
    
    // Check initial subscription status
    await _checkInitialSubscriptionStatus(stripeCustomerId);
    
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
            debugPrint('DEBUG: Subscriptions table change detected.');
            debugPrint('DEBUG: Event type: ${payload.eventType}');
            debugPrint('DEBUG: New record: ${payload.newRecord}');
            
            final newValue = payload.newRecord['stripe_status'];
            debugPrint('DEBUG: New stripe_status value: $newValue');
            
            final wasSubscribed = _isSubscribed;
            _isSubscribed = newValue == 'active';
            
            debugPrint('DEBUG: Was subscribed: $wasSubscribed, Now subscribed: $_isSubscribed');
            
            if (wasSubscribed != _isSubscribed) {
              debugPrint('DEBUG: Subscription status changed, notifying listeners.');
              notifyListeners();
            }
          },
        )
        .subscribe();
  }

  // Check initial subscription status
  Future<void> _checkInitialSubscriptionStatus(String stripeCustomerId) async {
    debugPrint('DEBUG: Checking initial subscription status for customer: $stripeCustomerId');
    
    try {
      final response = await Supabase.instance.client
          .from('subscriptions')
          .select('stripe_status')
          .eq('stripe_customer_id', stripeCustomerId)
          .maybeSingle();
      
      debugPrint('DEBUG: Initial subscription query response: $response');
      
      final initialStatus = response?['stripe_status'];
      final wasSubscribed = _isSubscribed;
      _isSubscribed = initialStatus == 'active';
      
      debugPrint('DEBUG: Initial subscription status: $_isSubscribed');
      
      if (wasSubscribed != _isSubscribed) {
        notifyListeners();
      }
    } catch (e) {
      debugPrint('DEBUG: Error checking initial subscription status: $e');
    }
  }

  // Clean up both subscriptions
  void unsubscribeFromSubscriptionStatus() {
    debugPrint('DEBUG: Cleaning up subscriptions.');
    
    _stripeUsersChannel?.unsubscribe();
    _subscriptionChannel?.unsubscribe();
    _stripeUsersChannel = null;
    _subscriptionChannel = null;
  }

  // Manual refresh for testing
  Future<void> refreshSubscriptionStatus() async {
    debugPrint('DEBUG: Manual refresh requested.');
    
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    
    final String env = _storeService.env;
    final stripeCustomerId = await _storeService.fetchStripeCustomerId(userId, env);
    
    if (stripeCustomerId != null) {
      await _checkInitialSubscriptionStatus(stripeCustomerId);
    } else {
      debugPrint('DEBUG: No stripe customer ID found during manual refresh.');
    }
  }

  // Test connection
  void testRealtimeConnection() {
    debugPrint('DEBUG: Testing realtime connection...');
    debugPrint('DEBUG: Stripe users channel exists: ${_stripeUsersChannel != null}');
    debugPrint('DEBUG: Subscription channel exists: ${_subscriptionChannel != null}');
    debugPrint('DEBUG: Is subscribed: $_isSubscribed');
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