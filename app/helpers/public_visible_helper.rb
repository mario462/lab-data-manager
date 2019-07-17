module PublicVisibleHelper
  def self.approved(klass)
    klass.where('pending != ?', true)
  end

  def self.pending(klass)
    klass.where('pending == ?', true)
  end

  def self.public(klass)
    self.approved(klass).reject { |s| s.visibility == Visibility::PRIVATE_ACCESS }
  end
end
