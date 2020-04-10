# users.rb
require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"
require "yaml"

before do
  @users = YAML.load_file("users.yaml")
  @num_users = @users.length
  @num_interests = count_interests
end

helpers do
  def get_capitalized_name(user_info)
    user_info[0].capitalize
  end

  def count_interests
    total = 0

    @users.each do |user|
      total += user[1][:interests].length
    end

    total
  end

  def get_other_usernames(name)
    @users.keys.select { |key| key != name.to_sym }
  end
end

get "/" do
  @title = "Users"

  erb :users
end

get "/users/:name" do
  name_param = params[:name]
  key = name_param.to_sym
  @name = name_param.capitalize
  @email = @users[key][:email]
  @interests = @users[key][:interests]
  @title = "#{@name}"
  @other_users = get_other_usernames(name_param)

  redirect "/" unless @users.keys.include? @name.downcase.to_sym
  
  erb :user
end

not_found do
  redirect "/"
end