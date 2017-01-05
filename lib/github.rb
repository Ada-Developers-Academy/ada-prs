require 'httparty'
require 'pr_student'

class GitHub
  AUTH = { :username => ENV["GITHUB"] }

  # Overall method that will pull together all pieces
  def self.retrieve_student_info(repo, cohort)
    # First, call the API to get the PR data
    pr_info = get_prs(repo.repo_url)

    # Get the students in the cohort
    cohort_students = Student.where(cohort_id: cohort.id).sort

    # Use the PR data to construct the list of students submitted
    pr_students = pr_student_submissions(repo.individual, pr_info, cohort_students)

    # Add te student info for those who haven't submitted
    pr_students = add_missing_students(pr_students, cohort_students)
    @all_data = pr_students
  end

  def self.pr_student_submissions(individual, pr_data, students)
    # Catalog the list of students who have submitted
    pr_student_list = []
    pr_data.parsed_response.each do |pull_request|
      # Individual project
      if individual
        student_hash = individual_student(students, pull_request)
        pr_student_list << student_hash if student_hash != nil
      else # Group project
        pr_student_list.concat(group_project(students, pull_request, 3))
      end
    end

    return pr_student_list
  end

  def self.add_missing_students(pr_student_list, students)
    ids = pr_student_list.compact.map { |s| s.student_model.id }

    # Map list of students against the students who have submitted
    missing_students = students.map { |s| !ids.include?(s.id)? s : nil }

    missing_students.compact.each do |missing_student_model|
      if missing_student_model
        pr_student_list << PRStudent.new(missing_student_model)
      end
    end

    return pr_student_list
  end

  def self.individual_student(students, data)
    return create_student(students, data["user"]["login"].downcase, data["created_at"], data["html_url"])
  end

  def self.create_student(students, user, created_at, repo_url)
    student_model = students.find{ |s| s.github_name == user }
    if student_model
        student = PRStudent.new(student_model, user.downcase, DateTime.parse(created_at), repo_url)
        return student
    end
  end

  def self.get_prs(repo_url)
    request_url = "https://api.github.com/repos/#{ repo_url }/pulls"

    pr_info = make_request(request_url)
    return pr_info
  end

  def self.group_project(cohort_students, data, group_size)
    url = data["head"]["repo"]["contributors_url"]
    repo_created = data["created_at"]
    repo_url = data["html_url"]

    contributors = make_request(url)
    github_usernames = cohort_students.map{ |stud| stud.github_name.downcase }

    result = []
    contributors.each do |contributor|
      curr_github_username = contributor["login"].downcase

      # If the contributor is in the student list, add it!
      if github_usernames.include?(curr_github_username)
        student = create_student(cohort_students, curr_github_username, repo_created, repo_url)
        result << student if student
      end
    end

    return result
  end

  def self.make_request(url)
    response = HTTParty.get(url, headers: {"user-agent" => "rails"}, :basic_auth => GitHub::AUTH)
    return response
  end
end
