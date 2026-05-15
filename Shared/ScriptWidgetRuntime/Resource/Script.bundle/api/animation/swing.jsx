// 
// ScriptWidget 
// https://xnu.app/scriptwidget
// 
// Swing Sample
// 


let animationHorizontalDefinition = {
  type: "swing",
  duration: 2,
  direction: "horizontal", // "horizontal", "vertical"
  distance: 100,
}

let animationVerticalDefinition = {
  type: "swing",
  duration: 2,
  direction: "vertical", // "horizontal", "vertical"
  distance: 100,
}


$render(
  <vstack frame="max">
    <circle frame={{width: 30, height: 30}} color="green" animation={animationHorizontalDefinition}></circle>
    <circle frame={{width: 30, height: 30}} color="orange" animation={animationVerticalDefinition}></circle>
  </vstack>
);
