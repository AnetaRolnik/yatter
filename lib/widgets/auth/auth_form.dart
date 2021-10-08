import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading, {Key? key}) : super(key: key);

  final bool isLoading;
  final void Function(
    String email,
    String userName,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userName.trim(),
        _userPassword.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email address',
                  ),
                  validator: (val) {
                    if (EmailValidator.validate(val!) == false) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _userEmail = val!;
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('username'),
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                    validator: (val) {
                      if (val!.isEmpty || val.length < 4) {
                        return 'Password enter at least 4 characters.';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      _userName = val!;
                    },
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  validator: (val) {
                    if (val!.isEmpty || val.length < 6) {
                      return 'Password must be at least 6 characters long.';
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _userPassword = val!;
                  },
                ),
                const SizedBox(height: 12),
                widget.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        child: Text(_isLogin ? 'Log in' : 'Sign up'),
                        onPressed: _trySubmit,
                      ),
                TextButton(
                  child: Text(_isLogin
                      ? 'Create new account'
                      : 'I already have an account'),
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
