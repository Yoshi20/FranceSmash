# FranceSmash
France Super Smash Bros community finder & simple tournament manager (Ruby on Rails project)

Local commands:
- bundle update
- rake db:migrate
- rake db:rollback
- rails s
- rails c

- dropdb francesmash_development
- heroku pg:pull \<postgresql-name\> francesmash_development --app francesmash

- heroku pg:reset --app francesmash-stage --confirm francesmash-stage
- heroku pg:push francesmash_development \<postgresql-name\> --app francesmash-stage

Prod commands:
- git push prod master
- heroku logs --tail
- heroku run rake db:migrate
- heroku run rails c
- heroku restart

- heroku run rake tournaments_crawler:all
- heroku run rake results_crawler:all
- heroku run rake "utils:remove_player_from_finished_tournament[<t_id>,<p_id>]"

General links:
- https://francesmash.herokuapp.com
- https://www.francesmash.de
- https://www.smashfrance.de
- https://challonge.com

Tournaments crawler links:
- https://smash.gg/tournaments?per_page=100&filter={%22upcoming%22%3Atrue%2C%22videogameIds%22%3A0%2C%22countryCode%22%3A%22DE%22}
- https://braacket.com/tournament/search?rows=100&country=de&game=ssbu&status=1

Icons:
- https://www.ssbwiki.com/Category:Head_icons_(SSBU)

Banner:
- https://www.ssbwiki.com/Super_Smash_Bros._Ultimate

Google Analytics:
- https://analytics.google.com/analytics/web/?pli=1#/report-home/a145089919w298044912p257719884
