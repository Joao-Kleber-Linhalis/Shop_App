class AuthException implements Exception {
  static const Map<String, String> errors = {
    'INVALID_LOGIN_CREDENTIALS': 'E-mail e/ou Senha incorretos.',
    'USER_DISABLED': 'Conta desabilitada!',
    'EMAIL_EXISTS': 'E-mail já cadastrado.',
    'PERATION_NOT_ALLOWED': 'Operação não permitida!',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Excesso de tentativas. Tente mais tarde',
  };

  final String key;

  AuthException(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro no processo de autenticação';
  }
}
