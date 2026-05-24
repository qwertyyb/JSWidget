// 日期计算
const date = new Date()
const dayIndex = (date.getDay() + 6) % 7
const remainDay = 4 - dayIndex
const dayDuration = 86400000
const startTs = Date.now() - dayIndex * dayDuration
const daysToMonday = 7 - dayIndex

// 日期格式化
const formatDate = (ts) => {
  const d = new Date(ts)
  const m = d.getMonth() + 1
  const day = String(d.getDate()).padStart(2, "0")
  return `${m}月${day}日`
}

const formatDateWithYear = (ts) => {
  const d = new Date(ts)
  const m = String(d.getMonth() + 1).padStart(2, "0")
  const day = String(d.getDate()).padStart(2, "0")
  return `${d.getFullYear()}.${m}.${day}`
}

// 周数据
const labels = ['一', '二', '三', '四', '五', '六', '日']

const createWorkdayWidget = () => {
  $render(
    <col
      size="max"
      padding={16}
      backgroundColor="#9b94fd"
    >
      <row size={{width:'fill'}} justify="start" spacing={3} padding={{left: 16}}>
        <text font={10} color="#000000">距离周五还有</text>
        <text font={{size: 14, weight: 'bold'}} color="#000000">{remainDay}天</text>
      </row>

      <spacer />

      <row spacing={2}>
        {
          labels.slice(0, 5).map((label, index) => (
            <col spacing={6} size={{width:'fill'}}>
              <image 
                filePath={`images/${index+1}.png`}
              />

              <col 
                padding={4} 
                cornerRadius={3}
                backgroundColor={index === dayIndex ? "rgba(0,0,0,0.08)" : "transparent"}
              >
                <text font={10} color="#000000">星期{label}</text>
              </col>

              <spacer length={4} />
              <text font={8} color="#000000">{formatDate(startTs + dayIndex * dayDuration)}</text>
            </col>
          ))
        }
      </row>

      <spacer length={6} />
    </col>
  )
}

const createWeekendWidget = () => {
  $render(
    <col size="max" padding={{horizontal:16,top:16,bottom:0}} backgroundColor="#a69ffd" align="start">
      <row size={{width:'fill'}} justify="start" spacing={3}>
        <text font={10} color="#000000">距离周一还有</text>
        <text font={{size: 14, weight: 'bold'}} color="#000000">{daysToMonday}天</text>
      </row>
      <row size={{width:'fill'}} justify="start" align="start">
        <col align="start">
          <text font={{size: 36, weight: 'medium'}} textAlign="start">星期{labels[dayIndex]}</text>
          <text color="#000" textAlign="start">{formatDateWithYear(Date.now())}</text>
        </col>
        <spacer />
        <image mode="fit" filePath={`images/${dayIndex+1}.png`} />
      </row>
    </col>
  )
}

if (dayIndex < 5) {
  createWorkdayWidget()
} else {
  createWeekendWidget()
}