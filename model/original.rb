require 'aws-sdk'

class Original < AWS::Record::HashModel

  string_attr :result
  timestamps

end