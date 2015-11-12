require "bundler"
require "sinatra/reloader"
require "csv"

SongDB = Hash.new { |h,k| h[k] = [] }

CSV.foreach("db/songs.csv") do |artist, song|
  SongDB[artist] << song
end

Bundler.require

get "/" do
  @artist, songs = SongDB.to_a.sample

  @current_song = songs.sample

  @recommendations = (songs - [@current_song]).sample(3)

  slim :index
end

__END__
@@index
  .row
    .col-md-2
    .col-md-8
      .well style="padding-top: 20px"
        p.lead #{@current_song} - #{@artist}
        == '<iframe width="705" height="396" src="https://www.youtube.com/embed/dQw4w9WgXcQ" frameborder="0" allowfullscreen></iframe>'
      .well style="padding-top: 20px"
        p.lead 
          small You may also like...
        .row
          .col-md-4
            img src="/video-placeholder.png" width="100%"
            p.text-center
              small
                | #{@recommendations[0]}
                br
                | #{@artist}
          .col-md-4
            img src="/video-placeholder.png" width="100%"
            p.text-center
              small
                | #{@recommendations[1]}
                br
                | #{@artist}
          .col-md-4
            img src="/video-placeholder.png" width="100%"
            p.text-center
              small
                | #{@recommendations[2]}
                br
                | #{@artist}
@@layout 
doctype html 
html
  head
    link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"
    link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css"
  body
    .container style="padding-top: 20px"
      == yield