// 
// ScriptWidget 
// https://xnu.app/scriptwidget
// 
// Usage for backgroundGradient attribute
// 

let angularGradient = {
  type: "angular",
  colors: ["green", "blue", "black", "green", "blue", "black", "green"],
  center: "center",
};

$render(
  <vstack backgroundGradient={angularGradient} frame="max">
    <text font="title">AngularGradient</text>
  </vstack>
);
