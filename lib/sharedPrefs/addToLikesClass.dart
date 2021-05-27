import 'package:shared_preferences/shared_preferences.dart';

addToLikes(int i) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> list = prefs.getStringList('favorites');

  if (list == null){
    List<String> temp = [];
    list = temp;
  }
  String id = i.toString();
  if (list.contains(id)){
    list.remove(id);
  } else {
    list.add(id);
  }
  await prefs.setStringList('favorites', list);
  print(prefs.getStringList('favorites'));
}