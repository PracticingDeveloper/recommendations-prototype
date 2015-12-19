require "bundler"
require "sinatra/reloader"
require "csv"

SongDB = []

CSV.foreach("db/songs.csv") do |id, artist, song, genre, decade|
  SongDB << { :id => id, :title => song, :artist => artist, :tags => [artist, genre, decade] }
end

Bundler.require

enable :sessions

get "/" do
  redirect "/#{SongDB.sample[:id]}"
end

get "/:id" do
  session[:tags] ||= {}

  @current_song    = SongDB.find { |e| e[:id] == params[:id] }

  @current_song[:tags].each { |t| 
    session[:tags][t] ||= 0
    session[:tags][t] += 1
  }

  @recommendations = SongDB.sort_by { |e|
                       [@current_song[:tags] & e[:tags]].reduce { |s,t| s + session[:tags].fetch(t) }
                     }.last(20).sample(3)

  slim :index
end

get "/explore/:term" do
  song = SongDB.select { |e| e[:tags].include?(params[:term]) }.sample

  redirect "/#{song[:id]}"
end

__END__
@@index
  .row
    .col-md-8
      .well style="padding-top: 20px"
        == %{<iframe width="705" height="396" src="https://www.youtube.com/embed/#{@current_song[:id]}" frameborder="0" allowfullscreen></iframe>}
      .well style="padding-top: 20px"
        .row
          .col-md-4
            a href="/#{@recommendations[0][:id]}" style="text-decoration: none; color: inherit;"
              img src="http://img.youtube.com/vi/#{@recommendations[0][:id]}/0.jpg" width="100%"
              p.text-center
                small
                  strong #{@recommendations[0][:title]}
                  br
                  | #{@recommendations[0][:tags].join(" / ")}
          .col-md-4
            a href="/#{@recommendations[1][:id]}" style="text-decoration: none; color: inherit;"
              img src="http://img.youtube.com/vi/#{@recommendations[1][:id]}/0.jpg" width="100%"
              p.text-center
                small
                  strong #{@recommendations[1][:title]}
                  br
                  | #{@recommendations[1][:tags].join(" / ")}
          .col-md-4
            a href="/#{@recommendations[2][:id]}" style="text-decoration: none; color: inherit;"
              img src="http://img.youtube.com/vi/#{@recommendations[2][:id]}/0.jpg" width="100%"
              p.text-center
                small
                  strong #{@recommendations[2][:title]}
                  br
                  | #{@recommendations[2][:tags].join(" / ")}
        hr
        p.text-center
          big
            == 'Feeling adventurous? <a href="/">Load a random song</a>'
    .col-md-4
      br
      br
      .panel.panel-info
        .panel-heading Your top interests (according to our creepy robots)
        ul.list-group
          - session[:tags].sort_by { |k,v| v }.last(15).reverse_each do |k,v|
            li.list-group-item 
              a href="/explore/#{k}" #{k} - #{v}
        
@@layout 
doctype html 
html
  head
    link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"
    link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css"
  body
    .container style="padding-top: 20px"
      == yield