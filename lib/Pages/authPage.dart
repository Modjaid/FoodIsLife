import 'package:flutter/material.dart';

class AutorizationPage extends StatefulWidget {
  @override
  _AutorizationPageState createState() => _AutorizationPageState();
}

class _AutorizationPageState extends State<AutorizationPage> {
  TextEditingController _mailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _mail;
  String _password;
  bool showLogin = true;

  DatabaseService _authService = DatabaseService();

  void _loginButtonAction() async {
    _mail = _mailController.text;
    _password = _passwordController.text;

    if (_mail.isEmpty || _password.isEmpty) return;

    User user = await _authService.signInWithEmailAndPassword(
        _mail.trim(), _password.trim());
    if (user == null) {
      Fluttertoast.showToast(
          msg: "Не удалось войти. Пожалуйста проверьте логи и пароль",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Navigator.pop(
        context,
        MaterialPageRoute(builder: (context) => AdminTablePage()),
      );
      // _mailController.clear();
      // _passwordController.clear();
    }
  }

  void _registerButtonAction() async {
    _mail = _mailController.text;
    _password = _passwordController.text;

    if (_mail.isEmpty || _password.isEmpty) return;

    User user = await _authService.registerWithEmailAndPassword(
        _mail.trim(), _password.trim());
    if (user == null) {
      Fluttertoast.showToast(
          msg: "Не удалось войти. Пожалуйста проверьте логи и пароль",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      _mailController.clear();
      _passwordController.clear();
    }
  }

  Widget _bottomWave() {
    return Expanded(
      child: Align(
        child: ClipPath(
          child: Container(
            color: Colors.white,
            height: 300,
          ),
          clipper: BottomWaveClipper(),
        ),
        alignment: Alignment.bottomCenter,
      ),
    );
  }

  Widget _button(String text, void func()) {
    return RaisedButton(
      splashColor: Theme.of(context).primaryColor,
      highlightColor: Theme.of(context).primaryColor,
      color: Colors.white,
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
            fontSize: 20),
      ),
      onPressed: func,
    );
  }

  Widget _input(
      Icon icon, String hint, TextEditingController controller, bool obscure) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(fontSize: 20, color: Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white60),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green[900], width: 3)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black38, width: 1)),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: IconTheme(
              data: IconThemeData(color: Colors.black),
              child: icon,
            ),
          ),
        ),
        cursorColor: Colors.black,
      ),
    );
  }

  Widget _form(String label, void func()) {
    return SizedBox(
      width: 600,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: _input(Icon(Icons.email), 'EMAIL', _mailController, false),
          ),

          // Padding(
          //   padding:
          //       EdgeInsets.only(bottom: 20, top: 10, left: 200, right: 200),
          //   child: _input(Icon(Icons.email), 'EMAIL', _mailController, false),
          // ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child:
                _input(Icon(Icons.lock), 'PASSWORD', _passwordController, true),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: _button(label, func),
            ),
          )
        ],
      ),
    );
  }

  Widget _logo() {
    return Padding(
      padding: EdgeInsets.only(top: 100),
      child: Container(
        child: Align(
          child: Text(
            'Hlam - blaM',
            style: TextStyle(
                fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: <Widget>[
            _logo(),
            SizedBox(
              height: 50,
            ),
            (showLogin
                ? Column(
                    children: <Widget>[
                      _form('LOGIN', _loginButtonAction),
                    ],
                  )
                : Column(
                    children: <Widget>[
                      _form('REGISTER', _registerButtonAction),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                            child: Text('Already Registered yet? Login!',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                            onTap: () {
                              setState(() {
                                showLogin = true;
                              });
                            }),
                      )
                    ],
                  )),
            _bottomWave(),
          ],
        ));
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height + 5);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
