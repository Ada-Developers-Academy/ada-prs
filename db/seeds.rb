# FIXME: clean up all of this before submitting/when we know what we're doing
# Create instructor
User.create!(name: "Test Instructor 1",
             provider: :github,
             uid: "30710012",
             github_name: "ada-instructor-1",
             role: "instructor")

User.create!(name: "Schumy",
             provider: :github,
             uid: ENV['KSUID'],
             github_name: "kschumy",
             role: "instructor")

puts "\n********USER CREATED!*********\n\n"

# TODO: don't know if these dates are right
Cohort.create!(
  name: "C9",
  repo_name: "ada-C9",
  class_start_date: Date.new(2018,2,5),
  class_end_date: Date.new(2018,7,27),  # noooooooo 😭
  internship_start_date: Date.new(2018,8,6),
  internship_end_date: Date.new(2019,1,4),
  graduation_date: Date.new(2018,12,4)
)
# Create classrooms
classrooms = [
  { number: 0, name: "Peanut Butter", instructor_emails: "charles+classroom-local-pb-instructor@adadev.org", cohort_id: 1},
  { number: 0, name: "Jelly", instructor_emails: "charles+classroom-local-jelly-instructor@adadev.org", cohort_id: 1 }
]

classrooms.each do |c|
  Classroom.create!(c)
end
puts "******** #{Classroom.count} CLASSROOMS CREATED*********\n\n"

# Create students
Student.create!(name: "Test Student 1", classroom: Classroom.first,
               github_name: "ada-student-1", email: "charles+classroom-local-student-1@adadev.org")
Student.create!(name: "Test Student 2", classroom: Classroom.last,
               github_name: "ada-student-2", email: "charles+classroom-local-student-2@adadev.org")
puts "******** #{Student.count} STUDENTS CREATED*********\n\n"


assignments = [
  { repo_url: "Ada-Test/PR-App-test-group", individual: false},
  { repo_url: "Ada-Test/PR-App-test-individual"}
]

assignments.each do |assignment|
  new_assignment = Assignment.new(assignment)
  new_assignment.classrooms << Classroom.find(1)
  # Makes 2nd assignment for us to play around with a many to many
  new_assignment.classrooms << Classroom.find(2) if Assignment.count == 1 && Classroom.find_by(id: 2)
  new_assignment.save!
  puts "******** NEW ASSIGNMENT: #{new_assignment.classrooms.inspect} *********\n\n"
end
puts "******** #{Assignment.count} ASSIGNMENTS CREATED*********"