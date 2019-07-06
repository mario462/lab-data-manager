module AccessRequestStatus
  PENDING = 100
  APPROVED = 200
  DENIED = 300

  def self.keys
    [PENDING, APPROVED, DENIED]
  end

  def self.status_to_string(value)
    case value
    when PENDING
        "Pending"
    when APPROVED
        "Approved"
    when DENIED
        "Denied"
    else
      raise 'Not a valid access request status'
    end
  end
end