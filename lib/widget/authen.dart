import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shoppingproject/utility/dialog.dart';
import 'package:shoppingproject/utility/my_style.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

class Authen extends StatefulWidget {
  Authen({Key? key}) : super(key: key);

  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  late double screen;
  bool statusRedEye = true;
  bool _isLogin = false;
  String? email, password;
  FirebaseAuth _auth = FirebaseAuth.instance;
  // FacebookLogin _facebookLogin = FacebookLogin();
  User? _user;

  @override
  Widget build(BuildContext context) {
    screen = MediaQuery.of(context).size.width;
    print('screen = $screen');
    return Scaffold(
      // ปุ่ม Register
      floatingActionButton: buildRegister(),
      // ปุ่ม Register
      body: Container(
        decoration: BoxDecoration(
            gradient: RadialGradient(
                center: Alignment(0, -0.3),
                radius: 1.2,
                colors: <Color>[Colors.white, MyStyle().lightColor])),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ส่วนของหน้า login ทั้งหมด
                buildLogo(),
                MyStyle().titleH1('ShoppingOnline'),
                buildEmail(),
                buildPassword(),
                buildLogin(),
                buildSignInGoogle(),
                buildSignInFacebook(),
                buildSignInTwitter(),
                buildSignInLine(),
                // ส่วนของหน้า login ทั้งหมด
              ],
            ),
          ),
        ),
      ),
    );
  }

  void lineSDKInit() async {
    await LineSDK.instance.setup("1655941024").then((_) {
      print("LineSDK is Prepared");
    });
  }

  @override
  void initState() {
    lineSDKInit();
    super.initState();
  }

  void startLineLogin() async {
    try {
      final result = await LineSDK.instance.login(scopes: ["profile"]);
      print(result.toString());
    } on FormatException catch (e) {
      print(e);
    }
    await Navigator.pushNamedAndRemoveUntil(
        context, '/myHome', (route) => false);
  }

  // ปุ่ม login with Line
  Container buildSignInLine() => Container(
        margin: EdgeInsets.only(top: 8),
        width: screen * 0.75,
        child: RaisedButton(
          color: Color.fromRGBO(0, 185, 0, 1),
          textColor: Colors.white,
          padding: const EdgeInsets.all(1),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Image.network(
                  'https://firebasestorage.googleapis.com/v0/b/messagingapitutorial.appspot.com/o/line_logo.png?alt=media&token=80b41ee6-9d77-45da-9744-2033e15f52b2',
                  width: 40,
                  height: 40,
                ),
                Container(
                  color: Colors.black12,
                  width: 2,
                  height: 40,
                ),
                Expanded(
                  child: Center(
                      child: Text("เข้าสู่ระบบด้วย LINE",
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold))),
                )
              ]),
            ],
          ),
          onPressed: () {
            startLineLogin();
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
  // ปุ่ม login with Line

  // ปุ่ม login with Twitter
  Container buildSignInTwitter() => Container(
        margin: EdgeInsets.only(top: 8),
        width: screen * 0.75,
        child: SignInButton(
          Buttons.Twitter,
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
  // ปุ่ม login with Twitter

  // ปุ่ม login with facebook
  Container buildSignInFacebook() => Container(
        margin: EdgeInsets.only(top: 8),
        width: screen * 0.75,
        child: SignInButton(
          Buttons.FacebookNew,
          onPressed: () async {
            await _handleLogin();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );

  // ปุ่ม login with facebook

  Future _handleLogin() async {
    // FacebookLoginResult _result = await _facebookLogin.logIn(['email']);
    // switch (_result.status) {
    //   case FacebookLoginStatus.cancelledByUser:
    //     print("cancelledByUser");
    //     break;
    //   case FacebookLoginStatus.error:
    //     print("error");
    //     break;
    //   case FacebookLoginStatus.loggedIn:
    //     await _loginWithFacebook(_result);
    //     break;
    //   default:
    // }
  }

  // Future _loginWithFacebook(FacebookLoginResult _result) async {
  //   FacebookAccessToken _accessToken = _result.accessToken;
  //   AuthCredential _credential =
  //       FacebookAuthProvider.credential(_accessToken.token);
  //   var a = await _auth.signInWithCredential(_credential);
  //   setState(() {
  //     _isLogin = true;
  //     _user = a.user;
  //   });
  //   await _auth.signInWithCredential(_credential).then((value) =>
  //       Navigator.pushNamedAndRemoveUntil(
  //           context, '/myHome', (route) => false));
  // }

  // ปุ่มlogin google
  Container buildSignInGoogle() => Container(
        margin: EdgeInsets.only(top: 8),
        width: screen * 0.75,
        child: SignInButton(
          Buttons.Google,
          onPressed: () => processSignInWithGoogle(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );

  Future<Null> processSignInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    await Firebase.initializeApp().then((value) async {
      await _googleSignIn.signIn().then((value) async {
        String? name = value!.displayName;
        String email = value.email;
        await value.authentication.then((value2) async {
          AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: value2.idToken,
            accessToken: value2.accessToken,
          );
          await FirebaseAuth.instance.signInWithCredential(authCredential).then(
              (value3) => Navigator.pushNamedAndRemoveUntil(
                  context, '/myHome', (route) => false));
        });
      });
    });
  }
  // ปุ่มlogin google

  // ปุ่ม register
  TextButton buildRegister() => TextButton(
        onPressed: () => Navigator.pushNamed(context, '/register'),
        child: Text(
          'New Register',
          style: TextStyle(color: Colors.white),
        ),
      );
  // ปุ่ม register

  // ปุ่ม login
  Container buildLogin() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.75,
      child: ElevatedButton(
        onPressed: () {
          if ((email?.isEmpty ?? true) || (password?.isEmpty ?? true)) {
            normalDialog(context, 'มีช่องว่าง?',
                'มีข้อมูลที่ไม่ได้กรอก ? กรุณากรอกข้อมูลในช่องว่าง'); //แจ้งเตือนเมื่อมีช่องว่าง
          } else {
            checkAuthen();
          }
        },
        child: Text('Login'),
        style: ElevatedButton.styleFrom(
          primary: MyStyle().primaryColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
  // ปุ่ม login

  //ช่องกรอก Email
  Container buildEmail() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white70,
      ),
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.75,
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        onChanged: (value) => email = value.trim(),
        style: TextStyle(color: MyStyle().darkColor),
        decoration: InputDecoration(
          hintStyle: TextStyle(color: MyStyle().darkColor),
          hintText: 'Email',
          prefixIcon: Icon(
            Icons.perm_identity,
            color: MyStyle().darkColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().lightColor),
          ),
        ),
      ),
    );
  }
  //ช่องกรอก Email

  //ช่องกรอก Password
  Container buildPassword() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white70),
      margin: EdgeInsets.only(top: 16),
      width: screen * 0.75,
      child: TextField(
        onChanged: (value) => password = value.trim(),
        obscureText: statusRedEye,
        style: TextStyle(color: MyStyle().darkColor),
        decoration: InputDecoration(
          suffixIcon: IconButton(
              icon: statusRedEye
                  ? Icon(
                      Icons.remove_red_eye_sharp,
                      color: MyStyle().primaryColor,
                    )
                  : Icon(
                      Icons.remove_red_eye_outlined,
                      color: MyStyle().primaryColor,
                    ),
              onPressed: () {
                setState(() {
                  statusRedEye = !statusRedEye;
                });
                print('statusRedEye = $statusRedEye');
              }),
          hintStyle: TextStyle(color: MyStyle().darkColor),
          hintText: 'Password',
          prefixIcon: Icon(
            Icons.lock_outlined,
            color: MyStyle().darkColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().darkColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: MyStyle().lightColor),
          ),
        ),
      ),
    );
  }
  //ช่องกรอก Password

  Container buildLogo() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: screen * 0.4,
      child: MyStyle().showLogo(),
    );
  }

  Future<Null> checkAuthen() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!)
          .then((value) => Navigator.pushNamedAndRemoveUntil(
              context, '/myHome', (route) => false))
          .catchError(
              (value) => normalDialog(context, value.code, value.message));
    });
  }
}
