require "bundler"
require "sinatra/reloader"
require "csv"

SongDB = []

CSV.foreach("db/songs.csv") do |id, artist, song, genre, decade|
  SongDB << { :id => id, :title => song, :artist => artist, :tags => [artist, genre, decade] }
end

Bundler.require

get "/" do
  redirect "/#{SongDB.sample[:id]}"
end

get "/:id" do
  @current_song    = SongDB.find { |e| e[:id] == params[:id] }
  @recommendations = SongDB.sort_by { |e|
                       (@current_song[:tags] - e[:tags]).count
                     }.first(40).sample(3)

  slim :index
end

__END__
@@index
  .row
    .col-md-2
    .col-md-8
      .well style="padding-top: 20px"
        p.lead #{@current_song[:title]} -- #{@current_song[:tags].join(" / ")}
        == '<iframe width="705" height="396" src="https://www.youtube.com/embed/dQw4w9WgXcQ" frameborder="0" allowfullscreen></iframe>'
      .well style="padding-top: 20px"
        p.lead 
          small You may also like...
        .row
          .col-md-4
            a href="/#{@recommendations[0][:id]}" style="text-decoration: none; color: inherit;"
              img src="/video-placeholder.png" width="100%"
              p.text-center
                small
                  strong #{@recommendations[0][:title]}
                  br
                  | #{@recommendations[0][:tags].join(" / ")}
          .col-md-4
            a href="/#{@recommendations[1][:id]}" style="text-decoration: none; color: inherit;"
              img src="/video-placeholder.png" width="100%"
              p.text-center
                small
                  strong #{@recommendations[1][:title]}
                  br
                  | #{@recommendations[1][:tags].join(" / ")}
          .col-md-4
            a href="/#{@recommendations[2][:id]}" style="text-decoration: none; color: inherit;"
              img src="/video-placeholder.png" width="100%"
              p.text-center
                small
                  strong #{@recommendations[2][:title]}
                  br
                  | #{@recommendations[2][:tags].join(" / ")}
        hr
        p.text-center
          big
            == 'Feeling adventurous? <a href="/">Load a random song</a>'
@@layout 
doctype html 
html
  head
    link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"
    link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css"
  body
    .container style="padding-top: 20px"
      == yield