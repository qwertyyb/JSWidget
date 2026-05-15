// 
// ScriptWidget 
// https://xnu.app/scriptwidget
// 
// Clock Template
// 
// Description: Display Clock Time
// 

$render(
  <vstack backgroundColor="yellow" frame={{maxWidth: "infinity", maxHeight: "infinity", alignment: "center"}}>
    <date font="title" date="start of today" style="timer" alignment="center" />
  </vstack>
);
