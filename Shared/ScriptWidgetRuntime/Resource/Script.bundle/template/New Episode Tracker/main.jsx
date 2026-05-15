const API_URL = "https://episodate.com/api/show-details?q="

const colors = {
  primary: "#080808",
  secondary: "green",
  text: {
    primary: "white",
    secondary: "green"
  }
}

const series = [
  "the-lord-of-the-rings",
  "house-of-the-dragon"
]

const fetchSeries = async seriesList => {
  let response = []

  for (let series of seriesList) {
    response.push(
      JSON.parse(
        await fetch(API_URL + series)
      )
    )
  }
  return response
}

const getTimeLeft = airDate => {

  let res
  const millis = airDate - Date.now()
  const secondsLeft = millis / 1000

  const getDays = seconds => {
    return Math.round(seconds / (3600 * 24))
  }

  const getHours = seconds => {
    return Math.round(seconds % (3600 * 24) / 3600)
  }

  const getMinutes = seconds => {
    return Math.round(seconds % 3600 / 60)
  }
  
  if (getDays(secondsLeft) > 0) {
    res = getDays(secondsLeft) + "d "
    res += getHours(secondsLeft) + "h "
    
  } else if (getHours(secondsLeft) > 0) {
    res = getHours(secondsLeft) + " h "
    
  } else {
    res = getMinutes(secondsLeft) + " m "
  }
    
  return res + "left"
}

const Logo = ({logoPath}) => {
   return (
    <zstack>
       <image
         url={logoPath}
         frame={{width: 40, height: 40, alignment: "trailing"}}
       />
       <rect
         color={colors.secondary}
         stroke="1"
         frame={{width: 40, height: 40}}
       />
    </zstack>
  )
}

const Entry = ({info}) => {

  const getNextEpisode = countdown => 
    `s${countdown.season}e${countdown.episode}`

  const nextEpisodeRemaining = countdown => {
    const airDate = countdown.air_date
      .replace(" ", "T") + "Z"
    
    return getTimeLeft(new Date(airDate))
  }
  
  return (
    <vstack
      alignment="top" 
    >
      <hstack
        alignment="top" 
      >
        <Logo 
          logoPath={info.image_path}
        />
        <vstack
          alignment="top"
        >
          <text 
            font={14}
            frame={{width: 200, height: 15, alignment: "leading"}}
            color={colors.text.primary}
          >
            {info.name}
          </text>
          <hstack>
            <text
              font="caption2"
              frame={{width: 50, height: 15, alignment: "leading"}}
              color={colors.text.secondary}
            >
              {
                info.countdown === null ? "ended"
                : getNextEpisode(info.countdown)
              }
            </text>
            <text
              frame={{width: 120, height: 15, alignment: "trailing"}}
              font="caption2"
              color={colors.text.secondary}
            >
              {
                info.countdown === null ? ""
                : nextEpisodeRemaining(info.countdown)
              }
            </text>
          </hstack>
        </vstack>
        <spacer/>
      </hstack>
    </vstack>
  )
}

const seriesJson = await fetchSeries(series)

$render(
  <zstack
    backgroundColor={colors.primary} 
  > 
    <vstack 
      padding={{top: 10, trailing: 10, bottom: 10, leading: 20}} 
      frame={{maxWidth: "infinity", maxHeight: "infinity", alignment: "top"}}
    >
      {
        seriesJson?.map(series =>
          <Entry
            info={series.tvShow}
          />
        )
      }
    </vstack>
  </zstack>
);
