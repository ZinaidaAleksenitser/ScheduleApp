import './meeting.dart';
//import 'package:scalereal_tutirial/model/post_back_form.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class FormController {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbx1Ti4FuHH8kzsqqUqDuzL-XbysAuX-sNvIgoLg4F8lL8vY3sOMYgp9gPOyBkqEDDni/exec";

  static const STATUS_SUCCESS = "SUCCESS";

  Uri uri = Uri.parse(URL);

  Future <List<Meeting>> getAppointmentsList() async {
    http.Response data = await http.get(Uri.parse(URL));
    dynamic jsonAppData = convert.jsonDecode(data.body);
    final List<Meeting> appointmentData = [];
    for (dynamic data in jsonAppData) {
      Meeting meetingData = Meeting(
        eventName: data['Subject'],
        from: data['startTime'],
        to: data['endTime'],
      );
      appointmentData.add(meetingData);
    }
    return appointmentData;
  }
}