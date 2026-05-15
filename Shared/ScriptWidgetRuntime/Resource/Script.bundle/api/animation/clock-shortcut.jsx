
//
// ScriptWidget
// https://xnu.app/scriptwidget
//
// another basic clock animation
//


$render(
  <vstack frame={{maxWidth: "infinity", maxHeight: "infinity", alignment: "center"}}>
      <zstack>
          <vstack animation="clockHour">
              <circle frame={{width: 15, height: 15}} color="red"></circle>
              <spacer/>
          </vstack>
          <vstack animation="clockMinute">
              <circle frame={{width: 10, height: 10}} color="blue"></circle>
              <spacer/>
          </vstack>
          <vstack animation="clockSecond">
              <circle frame={{width: 5, height: 5}} color="yellow"></circle>
              <spacer/>
          </vstack>
      </zstack>
  </vstack>
);

