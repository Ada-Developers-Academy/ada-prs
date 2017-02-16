# # Create users
# staff = ["kariabancroft"]
#
# staff.each do |s|
#   u = { name: "Kari", }
#   User.create()
# end

# Create cohorts
cohorts = [
  { number: 6, name: "Brackets", instructor_emails: "kari@adadevelopersacademy.org,dan@adadevelopersacademy.org" },
  { number: 6, name: "Parens", instructor_emails: "kari@adadevelopersacademy.org" }
]

cohorts.each do |c|
  Cohort.create(c)
end

students = []
students = CSV.read(Rails.root.join('lib', 'seeds', 'students.csv')).each do |stud|
  stud_hash = {}
  stud_hash[:name] = stud[1].titleize
  c = Cohort.where("name LIKE :prefix", prefix: "#{stud[0]}%")
  stud_hash[:cohort_id] = c.first.id
  stud_hash[:email] = stud[2].downcase
  stud_hash[:github_name] = stud[3].downcase

  Student.create(stud_hash)
end

repos = [
  { repo_url: "Ada-C6/Scrabble", individual: false},
  { repo_url: "Ada-C6/BankAccounts"}
]

repos.each do |repo|
  r = Repo.create(repo)
  r.cohorts << Cohort.all
  r.save
end
