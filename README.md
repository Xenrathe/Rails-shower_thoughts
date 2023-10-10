# README

## Shower Thoughts, a micro social media app

![Screenshot of the login page](https://github.com/Xenrathe/Rails-shower_thoughts/blob/main/ShowerThoughtsLogin.png?raw=true)

### Primary:

Shower Thoughts is a micro social media app. What's micro mean? It means without all the engagement elements - Reddit's karma system, Facebook's like/friend system, Twitter's retweet, etc - meant to invest users more heavily into the system. Shower Thoughts eschews all that in favor of a light, simple system. Log in, post your daily (or weekly or monthly or never) thought, read other's anonymous thoughts, maybe even Highlight your favorite, and move on. Life and the Net are too grand, too multifarious, to spend your time trapped in a single space.

Shower Thoughts is active on fly.io: (https://shower-thoughts.fly.dev/)

### Features:
* User registration, login via Devise gem
* Pagination via the will_paginate gem and javascript to automatically load next page via scrolling to bottom of page
* Users can 'favorite' or 'unshow' Thoughts and filter by Shown, Favorite, or Highlighted.
* Users can post one 'Shower Thought' every 24h, authenticated both client- and server-side
* Users can edit their recent 'Shower Thought' for up to 15 minutes after posting, authenticated both client- and server-side
* After a random 14-18h 'cooldown' timer, one user is randomly given Plumber status, able to highlight a single Shower Thought, which is given special styling
* To deal with trolls and other poor behavior, admins can shadowban users, meaning they can still login and post thoughts and see their own thoughts - but no one else can see them
  
![Screenshot of the main index page](https://github.com/Xenrathe/Rails-shower_thoughts/blob/main/ShowerThoughtsIndex.png?raw=true)

### Potential future improvements
* Improve some of the backgrounds / change them around
* Improved CSS styling, especially on buttons
* Mailer integration for retrieving forgotten password
* Shadowban also implements IP tracking to make the ban even more shadowy / invisible to the one banned
* User control panel, allowing for deletion of account
* Further filtering of thoughts, e.g. Comedic, Deep, etc
* Title, icon
* Higher-res texture images for higher-res screens
