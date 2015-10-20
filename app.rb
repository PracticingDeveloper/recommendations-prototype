require "bundler"
require "sinatra/reloader"

Bundler.require

get "/" do
  slim :index
end

__END__
@@index
  .row
    .col-md-2
    .col-md-8
      .well style="padding-top: 20px"
        p.lead Hello World - A beautiful beginning
        img src="/video-placeholder.png" width="100%"
      .well style="padding-top: 20px"
        p.lead 
          small You may also like...
        .row
          .col-md-4
            img src="/video-placeholder.png" width="100%"
            p.text-center
              small
                | A first recommendation
          .col-md-4
            img src="/video-placeholder.png" width="100%"
            p.text-center
              small
                | A second recommendation
          .col-md-4
            img src="/video-placeholder.png" width="100%"
            p.text-center
              small
                | A third recommendation

@@layout 
doctype html 
html
  head
    link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"
    link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css"
  body
    .container style="padding-top: 20px"
      == yield