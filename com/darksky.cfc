<cfcomponent output="false">

    <cfset variables.dsapiuri = "https://api.darksky.net/forecast">
    <cfset variables.dsapikey = "">
    <!--- <cfset variables.lat = "39.958359">
    <cfset variables.lng = "-75.195393"> --->
    <!--- this is optional, but you can get an api key here https://opencagedata.com/api there are rate limits just like darksky
        if you don't use this, you need to always specify lat & lng
    --->
    <cfset variables.opencageapikey = "dbae2ecab66849e0a4f5e722a13cabba">
    <cfset variables.opencageapiuri = "https://api.opencagedata.com/geocode/v1/json">
    <!--- end optional open cage --->

    <cffunction name="init" output="no" access="public" returntype="any" hint="Initializing variable component">
        <cfreturn this>
    </cffunction>

    <!---Get weather from darksky.net--->
    <cffunction name="getWeather" access="public" output="no" description="Get current weather from darksky.net https://darksky.net/dev/docs" returntype="struct">
        <cfargument name="lat" type="string" required="false" default="">
        <cfargument name="lng" type="string" required="false" default="">
        <cfargument name="exclude" type="string" required="false" hint="Exclude some blocks if you don't need them. reduce latency and bandwidth. comma-delimited list. options currently, minutely, hourly, daily, alerts, flags. default is to NOT exclude anything.">
        <cfargument name="extend" type="string" required="false" hint="Only option is hourly. Returns the next 168 hours instead of 48. default is 48">
        <cfargument name="lang" type="string" required="false" hint="Return summary properties in the desired language. see dev docs for options.">
        <cfargument name="units" type="string" required="false" hint="Return weather conditions in the requested units. should go along with lang. see dev docs for options">
        <cfargument name="opencagedata" type="string" required="false" default="">

        <cfset var ocdata = "">

        <cfif Len(Trim(arguments.lat)) eq 0 && Len(Trim(arguments.lng)) eq 0 && Len(Trim(variables.opencageapikey)) gt 0 && Len(Trim(arguments.opencagedata)) gt 0>
            <cfhttp url="#variables.opencageapiuri#?q=#Trim(arguments.opencagedata)#&key=#variables.opencageapikey#" result="ocres" method="get" />
            <cfif ocres.statuscode eq "200 OK">
                <cfset ocdata = deserializeJSON(ocres.filecontent)>
                <!--- <cftry> --->
                    <cfset arguments.lat = ocdata.results[1].geometry.lat>
                    <cfset arguments.lng = ocdata.results[1].geometry.lng>
                    <cfset variables.city = ocdata.results[1].components.city>
                    <cfset variables.state = ocdata.results[1].components.state>
                    <cfset variables.country = ocdata.results[1].components.country>
                <!--- <cfcatch></cfcatch>
                </cftry> --->
            </cfif>
        </cfif>
        <cfset weatherData = {}> <!--Structure to hold return weather data-->

        <cfset fullUrl = "#variables.dsapiuri#/#variables.dsapiKey#/#arguments.lat#,#arguments.lng#?">
        <!--- set up optional params --->
        <cfif structkeyExists(arguments, "exclude") && Len(arguments.exclude)>
        <cfset fullUrl &= arguments.exclude>
        </cfif>
        <cfif structkeyExists(arguments, "extend") && Len(arguments.extend)>
        <cfset fullUrl &= arguments.extend>
        </cfif>
        <cfif structkeyExists(arguments, "lang") && Len(arguments.lang)>
        <cfset fullUrl &= arguments.lang>
        </cfif>
        <cfif structkeyExists(arguments, "units") && Len(arguments.units)>
        <cfset fullUrl &= arguments.units>
        </cfif>

        <!--URL resolve-->
        <cfhttp url="#fullUrl#" method="get" result="result" />
        <cfif result.statuscode eq "200 OK">
            <!--- Just going to return the deserailzed data and you can use what you need from it. If you want to see the structure, just dump it.--->
            <cfset weatherData = DeserializeJSON(result.filecontent)>
            <cfif isStruct(ocdata)>
                <cfset structAppend(weatherData,
                {
                    "location":
                    {
                        "city":"#variables.city#",
                        "state": "#variables.state#",
                        "country":"#variables.country#"
                    }
                })>
            </cfif>
        </cfif>
        <cfreturn weatherData>
    </cffunction>
</cfcomponent>
