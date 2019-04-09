<!doctype html>
<html lang="en-us">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Weather forecast widget</title>
    <link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/picnic/6.5.0/picnic.min.css">
    <link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/pure/1.0.0/pure-min.css">
    <link rel="stylesheet" type="text/css" href="styles/weather.css">
</head>
<body>
<!--Components-->
<cfset weather = new com.darksky().getWeather(opencagedata="ottawa, ca")>
<!--- <cfdump var="#weather#" abort> --->
<cfoutput>
    <article class="card">
    <header>
      <h3>#weather.location.city# #weather.location.state# #weather.location.country#</h3>
    </header>
    <div class="pure-g WeatherForecast">
      <div class="pure-u-1-2 skycon_cls">
        <input type="hidden" id="IconID" value="#weather.currently.icon#"> <!--darksky.net icon-->
        <canvas class="SkyConIs" width="75" height="85"></canvas>
      </div>
      <div class="pure-u-1-2">
        <span class="degree_cls">#weather.currently.temperature#&deg;F</span>
        <br>
        <span>#weather.currently.summary#.</span>
        <br>
        <span>
          Feels like <span class="feelsLike_cls">#weather.currently.apparentTemperature#&deg;</span>
        </span>
      </div>
    </div>
    <footer>
      <p><span>#weather.daily.summary#</span></p>
    </footer>
    </article>
</cfoutput>

<!--scripts-->
<script src="//cdnjs.cloudflare.com/ajax/libs/skycons/1396634940/skycons.min.js"></script>
<script src="scripts/weather.js"></script>
</body>
</html>