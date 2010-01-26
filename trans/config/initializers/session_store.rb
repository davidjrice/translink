# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_trans_session',
  :secret      => '9c29f8978c14a2aa0402a0b106d686e6c9977a0c5d862d7ce119617ad77a546cd35f78754f27c2ce7e2051978238431672a9345b1c25ea0e410fdecceff58e48'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
