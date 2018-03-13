# MDBSocials

This app allows users to create an account and post "Socials" which are events that are about to happen. 
Other users are then able to RSVP to come to those events.

# Features

The majority of the backend functionality was done using Firebase. Firebase Authentication/Database/Storage were all used for various parts. The DarkSky API was also used as mentioned later. Many libraries were used to implement this app.

# In Action

The app starts with this log in screen :

![simulator screen shot - iphone 8 - 2018-03-03 at 22 39 21](https://user-images.githubusercontent.com/17814417/36942910-0170487c-1f34-11e8-853b-cb276f5f1a13.png)


You can choose to sign up instead which pops up a sign up form :

![simulator screen shot - iphone 8 - 2018-02-22 at 18 12 32](https://user-images.githubusercontent.com/17814417/36574871-927dcf54-17fc-11e8-8ed7-c97aefc79197.png)

Once you are logged in, you are brought to the feed. This is where users posts will show up. This is updated in real time and doesn't require the user to refresh to see new posts as they come in.

Here you also notice that the cells have a weather icon in them. This represents how the weather will be at that time 
for the event. The DarkSkyAPI was used to achieve this.

![simulator screen shot - iphone 8 - 2018-03-03 at 22 38 44](https://user-images.githubusercontent.com/17814417/36942924-32efed26-1f34-11e8-9a42-8853ba633e7c.png)


Clicking on a cell will transition into a more detailed view of it, using the HERO library. For example :

![simulator screen shot - iphone 8 - 2018-03-03 at 22 38 50](https://user-images.githubusercontent.com/17814417/36942925-433a65bc-1f34-11e8-9996-7c693f5dcfa2.png)

If you click on the interested star, you can RSVP to say you are coming to the event. The counter will increase.

Also, if you were to click the top right, it would take you to the following map view of where the event is going to be.

![simulator screen shot - iphone 8 - 2018-03-03 at 22 38 59](https://user-images.githubusercontent.com/17814417/36942936-7822b91e-1f34-11e8-8466-96342ee4328b.png)

If you ask for directions to this place, it opens up Apple Maps for you.

![simulator screen shot - iphone 8 - 2018-03-03 at 22 39 03](https://user-images.githubusercontent.com/17814417/36942944-8bfdd338-1f34-11e8-88a4-8efe5430e07d.png)

If you wanted to know who was going to a certain event, selecting the label on the feeds page opens a Modal view of the people.

![simulator screen shot - iphone 8 - 2018-03-03 at 22 43 57](https://user-images.githubusercontent.com/17814417/36942947-a38e10a8-1f34-11e8-9778-726d50c8a113.png)

In order to create a new post, from the feed you click the plus in the top right. It leads to this page :

![simulator screen shot - iphone 8 - 2018-02-22 at 18 12 42](https://user-images.githubusercontent.com/17814417/36574954-f1337dc8-17fc-11e8-9b8f-fbe0db4f6256.png)

It is very straightforward and allows you to input all the information.

Lastly, the app is tab based once you log in. The first tab is the feed which was shown above. The other tab is simply a list very similar to the feed, of events you created or are interested in.

![simulator screen shot - iphone 8 - 2018-03-03 at 22 39 12](https://user-images.githubusercontent.com/17814417/36942955-c94bd0d2-1f34-11e8-98d6-37a8a0217f37.png)


# Libraries used

* Firebase (Auth / Database / Storage)
* AlamoFire
* SwiftyJSON
* PromiseKit
* ObjectMapper
* Spring
* HERO

# APIS used

https://darksky.net/dev

# Created by

This was created by me.
