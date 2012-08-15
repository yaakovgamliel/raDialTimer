2012-August-14

raDial Timer - Jonathan Hirz - jonathanhirz.com

I reached a screeching halt in this project when I realised that there is an unavoidable usability problem with the way alerts & local notifications are displayed to the user. I am bummed that this small problem has stopped me from finishing the project, but it is only temporary. I may finish it at some other time, for now I'd like to just get it up in my portfolio, because the work that is done is pretty cool.

Basically, this is a timer app. You spin the wheel to add time to the timer, press start and watch the animation spin down until the time is up. If you close the app, you will get a notification when the time is done. Here is where the problem arises: for this type of alarm/alert, you really want a persistant notification to the user, so they won't miss it. Default (and unchangable by the developer) style is a banner, that disappears in a few seconds. The user can manually set the alert style, but it's an ugly work around to have to explain that to a user. Meh.

This project uses a few cool CAAnimations to animate the 'bounce' and the 'spinner'.
