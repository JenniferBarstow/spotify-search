Rails.application.routes.draw do
  root 'searches#index'
  get 'user_searches' => 'searches#user_searches'
  devise_for :users,
    path: '',
    path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      sessions: 'sessions',
      registrations: 'registrations'
    }
  resources  :searches, only: [:create, :index, :destroy]
end
