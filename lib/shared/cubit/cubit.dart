import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:to_do_list/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do_list/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do_list/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do_list/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates>
{
  AppCubit():super(AppinitialState());

  static AppCubit get(context) =>BlocProvider.of(context);

  int cur_var=0;
  List<Widget>screen=[New_Task_Screen(), Done_Task_Screen(), Archived_Task_Screen(),];

  List<String>titles=['New Tasks','Done Tasks', 'Archived Tasks'];
  late Database database;
  List<Map>new_tasks=[];
  List<Map>done_tasks=[];
  List<Map>archived_tasks=[];
  bool isBottomsheeetShown=false;
  IconData fabicon=Icons.edit;

  void createDatabase()  {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database,version){
        // id int
        // title string
        // date string
        // time string
        // status string

        print('database created');
        database.execute('CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT , status TEXT)').then((value) {
          print('table created');

        }).catchError((error){
          print('error when creating ${error.toString()}');
        });
      },
      onOpen: (database){
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value)
    {
      database=value;
      emit(AppCreateDataBaseState());
    }
    );
  }

   insertToDatabase({
    required String title,
    required String time,
    required String date,
  })async {
    await database.transaction((txn) async  {
        txn.rawInsert(
            'INSERT INTO tasks(title,date,time,status) VALUES("${title}","${date}","${time}","New")').then((value){
          print('${value}Inserted successfully');

        });
    }).then((value)
    {
      emit(AppInsertDataBaseState());
      getDataFromDatabase(database);
    }
    );
  }



  void getDataFromDatabase(database) {
    new_tasks=[];
    done_tasks=[];
    archived_tasks=[];
    emit(AppGetDataBaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'New') {
          new_tasks.add(element);
        } else if (element['status'] == 'Done') {
          done_tasks.add(element);
        } else {
          archived_tasks.add(element);
        }
      });
      emit(AppGetDataBaseState());
    });
  }


  void updatedata({
    required String status,
    required int id,
  }) async {
    database.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id],
      ).then((value) {
        getDataFromDatabase(database);
      emit(AppUpdateDataBaseState());
    });

  }



  void deletedata({
    required int id,
  }) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id])
      .then((value) {
        getDataFromDatabase(database);
      emit(AppDeleteDataBaseState());
    });

  }




  void change_Index(int index) {
    cur_var = index;
    emit(AppChangeBottomNavBarStates());
  }


  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  })
  {
    isBottomsheeetShown=isShow;
    fabicon=icon;

    emit(AppChangeBottomSheetStates());
  }
}