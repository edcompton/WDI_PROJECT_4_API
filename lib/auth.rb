# jwt provides JWT. * methods
require 'jwt'

# create class which will be loaded early and will
# be accessible in controllers / app
# methods definied on self to allow this
class Auth
  ALGORITHM = 'HS256'

  # method to create an encoded jwt
  # JWT.encode provided by jwt gem
  # returns an encoded token
  def self.issue(payload, expiry_in_minutes=60*24*30)
    payload[:exp] = expiry_in_minutes.minutes.from_now.to_i
    JWT.encode(payload, auth_secret, ALGORITHM)
  end

  # decodes jwt token with 0 time leeway
  # JWT.decode method provided by jwt gem
  # returns decoded attay [payload, otherstuff, otherstuff]
  # HashWithIndifferentAccess object provided by Rails ActiveSupport
  # allows properties of object to be accessed with symbols or strings
  def self.decode(token, leeway=0)
    decoded = JWT.decode(token, auth_secret, true, { leeway: leeway, algorithm: ALGORITHM })
    HashWithIndifferentAccess.new(decoded[0])
  end

  # method to access secret stored in application.yml
  # created by figaro gem
  def self.auth_secret
    ENV["AUTH_SECRET"]
  end
end
