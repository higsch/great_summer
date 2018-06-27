# Great Weather
When I moved to Stockholm in early 2018, it was very cooold. Especially compared to my old hometown Munich. But, when time passed by, we went into a really hot May. Most of my colleagues were sure that this is the hottest month of May they ever experienced. Well let's see what the data says.

Well, see the answer on my [blog](http://www.higsch.me/2018/06/27/2018-06-27-a-really-warm-may-in-stockholm/). And find the accompanying R markdown [here](https://github.com/mtstahl/higsch.me/blob/master/content/post/2018-06-27-a-really-warm-may-in-stockholm.Rmd).

## Where the data comes from
Temperature data was kindly provided by [Tutiempo.net](https://www.tutiempo.net). They mailed me their agreement [here](./TuTiemponet_agreement_on_publication.pdf). As you can see in the `getWeatherData` function, I fetched the tables directly from their html sites.