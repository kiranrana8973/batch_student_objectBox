import 'package:flutter/material.dart';
import 'package:institute_objectbox/model/batch.dart';
import 'package:institute_objectbox/model/teacher.dart';
import 'package:path_provider/path_provider.dart';

import '../model/course.dart';
import '../model/student.dart';
import '../objectbox.g.dart';

class ObjectBoxInstance {
  late final Store _store;
  late final Box<Batch> _batch;
  late final Box<Student> _student;

  // For many to many
  late final Box<Teacher> _teacher;
  late final Box<Course> _course;
  // Constructor
  ObjectBoxInstance(this._store) {
    _batch = Box<Batch>(_store);
    _student = Box<Student>(_store);
    _teacher = Box<Teacher>(_store);
    _course = Box<Course>(_store);
    insertBatches();
    insertTeacherAndCOurse();
  }

  insertTeacherAndCOurse() {
    List<Teacher> lstTeacher = getAllTeacher();
    List<Course> lstCourse = getAllCourse();
    if (lstTeacher.isEmpty) {
      final teacher = Teacher('Kiran');
      final course = Course('Mobile');
      final course1 = Course('Web');

      teacher.course.add(course);
      teacher.course.add(course1);
      addTeacher(teacher);
    }

    if (lstTeacher.isNotEmpty) {
      final course = Course('Dataase');
      final teacher = Teacher('Achyut');
      course.teacher.add(teacher);

      addCourse(course);
    }

    final teacher = getAllTeacher();
    final course = getAllCourse();

    for (Teacher t in teacher) {
      debugPrint(t.fname);
    }

    for (Course c in course) {
      debugPrint('${c.courseId}.${c.courseName}');
    }

    // // Printing Teacher
    // for (Teacher t in teacher) {
    //   print(t.fname);
    //   for (Course c in t.course) {
    //     print(c.courseName);
    //   }
    // }

    // // Printing course
    // final course = getAllCourse();
    // for (Course c in course) {
    //   print(c.courseName);
    //   for (Teacher t in c.teacher) {
    //     print(t.fname);
    //   }
    // }
  }

  // For teacher
  int addTeacher(Teacher teacher) {
    return _teacher.put(teacher);
  }

  List<Teacher> getAllTeacher() {
    return _teacher.getAll();
  }

  // For course
  int addCourse(Course course) {
    return _course.put(course);
  }

  List<Course> getAllCourse() {
    return _course.getAll();
  }

  static Future<ObjectBoxInstance> init() async {
    var dir = await getApplicationDocumentsDirectory();
    final store = Store(
      getObjectBoxModel(),
      directory: '${dir.path}/student_course',
    );

    return ObjectBoxInstance(store);
  }

  // For initial data
  void insertBatches() {
    List<Batch> lstBatches = getAllBatch();
    if (lstBatches.isEmpty) {
      addBatch(Batch('29-A'));
      addBatch(Batch('29-B'));
      addBatch(Batch('28-A'));
      addBatch(Batch('28-B'));
    }
  }

  // For Batch
  int addBatch(Batch batch) {
    return _batch.put(batch);
  }

  List<Batch> getAllBatch() {
    return _batch.getAll();
  }

  //Search student by batchName
  List<Student> getStudentByBatchName(String batchName) {
    return _batch
        .query(Batch_.batchName.equals(batchName))
        .build()
        .findFirst()!
        .student;
  }

  //For Student
  int addStudent(Student student) {
    return _student.put(student);
  }

  List<Student> getAllStudent() {
    return _student.getAll();
  }

  // Login student
  Student? loginStudent(String username, String password) {
    return _student
        .query(Student_.username.equals(username) &
            Student_.password.equals(password))
        .build()
        .findFirst();
  }
}
