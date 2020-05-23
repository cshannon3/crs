import 'package:flutter/material.dart';
import 'flutter_wordpress.dart' as wp;
import 'display_posts.dart';

const PADDING_16 = EdgeInsets.all(16.0);
const PADDING_8 = EdgeInsets.all(8.0);

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
        centerTitle: true,
      ),
      body: LoginFields(),
    );
  }
}

class LoginFields extends StatefulWidget {
  @override
  LoginFieldsState createState() => LoginFieldsState();
}

class LoginFieldsState extends State<LoginFields> {
  String _username;
  String _password;
  bool _isDetailValid = true;
  bool _isValidating = false;

  @override
  void initState() {
    super.initState();
    _username = 'crssoccer3';
    _password = 'csoccer3';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
        child: SingleChildScrollView(
      child: Container(
        padding: PADDING_16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: PADDING_8,
              child: _buildFormField(
                icon: Icon(Icons.person),
                labelText: "Username",
                hintText: "Username",
                initialText: _username,
                onChanged: _onUsernameChanged,
              ),
            ),
            Padding(
              padding: PADDING_8,
              child: _buildFormField(
                icon: Icon(Icons.lock),
                labelText: "Password",
                hintText: "Password",
                initialText: _password,
                obscureText: true,
                onChanged: _onPasswordChanged,
              ),
            ),
            _isDetailValid
                ? SizedBox(
                    width: 0.0,
                    height: 0.0,
                  )
                : Padding(
                    padding: PADDING_8,
                    child: Text(
                      "Invalid Username / Password",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
            RaisedButton(
              onPressed: _isValidating ? () {} : _validateUser,
              color: Colors.blue,
              textColor: Colors.white,
              child: Padding(
                padding: PADDING_8,
                child: _isValidating
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      )
                    : Text('Login'),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget _buildFormField({
    Icon icon,
    String labelText,
    String hintText,
    String initialText,
    TextInputType inputType = TextInputType.text,
    bool obscureText = false,
    onChanged,
  }) {
    return TextField(
      decoration: InputDecoration(
        icon: icon,
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
      controller: TextEditingController(text: initialText),
      keyboardType: inputType,
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }

  void _onUsernameChanged(String value) {
    _username = value;
  }

  void _onPasswordChanged(String value) {
    _password = value;
  }

  void _validateUser() {
    setState(() {
      _isValidating = true;
    });

    wp.WordPress wordPress = new wp.WordPress(
      baseUrl: 'http://192.168.6.165',
      authenticator: wp.WordPressAuthenticator.JWT,
    );

    final response =
        wordPress.authenticateUser(username: _username, password: _password);

    response.then((user) {
      setState(() {
        _isDetailValid = true;
        _isValidating = false;

        _onValidUser(wordPress, user);
      });
    }).catchError((err) {
      print(err.toString());
      setState(() {
        _isDetailValid = false;
        _isValidating = false;
      });
    });
  }

  void _onValidUser(wp.WordPress wordPress, wp.User user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PostListPage(
              wordPress: wordPress,
            ),
      ),
    );
  }
}
