// 
// ScriptWidget 
// https://xnu.app/scriptwidget
// 
// Usage for backgroundGradient attribute
// 

let radialGradient = {
  type: "radial",
  colors: ["orange", "red", "white"],
  center: "center",
  startRadius: 100,
  endRadius: 470,
};

$render(
  <vstack backgroundGradient={radialGradient} frame="max">
    <text font="title">RadialGradient</text>
  </vstack>
);
