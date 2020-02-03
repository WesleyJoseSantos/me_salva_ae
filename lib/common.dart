import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

MeSalvaAeBase appMeSalva = new MeSalvaAeBase();

List<String> classes = ['Matemática','Física','Química','Met. Cientfíca', 'Todas'];
List<String> days = ['Segunda','Terça','Quarta','Quinta', 'Sexta', 'Sábado', 'Domingo', 'Todos'];
List<String> times = ['Manhã','Tarde','Noite', 'Todos'];

enum UserTypes
{
  desconhecido, aluno, professor
}

enum AppErros
{
  ok,
  naoExistemUsuarios,
  emailJaExiste,
  nomeJaExiste,
  usuarioNaoExiste,
  senhaIncorreta,
}

enum ProfErrors
{
  ok,

}

class MeSalvaAeBase
{

  List<Usuario> usuarios;
  Usuario usuarioLogado;

  MeSalvaAeBase()
  {
    usuarios = new List<Usuario>();
    usuarioLogado = new Usuario("", "", "", UserTypes.desconhecido);
  }

  AppErros criarUsuario(Usuario novoUsuario)
  {
    for (var usuario in usuarios) {
      if(usuario.email == novoUsuario.email)
      return(AppErros.emailJaExiste);
      if(usuario.nome == novoUsuario.nome)
      return(AppErros.nomeJaExiste);
    }
    usuarios.add(novoUsuario);
    return(AppErros.ok);
  }

  AppErros login(Usuario loginUsuario)
  {
    if(usuarios == null || usuarios.isEmpty) return(AppErros.naoExistemUsuarios);
    for (var usuario in usuarios) {
      if(usuario.email == loginUsuario.email || usuario.nome == loginUsuario.nome)
      {
        if(usuario.senha != loginUsuario.senha) return(AppErros.senhaIncorreta);
        usuarioLogado = usuario;
        return(AppErros.ok);
      }
    }
    return(AppErros.usuarioNaoExiste);
  }

  List<Professor> searchProf(Aula aula){
    List<Professor> profEncontrados = new List<Professor>();
    for (var user in appMeSalva.usuarios) {
      if(user.tipo == UserTypes.professor){
        Professor prof = user;
        for (var turma in prof.agenda.turmas) {
          Aula disp = turma.aula;
          if((aula.disciplina == disp.disciplina || aula.disciplina == 4) &&
             (aula.dia == disp.dia || aula.dia == 7) &&
             (aula.horario == disp.horario || aula.horario == 3 )){
               profEncontrados.add(prof);
             }
        }
      }
    }
    return(profEncontrados);
  }
}

class Aluno extends Usuario
{
  Aluno(String nome, String email, String senha, UserTypes tipo) : super(nome,email,senha,tipo);

}

class Professor extends Usuario
{
  Professor(String nome, String email, String senha, UserTypes tipo) : super(nome,email,senha,tipo);
  
  void criarTurma(Turma turma){
    turma.professor = this;
    this.agenda.turmas.add(turma);
  }
}

class Usuario
{
  String nome;
  String email;
  String senha;
  int avaliacao;
  UserTypes tipo;
  Agenda agenda;

  Usuario(this.nome, this.email, this.senha, this.tipo){
    agenda = new Agenda();
    avaliacao = 0;
  }
}

class Turma
{
  List<Aluno> alunos;
  Professor professor;
  Aula aula;

  Turma(this.professor, this.aula){
    alunos = new List<Aluno>();
  }
}

class Agenda
{
  List<Turma> turmas;

  Agenda(){
    turmas = new List<Turma>();
  }
}

class Aula
{
  Aula(this.disciplina, this.dia, this.horario);
  String getNameString(){return(classes[disciplina]);}
  String getDiaString(){return(days[dia]);}
  String getHorarioString(){return(times[horario]);}
  int disciplina;
  int dia;
  int horario;
}

class DropdownButtonBuilder
{
  DropdownButton get({List<String> names, String dropdownItem, Function onChange})
  {
    return(new DropdownButton(
    value: dropdownItem,
    icon: Icon(Icons.arrow_drop_down),
    iconSize: 24,
    elevation: 16,
    style: TextStyle(
      color: Colors.black
    ),
    underline: Container(
      height: 2,
    ),
    onChanged: onChange,
    items: names.map<DropdownMenuItem<String>>((String value){
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    ));
  }

}

