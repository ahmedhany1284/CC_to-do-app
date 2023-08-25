import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/shared/cubit/cubit.dart';

Widget defaultFormField({
  required bool readonly,
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  Function? onTap, // Update the parameter name to onTap
  required String? Function(String?)? validate,
  required String label,
  required IconData icon,
  bool is_clickable=true,
}) {
  return TextFormField(
    readOnly: readonly,
    controller: controller,
    keyboardType: type,
    enabled: is_clickable,
    onFieldSubmitted: onSubmit as void Function(String)?,
    onChanged: onChange as void Function(String)?,
    onTap: onTap as void Function()?,
    validator: validate,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      // border: OutlineInputBorder(),
    ),
  );
}
bool ok=false;


Widget buildTaskItem(Map model, context) => Dismissible(
  crossAxisEndOffset: 10,
  key: Key(model['id'].toString()),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      decoration: BoxDecoration(
        color:  Color.fromARGB(255, 35, 34 ,95),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            blurRadius: 3.0,
            spreadRadius: 2.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              backgroundColor:Color.fromARGB(255, 244, 65 ,52),
              child: Text(
                '${model['time']}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${model['date']}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.0),
            IconButton(
              onPressed: () {
                if(model['status']=='New'){
                  AppCubit.get(context).updatedata(
                    status: 'Done',
                    id: model['id'],
                  );
                }else{
                  AppCubit.get(context).updatedata(
                      status: 'New',
                      id: model['id'],
                  );
                }

              },
              icon: !(model['status'] == 'New')
                  ? Icon(Icons.check_box, color: Colors.green)
                  : Icon(Icons.check_box_outline_blank),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context).updatedata(
                  status: 'Archive',
                  id: model['id'],
                );
              },
              icon: Icon(Icons.archive, color: Colors.black45),
            ),
          ],
        ),
      ),
    ),
  ),
  onDismissed: (direction) {
    AppCubit.get(context).deletedata(id: model['id']);
  },
);


Widget taskBuilder({
  required List<Map>tasks,
  required String text,
})=>ConditionalBuilder(
  condition: tasks.length>0,
  builder: (context)=>ListView.separated(
    itemBuilder: (context,index)=>buildTaskItem(tasks[index],context),
    separatorBuilder: (context,index)=>Container(
      width: double.infinity,
      height: 0,
      color: Colors.grey[300],
    ),
    itemCount: tasks.length,
  ),
  fallback: (context)=>Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
      [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,

        ),
        Text(
          '${text}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15.0,
          ),
        ),
      ],
    ),
  ),
);

void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);