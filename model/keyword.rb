require 'aws-sdk'

class Keyword < AWS::Record::HashModel

  string_attr :word
  timestamps

end