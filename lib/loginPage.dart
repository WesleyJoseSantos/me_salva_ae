import 'package:flutter/material.dart';
import 'package:me_salva_ae/subscriptionPage.dart';
import 'studentPage.dart';
import 'teacherPage.dart';
import 'common.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login de usuário',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(title: 'Login de usuário'),
    );
  }
}

class _LoginPageState extends State<LoginPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  TextEditingController emailTextEditing = new TextEditingController();
  TextEditingController passTextEditing = new TextEditingController();

  void loginButtonOnPressed()
  {
    Usuario usuario = new Usuario(emailTextEditing.text, emailTextEditing.text, passTextEditing.text, UserTypes.desconhecido);
    AppErros loginError = appMeSalva.login(usuario);
    if (loginError == AppErros.ok) {
      if (appMeSalva.usuarioLogado.tipo == UserTypes.aluno) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentPage()),
        );
      }
      if (appMeSalva.usuarioLogado.tipo == UserTypes.professor)
      {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TeacherPage()),
        );
      }    
    } else if(loginError == AppErros.naoExistemUsuarios){
      showLoginError("Erro de autenticação.","Ainda não existem usuários cadastrados.");
    } else {
      showLoginError("Erro de autenticação.","Verifique suas credenciais e tente novamente.");
    }
  }

  void showLoginError(String title, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(text),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok!"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _signinButonOnPress()
  {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SubscriptionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {

    final emailField = TextField(
      obscureText: false,
      controller: emailTextEditing,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Usuário",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      controller: passTextEditing,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Senha",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: loginButtonOnPressed,
        child: Text("Entrar",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final signinButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _signinButonOnPress,
        child: Text("Inscrever-se",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      appBar: AppBar(
          title: Text("Me Salva Ae! - Login"),
          backgroundColor: Color(0xff01A0C7),
          centerTitle: true,
      ),
      body: Center(
        child:SingleChildScrollView(  
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 90.0,
                    child: Icon(Icons.account_circle,
                                size: 80,
                                color: Color(0xff01A0C7),),
                    //fit: BoxFit.contain,
                    //),
                  ),
                  SizedBox(height: 40.0),
                  emailField,
                  SizedBox(height: 25.0),
                  passwordField,
                  SizedBox(
                    height: 30.0,
                  ),
                  loginButon,
                  SizedBox(
                    height: 30.0,
                  ),
                  signinButon,
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}