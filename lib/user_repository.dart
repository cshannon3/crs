import 'dart:async';
import 'package:cshannon3/secrets.dart';
import 'package:meta/meta.dart';

import 'package:firebase/firebase.dart';


@immutable
class UserRepository {
  
  UserRepository({Auth firebaseAuth, GoogleAuthProvider googleSignin})
      : _firebaseAuth = firebaseAuth ?? auth(),
        _googleSignIn = googleSignin ?? GoogleAuthProvider();

  final Auth _firebaseAuth;
  final GoogleAuthProvider _googleSignIn;

  Future<UserCredential> signInWithGoogle() async {
    try {
      return await _firebaseAuth.signInWithPopup(_googleSignIn);
    } catch (e) {
      print('Error in sign in with google: $e');
      throw '$e';
    }
  }
  
  Future<UserCredential> signInWithCredentials(
      String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(email, password);
    } catch (e) {
      print('Error in sign in with credentials: $e');
      // return e;
      throw '$e';
    }
  }

  Future<UserCredential> signUp({String email, String password}) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email,
        password,
      );
    } catch (e) {
      print('Error siging in with credentials: $e');
      throw '$e';
      // throw Error('Error signing up with credentials: $e');
      // return e;
    }
  }

  Future<dynamic> signOut() async {
    try {
      return Future.wait([
        _firebaseAuth.signOut(),
      ]);
    } catch (e) {
      print ('Error signin out: $e');
      // return e;
      throw '$e';
    }
  }

  Future<bool> isSignedIn() async {
    final currentUser = _firebaseAuth.currentUser;
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (_firebaseAuth.currentUser).email;
  }
  User getU() =>_firebaseAuth.currentUser;
  
}

// class LoginBloc {
//   LoginBloc({
//     @required UserRepository userRepository,
//   })  : assert(userRepository != null),
//         _userRepository = userRepository;

//   final UserRepository _userRepository;

//   @override
//   LoginState get initialState => LoginState.empty();

//   @override
//   Stream<LoginState> transformEvents(
//     Stream<LoginEvent> events,
//     Stream<LoginState> Function(LoginEvent event) next,
//   ) {
//     final observableStream = events as Observable<LoginEvent>;
//     final nonDebounceStream = observableStream.where((event) {
//       return event is! EmailChanged && event is! PasswordChanged;
//     });
//     final debounceStream = observableStream.where((event) {
//       return event is EmailChanged || event is PasswordChanged;
//     }).debounceTime(const Duration(milliseconds: 300));
//     return super
//         .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
//   }
//   @override
//   Stream<LoginState> mapEventToState(LoginEvent event) async* {
//     if (event is EmailChanged) {
//       yield* _mapEmailChangedToState(event.email);
//     } else if (event is PasswordChanged) {
//       yield* _mapPasswordChangedToState(event.password);
//     } else if (event is LoginWithGooglePressed) {
//       yield* _mapLoginWithGooglePressedToState();
//     } else if (event is LoginWithCredentialsPressed) {
//       yield* _mapLoginWithCredentialsPressedToState(
//         email: event.email,
//         password: event.password,
//       );
//     }
//   }

//   Stream<LoginState> _mapEmailChangedToState(String email) async* {
//     yield state.update(
//       isEmailValid: Validators.isValidEmail(email),
//     );
//   }

//   Stream<LoginState> _mapPasswordChangedToState(String password) async* {
//     yield state.update(
//       isPasswordValid: Validators.isValidPassword(password),
//     );
//   }

//   Stream<LoginState> _mapLoginWithGooglePressedToState() async* {
//     LoginState state;
//     await _userRepository.signInWithGoogle().then((onValue) {
//       state = LoginState.success();
//     }).catchError((onError) {
//       state = LoginState.failure(onError);
//     });
//     yield state;
//   }

//   Stream<LoginState> _mapLoginWithCredentialsPressedToState({
//     String email,
//     String password,
//   }) async* {
//     yield LoginState.loading();
//     LoginState state;
//     await _userRepository
//         .signInWithCredentials(email, password)
//         .then((onValue) {
//       state = LoginState.success();
//     }).catchError((onError) {
//       state = LoginState.failure(onError);
//     });
//     yield state;
//   }
// }
