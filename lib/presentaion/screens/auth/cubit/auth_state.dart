part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class RegisetrLoading extends AuthState {}

class RegisetrSucess extends AuthState {}

class RegisetrError extends AuthState {}

class LoginLoading extends AuthState {}

class Loginsucess extends AuthState {}

class LoginError extends AuthState {}

class VisiabilitySuceed extends AuthState {}
