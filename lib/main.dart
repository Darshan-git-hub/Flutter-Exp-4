import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Course {
  String title;
  double fee;
  String duration;
  Course({required this.title, required this.fee, required this.duration});
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final List<Course> courseList = [
    Course(title: "Python Basics", fee: 2000, duration: "4 weeks"),
    Course(title: "Flutter Development", fee: 2500, duration: "6 weeks"),
    Course(title: "Web Development", fee: 1500, duration: "8 weeks"),
    Course(title: "Data Science", fee: 1000, duration: "10 weeks"),
    Course(title: "Machine Learning", fee: 10000, duration: "12 weeks")
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Coding Platform",
      home: Scaffold(
        appBar: AppBar(title: Text('Enroll in Coding Courses'), backgroundColor: Color.fromARGB(255, 155, 94, 253), centerTitle: true,),
        body: ListView.builder(
          itemCount: courseList.length,
          itemBuilder: (context, index) {
            final course = courseList[index];
            return Column(
              children: [
                SizedBox(height: 10),
                ListTile(
                  leading: CircleAvatar(
                    child: Text(course.title[0]),
                  ),
                  title: Text(course.title),
                  subtitle: Text("₹.${course.fee}, Duration:${course.duration}"),
                  trailing: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green, foregroundColor: Colors.white
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Enrollment Form"),
                          content: Text("${course.title} Enrollment Confirmed!"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"))
                          ],
                        )
                      );
                    },
                    child: Text("Enroll Now")),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("${course.title} is selected"),
                        duration: Duration(seconds: 2),
                      ));
                  },
                )
              ],
            );
          },
        )
      )
    );
  }
}
