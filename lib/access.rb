module Access
  VIEW = 100
  EDIT = 200
  DESTROY = 300

  def self.keys
    [VIEW, EDIT, DESTROY]
  end

  def self.access_to_string(value)
    case value
    when VIEW
        "View"
    when EDIT
        "Edit"
    when DESTROY
        "Owner"
    else
      raise 'Not a valid access value'
    end
  end
end