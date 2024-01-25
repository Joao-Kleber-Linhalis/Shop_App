import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.Login;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  void _swithAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.Signup;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }
    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    if (_isLogin()) {
      //Efetuar Login
      await auth.login(
        _authData['email']!,
        _authData['password']!,
      );
    } else {
      //Efetuar Cadastro
      await auth.signup(
        _authData['email']!,
        _authData['password']!,
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 310 : 400,
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "E-mail"),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains("@")) {
                    return 'Informe uma e-mail válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Senha"),
                keyboardType: TextInputType.text,
                obscureText: true,
                controller: _passwordController,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty || password.length < 5) {
                    return 'Informe uma senha válida';
                  }
                  return null;
                },
              ),
              if (_isSignup())
                TextFormField(
                  decoration: InputDecoration(labelText: "Confirmar Senha"),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: _isLogin()
                      ? null
                      : (_password) {
                          final password = _password ?? '';
                          if (password != _passwordController.text) {
                            return 'Senhas não conferem';
                          }
                          return null;
                        },
                ),
              SizedBox(height: 20),
              if (_isLoading)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      )),
                  onPressed: _submit,
                  child: Text(
                    _authMode == AuthMode.Login ? "Entrar" : "Registrar",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              Spacer(),
              TextButton(
                onPressed: _swithAuthMode,
                child: Text(
                  _isLogin() ? "CADASTRAR" : "JÁ POSSUO CONTA",
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
