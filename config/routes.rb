Rails.application.routes.draw do
  root 'pull_requests#home'

  resources :repos do
    get "/cohort/:cohort_id", to: "repos#show", as: :cohort

    resources :students, only: [] do
      resources :feedback, only: [:new, :create]
    end
  end
  resources :students
  resources :pull_requests
  resources :user_invites, only: [:index, :new, :create] do
    collection do
      get "/new/student", action: :new, as: "new_student", role: "student"
    end
  end

  get "/auth/:provider/callback", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
