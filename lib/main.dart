import 'package:flutter/material.dart';
import 'package:schedule_app/meeting.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';

void main() {
  return runApp(GoogleSheetData());
}

class GoogleSheetData extends StatefulWidget {
  @override
  LoadDataFromGoogleSheetState createState() => LoadDataFromGoogleSheetState();
}

class LoadDataFromGoogleSheetState extends State<GoogleSheetData> {
  MeetingDataSource? events;
  Future<List<Meeting>>? _results;
  DateFormat format = DateFormat('yyyy-MM-dd hh:mm');

  @override
  void initState() {
    super.initState();
    _results = getDataFromGoogleSheet();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _results,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return SafeArea(
                child: Container(
                  child: SfCalendar(
                    view: CalendarView.month,
                    monthViewSettings: MonthViewSettings(showAgenda: true),
                    dataSource: MeetingDataSource(snapshot.data),
                    initialDisplayDate: DateTime.now(),
                  ),
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: Text('Loading....'),
                ),
              );
            }
          },
        ),
      ),
    ));
  }

  Future<List<Meeting>> getDataFromGoogleSheet() async {
    http.Response data = await http.get(
      Uri.parse(
          "https://script.google.com/macros/s/AKfycbx1Ti4FuHH8kzsqqUqDuzL-XbysAuX-sNvIgoLg4F8lL8vY3sOMYgp9gPOyBkqEDDni/exec"),
    );
    dynamic jsonAppData = convert.jsonDecode(data.body);
    List<Meeting> appointmentData = [];
    for (dynamic data in jsonAppData) {
      Meeting meetingData = Meeting(
        eventName: data['Subject'],
        from: _convertDateFromString(data['StartTime']),
        to: _convertDateFromString(data['SndTime']),
      );
      appointmentData.add(meetingData);
    }
    return appointmentData;
  }

  DateTime _convertDateFromString(String date) {
    return format.parse(date);
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }
}
