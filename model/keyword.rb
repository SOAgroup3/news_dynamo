require 'aws-sdk'

class Keyword < AWS::Record::HashModel

  string_attr :word
  string_attr :result
  timestamps

end