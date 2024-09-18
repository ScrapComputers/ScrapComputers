// Used to scrape people's sm mods incase we have to ban all of there mods
// Youl need steam closed and have a webserver running. The webserver on / should return data from here: https://raw.githubusercontent.com/TechnologicNick/scrap-mechanic-mod-scraper/master/mod/Scripts/data/descriptions.json
(() => {
    let text = ""

    fetch("http://127.0.0.1:27060").then(response => {
        response.json().then(jsonData => {
            document.querySelectorAll(".workshopItem").forEach(workshopItem => {
                const ID = workshopItem.querySelector("a").href.replace("https://steamcommunity.com/sharedfiles/filedetails/?id=", "")
        
                for(const [key, value] of Object.entries(jsonData))
                {
                    if(value["fileId"] == Number(ID))
                    {
                        text = text + "{\"" + value["name"] + "\", \"" + key + "\", 4, \"Banned for specific reasons we cannot mention.\"},\n"
                        break
                    }
                }
            })

            console.log(text)
        })
    })
})()