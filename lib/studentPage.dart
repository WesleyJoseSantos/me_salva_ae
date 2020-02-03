import 'package:flutter/material.dart';
import 'common.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class StudentPage extends StatefulWidget {
  StudentPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _StudentPageState createState() => _StudentPageState();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Página do Aluno',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentPage(title: 'Página do Aluno'),
    );
  }
}

class _StudentPageState extends State<StudentPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  DropdownButtonBuilder dropdownClass = new DropdownButtonBuilder();
  DropdownButtonBuilder dropdownDay = new DropdownButtonBuilder();
  DropdownButtonBuilder dropdownTime = new DropdownButtonBuilder();
  Dismissible lastDismiss;

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
          leading: const Icon(Icons.school),
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
                  Icon(Icons.class_)]
                ,),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 25.0, 5.0),
                child: Column(children: <Widget>[
                  Text(turma.aula.getNameString(), style: listStyle,),]
                ,),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 25.0, 5.0),
                child: Column(children: <Widget>[
                  Text(turma.aula.getDiaString(), style: listStyle,),]
                ,),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 5.0, 25.0, 5.0),
                child: Column(children: <Widget>[
                  Text(turma.aula.getHorarioString(), style: listStyle,),]
                ,),
              )
            ]),
        ),
        onDismissed: (direction){
          setState(() {
            user.agenda.turmas.remove(turma);
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
    return(classList);
  }

  List<Widget> searchTeacher(Aluno student, BuildContext context)
  {
    List<Widget> profList = new List<Widget>();
    int indice;
    Aula aula = Aula(classes.indexOf(dropdownClassIt),
                     days.indexOf(dropdownDayIt),
                     times.indexOf(dropdownTimeIt));
    List<Professor> professoresEncontrados = new List<Professor>();
    professoresEncontrados = appMeSalva.searchProf(aula);
    for (var prof in professoresEncontrados) {
      Dismissible it;
      it = new Dismissible(
        key: Key(professoresEncontrados.indexOf(prof).toString()),
        background: Container(
          color: Colors.green,
          child: Align(
            alignment: Alignment(-0.9, 0),
            child: Icon(
              Icons.add_box,
              color: Colors.white,
            ),
          ),
        ),
        direction: DismissDirection.startToEnd,
        child: ListTile(
          leading: Icon(Icons.work),
          title: Text(prof.nome),
          trailing: Icon(Icons.star),
        ),
        onDismissed: (direction){
          setState(() {
            Turma turma = new Turma(prof, aula); 
            student.agenda.turmas.add(turma);
            prof.agenda.turmas.add(turma);
            turma.alunos.add(student);
            indice = profList.indexOf(it);
            profList.remove(it);
            professoresEncontrados.remove(prof);
            lastDismiss = it;
          });
          final alerta = SnackBar(
            content: Text(
                'Disciplina agendada com sucesso!'),
            action: SnackBarAction(
              label: 'Desfazer',
              onPressed: () {
                setState(() {
                  profList.insert(indice, it);
                  professoresEncontrados.add(prof);
                });
              },
            ),
            duration: Duration(seconds: 2),
          );
          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(alerta);
        },
      );
      if(lastDismiss != null){
        if(lastDismiss.key != it.key){
          profList.add(it);
          profList.add(const Divider(
                height: 1.0,
              ));
        }
      }
      else{
        profList.add(it);
        profList.add(const Divider(
              height: 1.0,
            ));
      }
    }
    return(profList);
  } 

  @override
  Widget build(BuildContext context) {
    Aluno student = appMeSalva.usuarioLogado;
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
                Tab(icon: Icon(Icons.class_),
                  text: 'Disciplinas'
                ),
                Tab(icon: Icon(Icons.date_range),
                  text: 'Agenda'
                ),
                Tab(icon: Icon(Icons.search),
                  text: 'Buscar'
                ),
              ],
            ),
            title: Text('Menu do Aluno'),
          ),
          body: TabBarView(
            children: [
              //Aba Disciplinas
              SingleChildScrollView( 
                child: new Column(
                  children: getClasses(student, context)
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
              SingleChildScrollView( 
                child: new Column(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.class_),
                      title: Text('Disciplina'),
                      trailing: dropdownClass.get(
                        names: <String>['Matemática','Física','Química','Met. Cientfíca', 'Todas'],
                        dropdownItem: dropdownClassIt,
                        onChange: dropdownClassOnChanged
                      ),
                    ),
                    const Divider(height: 1.0,),
                    ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text('Dia'),
                        trailing: dropdownDay.get(
                          names: <String>['Segunda','Terça','Quarta','Quinta', 'Sexta', 'Sábado', 'Domingo', 'Todos'],
                          dropdownItem: dropdownDayIt,
                          onChange: dropdownDayOnChanged,
                      ),
                    ),
                    const Divider(height: 1.0,),
                    ListTile(
                      leading: const Icon(Icons.timer),
                      title: Text('Hora'),
                      trailing:dropdownTime.get(
                        names: <String>['Manhã','Tarde','Noite', 'Todos'],
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
                              lastDismiss = null;
                              searchTeacher(student, context);
                            });
                          },
                          child: Text("Buscar",
                              textAlign: TextAlign.center,
                              style: style.copyWith(
                                  color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      )
                    ),
                    const Divider(height: 1.0,),
                    Column(
                      children: searchTeacher(student, context)
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