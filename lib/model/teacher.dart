import 'package:institute_objectbox/model/course.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class Teacher {
  @Id(assignable: true)
  int teacherId;
  String fname;

  @Backlink()
  final course = ToMany<Course>();

  Teacher(this.fname, {this.teacherId = 0});
}
