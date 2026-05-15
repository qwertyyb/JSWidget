// 
// ScriptWidget 
// https://xnu.app/scriptwidget
// 
// Usage for component date
// try to fix the expanding issue , we can add a frame attribute : frame={{width: 50, maxHeight: "infinity", alignment: "leading"}}
//

$render(
  <hstack alignment="center">
    <text font={10} color="#aaaaaa,0.5">
      Last update:
    </text>
    <date font={10} color="#aaaaaa,0.5" date={Date.now()} frame={{width: 50, maxHeight: "infinity", alignment: "leading"}} />
  </hstack>
);
