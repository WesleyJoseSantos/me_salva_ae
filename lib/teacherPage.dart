import 'package:flutter/material.dart';
import 'common.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class TeacherPage extends StatefulWidget {
  TeacherPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu do Professor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TeacherPage(title: 'Menu do Professor'),
    );
  }
}

class _TeacherPageState extends State<TeacherPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  DropdownButtonBuilder dropdownClass = new DropdownButtonBuilder();
  DropdownButtonBuilder dropdownDay = new DropdownButtonBuilder();
  DropdownButtonBuilder dropdownTime = new DropdownButtonBuilder();

  String dropdownClassIt = 'Matemática';
  String dropdownDayIt = 'Segunda';
  String dropdownTimeIt = 'Manhã';

  DateTime _currentDate;

  void dropdownClassOnChanged(dynamic newValue)
  {
    setState(() {
      dropdownClassIt = newValue;
    });
  }

  void dropdownDayOnChanged(dynamic newValue)
  {
    setState(() {
      dropdownDayIt = newValue;
    });
  }

  void dropdownTimeOnChanged(dynamic newValue)
  {
    setState(() {
      dropdownTimeIt = newValue;
    });
  }

  static TextStyle listStyle = new TextStyle(
    fontSize: 12,
  );

  
  List<Widget> getClasses(Usuario user, BuildContext context){
    List<Widget> classList = new List<Widget>();
    classList.add(
        new ListTile(
          leading: const Icon(Icons.work),
          title: new Text(appMeSalva.usuarioLogado.nome),
        ),
      );
      classList.add(
        new ListTile(
          leading: const Icon(Icons.email),
          title: new Text(appMeSalva.usuarioLogado.email),
        ),
      );
    for (Turma turma in user.agenda.turmas) {
      for (Aluno aluno in turma.alunos) {
        Dismissible it;
        it = new Dismissible(
          key: Key(user.agenda.turmas.indexOf(turma).toString()),
          background: Container(
            color: Colors.red,
            child: Align(
              alignment: Alignment(-0.9, 0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ),
          direction: DismissDirection.startToEnd,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  child: Column(children: <Widget>[
                    Icon(Icons.school)]
                  ,),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 25.0, 5.0),
                  child: Column(children: <Widget>[
                    Text(aluno.nome, style: listStyle,),]
                  ,),
                ),
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(20.0, 5.0, 25.0, 5.0),
                //   child: Column(children: <Widget>[
                //     Text(turma.aula.getNameString(), style: listStyle,),]
                //   ,),
                // ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 25.0, 5.0),
                  child: Column(children: <Widget>[
                    Text(turma.aula.getHorarioString(), style: listStyle,),]
                  ,),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 25.0, 5.0),
                  child: Column(children: <Widget>[
                    Text(turma.aula.getDiaString(), style: listStyle,),]
                  ,),
                )
              ]),
          ),
          onDismissed: (direction){
            setState(() {
              turma.alunos.remove(aluno);
              aluno.agenda.turmas.remove(turma);
              classList.remove(it);
            });
            final alerta = SnackBar(
              content: Text(
                  'Aula apagada com sucesso!'),
              action: SnackBarAction(
                label: 'Desfazer',
                onPressed: () {
                  // setState(() {
                  //   profList.insert(indice, it);
                  //   professoresEncontrados.add(prof);
                  // });
                },
              ),
              duration: Duration(seconds: 2),
            );
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(alerta);
          },
        );
        classList.add(it);
      }
    }
    return(classList);
  }

  List<Widget> getDisponipilidade(Professor prof, BuildContext context)
  {
    List<Widget> dispList = new List<Widget>();
    List<Turma> turmasProf = prof.agenda.turmas;
    int indice;
    for (var turma in turmasProf) {
      Aula disp = turma.aula;
      Dismissible it;
      it = new Dismissible(
        key: Key(turmasProf.indexOf(turma).toString()),
        background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment(-0.9, 0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        direction: DismissDirection.startToEnd,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                child: Column(children: <Widget>[
                  Icon(Icons.class_)]
                ,),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 25.0, 5.0),
                child: Column(children: <Widget>[
                  Text(classes[disp.disciplina], style: listStyle,),]
                ,),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 25.0, 5.0),
                child: Column(children: <Widget>[
                  Text(days[disp.dia], style: listStyle,),]
                ,),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 25.0, 5.0),
                child: Column(children: <Widget>[
                  Text(times[disp.horario], style: listStyle,),]
                ,),
              )
            ]),
        ),
        onDismissed: (direction){
          setState(() { 
            indice = dispList.indexOf(it);
            dispList.remove(it);
            turmasProf.remove(turma);
          });
          final alerta = SnackBar(
            content: Text(
                'Disciplina removida com sucesso!'),
            action: SnackBarAction(
              label: 'Desfazer',
              onPressed: () {
                setState(() {
                  dispList.insert(indice, it);
                  turmasProf.add(turma);
                });
              },
            ),
            duration: Duration(seconds: 2),
          );
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(alerta);
        },
      );
      
      // ListTile it = new ListTile(
      //   leading: Text(classes[disp.disciplina]),
      //   title: Text(days[disp.dia]),
      //   trailing: Text(times[disp.horario]),
      // );
      dispList.add(it);
      dispList.add(const Divider(
              height: 1.0,
            ));
    }
    return(dispList);
  }

  @override
  Widget build(BuildContext context) {
    Professor prof = appMeSalva.usuarioLogado;
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              new IconButton(icon: const Icon(Icons.exit_to_app), onPressed: (){
                while(Navigator.canPop(context)){
                  Navigator.pop(context);
                }
              })
            ],
          backgroundColor: Color(0xff01A0C7),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.school),
                  text: 'Alunos'
                ),
                Tab(icon: Icon(Icons.date_range),
                  text: 'Agenda'
                ),
                Tab(icon: Icon(Icons.class_),
                  text: 'Criar Aula'
                ),
              ],
            ),
            title: Text('Menu do Professor'),
          ),
          body: TabBarView(
            children: [
              //Aba Alunos
              SingleChildScrollView( 
                child: new Column(
                  children: getClasses(prof, context)
                )
              ),
              //Aba Calendário:
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: CalendarCarousel(
                  //current: DateTime.now(),
                  onDayPressed: (DateTime date, events) {
                    this.setState(() => _currentDate = date);
                  },
                  thisMonthDayBorderColor: Colors.grey,
                  height: 420.0,
                  selectedDateTime: _currentDate,
                  daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
                  //markedDatesMap: _markedDateMap,
            //          weekendStyle: TextStyle(
            //            color: Colors.red,
            //          ),
            //          weekDays: null, /// for pass null when you do not want to render weekDays
            //          headerText: Container( /// Example for rendering custom header
            //            child: Text('Custom Header'),
            //          ),
                ),
              ),
              //Aba pesquisar
              SingleChildScrollView( 
                child: new Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.class_),
                      title: Text('Disciplina'),
                      trailing: dropdownClass.get(
                        names: classes,
                        dropdownItem: dropdownClassIt,
                        onChange: dropdownClassOnChanged
                      ),
                    ),
                    const Divider(height: 1.0,),
                    ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text('Dia'),
                        trailing: dropdownDay.get(
                          names: days,
                          dropdownItem: dropdownDayIt,
                          onChange: dropdownDayOnChanged
                      ),
                    ),
                    const Divider(height: 1.0,),
                    ListTile(
                      leading: const Icon(Icons.timer),
                      title: Text('Hora'),
                      trailing:dropdownTime.get(
                        names: times,
                        dropdownItem: dropdownTimeIt,
                        onChange: dropdownTimeOnChanged,
                      ),
                    ),
                    const Divider(height: 1.0,),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xff01A0C7),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: (){
                              setState(() {
                                Aula aula = new Aula(classes.indexOf(dropdownClassIt),
                                                                  days.indexOf(dropdownDayIt),
                                                                  times.indexOf(dropdownTimeIt));
                                Turma turma = new Turma(prof, aula);
                                prof.criarTurma(turma);
                                //prof.disponibilidade.add();
                              });
                            },
                          child: Text("Criar",
                              textAlign: TextAlign.center,
                              style: style.copyWith(
                                  color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ),
                    const Divider(height: 1.0,),
                    Column(
                      children: getDisponipilidade(prof, context)
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}