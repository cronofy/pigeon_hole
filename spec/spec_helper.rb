require 'bundler'

Bundler.require

def random_integer
  rand(9999)
end

def random_time
  Time.at((Time.now - random_integer).to_i)
end

def random_date
  Date.today - random_integer
end

def random_date_time
  DateTime.now
end
