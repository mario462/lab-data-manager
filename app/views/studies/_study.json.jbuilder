json.extract! study, :id, :name, :description, :url, :visibility, :created_at, :updated_at
json.url study_url(study, format: :json)
