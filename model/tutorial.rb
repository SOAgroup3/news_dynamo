require 'aws-sdk'

class Tutorial < AWS::Record::HashModel

  string_attr :number
  timestamps

  def self.destroy(id)
    find(id).delete
  end

  def self.delete_all
    all.each { |r| r.delete }
  end
end