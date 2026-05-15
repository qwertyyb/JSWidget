// 
// ScriptWidget 
// https://xnu.app/scriptwidget
// 

var d = new Date();
var n = d.getDay();
console.log(n);

let linearGradient = {
  type: "linear",
  colors: ["purple", "white"],
  startPoint: "leading",
  endPoint: "trailing",
};

var a = moment().endOf('month');
var b = moment();
var days = a.diff(b, 'days');

$render(
  <vstack
    backgroundGradient={linearGradient}
    frame={{maxWidth: "infinity", maxHeight: "infinity", alignment: "center"}}
  >
    <text font="largeTitle" color="black" padding={10}>
        { days + " Days"}
    </text>

    <text font="caption" color="black" padding={0}>
        Until end of month
    </text>
  </vstack>
);
