import 'package:detail_location_detector/pages/location/location_page.dart';
import 'package:detail_location_detector/pages/user/login/provider/login_provider.dart';
import 'package:detail_location_detector/pages/user/login/provider/login_validator_provider.dart';
import 'package:detail_location_detector/pages/user/register/register_page.dart';
import 'package:detail_location_detector/pages/widget/flat_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginFormState = ref.watch(loginValidatorProvider);

    final loginState = ref.watch(loginNotifierProvider);

    final loginFormNotifier = ref.read(loginValidatorProvider.notifier);

    final loginNotifier = ref.read(loginNotifierProvider.notifier);

    ref.listen<LoginState>(loginNotifierProvider, (_, loginState) {
      if (loginState.userProfile != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LocationPage()));
      } else if (loginState.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loginState.errorMessage!)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (email) => loginFormNotifier.emailChanged(email),
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: '이메일',
                hintText: '이메일을 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (password) =>
                  loginFormNotifier.passwordChanged(password),
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '패스워드',
                hintText: '패스워드를 입력하세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FlatButton(
              isActive: loginFormState.canSubmit && !loginState.isLoading,
              onPressed: () {
                final dto = loginFormNotifier.getEmailAndPassword();
                loginNotifier.login(dto);
              },
              text: '로그인',
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                // TODO: 회원가입 페이지로 이동
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterPage()));
              },
              child: const Text('허ㅣ원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
