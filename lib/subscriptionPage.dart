import 'package:flutter/material.dart';
import 'package:me_salva_ae/common.dart';
import 'studentPage.dart';
import 'teacherPage.dart';
import 'common.dart';

class SubscriptionPage extends StatefulWidget {
  SubscriptionPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Me Salva Ae! - Inscrição',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SubscriptionPage(title: 'Me Salva Ae! - Inscrição'),
    );
  }
}


class _SubscriptionPageState extends State<SubscriptionPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  String dropdownValue = 'Aluno';
  Icon profileIcon = Icon(Icons.school);

  TextEditingController nameText = new TextEditingController();
  TextEditingController emailText = new TextEditingController();
  TextEditingController passText = new TextEditingController();
  TextEditingController passConfirmText = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    String validateEmail(String value) {
      if (value.isEmpty) {
        // The form is empty
        return "Informe o endereço de e-mail";
      }
      // This is just a regular expression for email addresses
      String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
          "\\@" +
          "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
          "(" +
          "\\." +
          "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
          ")+";
      RegExp regExp = new RegExp(p);

      if (regExp.hasMatch(value)) {
        // So, the email is valid
        return null;
      }

      // The pattern of the email didn't match the regex above.
      return 'O e-mail informado é inválido';
    }

    void showError(String title, String text) {
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

    void saveProfileOnPressed() {
      AppErros err;
      Aluno novoAluno;
      Professor novoProf;
      if(passText.text != passConfirmText.text)
      {
        showError("Erro na verificação da senha.", "Verifique se as senhas informadas são iguais.");
        return;
      }
      if (dropdownValue == 'Aluno') {
        novoAluno = new Aluno(nameText.text, emailText.text, passText.text, UserTypes.aluno);
        err = appMeSalva.criarUsuario(novoAluno);
      }
      if (dropdownValue == 'Professor')
      {
        novoProf = new Professor(nameText.text, emailText.text, passText.text, UserTypes.professor);
        if(err == AppErros.ok) appMeSalva.usuarioLogado = novoProf;
        err = appMeSalva.criarUsuario(novoProf);
      }
      if(err == AppErros.emailJaExiste)
      {
        showError("Erro ao criar usuário.", "O email informado já está em uso.");
        return;
      }
      if(err == AppErros.nomeJaExiste)
      {
        showError("Erro ao criar usuário.", "O nome informado já está em uso.");
        return;
      }
      if (dropdownValue == 'Aluno') {
        appMeSalva.usuarioLogado = novoAluno;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentPage()),
        );
      }
      if (dropdownValue == 'Professor') {
        appMeSalva.usuarioLogado = novoProf;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TeacherPage()),
        );
      }
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Me Salva Ae! - Inscrição'),
        backgroundColor: Color(0xff01A0C7),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.save), onPressed: (saveProfileOnPressed))
        ],
      ),
      body: SingleChildScrollView( 
        child: new Column(
          children: <Widget>[
            new ListTile(
              leading: profileIcon,
              title: Text('Tipo do Perfil'),
              trailing: new DropdownButton(
                value: dropdownValue,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(
                  color: Colors.black
                ),
                underline: Container(
                  height: 2,
                  //color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue){
                  setState(() {
                    dropdownValue = newValue;
                    if (dropdownValue == 'Aluno') {
                      profileIcon = Icon(Icons.school);
                    }
                    if (dropdownValue == 'Professor')
                    {
                      profileIcon = Icon(Icons.work);
                    }
                  });
                },
                items: <String>['Aluno','Professor'].map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            const Divider(
              height: 1.0,
            ),
            new ListTile(
              leading: const Icon(Icons.person),
              title: new TextField(
                controller: nameText,
                decoration: new InputDecoration(
                  hintText: "Nome",
                  
                ),
              ),
            ),
            new ListTile(
              leading: const Icon(Icons.email),
              title: new TextFormField(
                controller: emailText,
                decoration: new InputDecoration(
                  hintText: "Email",
                ),
                validator: validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            const Divider(
              height: 1.0,
            ),
            new ListTile(
              leading: const Icon(Icons.vpn_key),
              title: new TextField(
                controller: passText,
                obscureText: true,
                decoration: new InputDecoration(
                  hintText: "Senha",
                ),
              ),
            ),
            new ListTile(
              leading: const Icon(Icons.vpn_key),
              title: new TextField(
                controller: passConfirmText,
                obscureText: true,
                decoration: new InputDecoration(
                  hintText: "Confirme a Senha",
                ),
              ),
            ),
            const Divider(
              height: 1.0,
            ),
            
          ],
        ),
      ),
    );
  }
}