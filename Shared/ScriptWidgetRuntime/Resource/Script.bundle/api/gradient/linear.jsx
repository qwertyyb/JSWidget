// 
// ScriptWidget 
// https://xnu.app/scriptwidget
// 
// Usage for backgroundGradient attribute
// 

let linearGradient = {
  type: "linear",
  colors: ["blue", "white", "pink"],
  startPoint: "topLeading",
  endPoint: "bottomTrailing",
};

$render(
  <vstack backgroundGradient={linearGradient} frame="max">
    <text font="title">LinearGradient</text>
  </vstack>
);
