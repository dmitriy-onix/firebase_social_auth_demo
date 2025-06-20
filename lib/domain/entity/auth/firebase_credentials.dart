import 'package:equatable/equatable.dart';

class FirebaseCredentials extends Equatable {
  final String email;
  final String password;

  const FirebaseCredentials({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
