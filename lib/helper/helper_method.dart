// return a formatted data as a string

import 'package:cloud_firestore/cloud_firestore.dart';

String formatData(Timestamp time){
  //timestamp is aobject retrieved from firebase
  //so to display it lets convert it to a string

  DateTime dateTime = time.toDate();

  //get year
  String year = dateTime.year.toString();

  //get months
  String month = dateTime.month.toString();

  //get day
  String day = dateTime.day.toString();

  //get hour
  String hour = dateTime.hour.toString();

  //get minute
  String min = dateTime.minute.toString();

  //get seconds
  String secs = dateTime.second.toString();

  //final formatted date
  String formattedData = day + '/' + month + '/' + year+" "+hour+":"+min+":"+secs;

  return formattedData;
}