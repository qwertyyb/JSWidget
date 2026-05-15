// 
// ScriptWidget 
// https://xnu.app/scriptwidget
// 
// 

var d = new Date();
var n = d.getDay();
console.log(n);

let linearGradient = {
  type: "linear",
  colors: ["yellow", "white"],
  startPoint: "top",
  endPoint: "bottom",
};

$render(
  <vstack
    backgroundGradient={linearGradient}
    frame={{maxWidth: "infinity", maxHeight: "infinity", alignment: "leading"}}
    alignment="leading"
  >
    <hstack padding={10}>
      <vstack alignment="leading">
        <text font="body" color="black">
          {d.getFullYear()}-{d.getMonth() + 1}-{d.getDate()}
        </text>
        <text font="body" color="black">
          Is Friday today ?
        </text>
      </vstack>
      <spacer />
    </hstack>
    <spacer />
    <text font="largeTitle" color="black" padding={10}>
      {n == 5 ? "Yes😊" : "No🤔"}
    </text>
  </vstack>
);
