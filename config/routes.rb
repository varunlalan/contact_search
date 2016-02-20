Rails.application.routes.draw do
  root to: "home#index"

  get "search_contacts" => "home#search_contacts"
end
