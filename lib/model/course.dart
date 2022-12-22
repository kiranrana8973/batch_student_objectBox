import 'package:institute_objectbox/model/teacher.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Course {
  @Id(assignable: true)
  int courseId;
  String courseName;

  final teacher = ToMany<Teacher>();

  Course(this.courseName, {this.courseId = 0});
}
