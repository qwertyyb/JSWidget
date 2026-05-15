// 
// ScriptWidget 
// https://xnu.app/scriptwidget
// 
// Usage for component attribute frame
// 

/*

 frame="max"
 frame={{maxWidth: "infinity", maxHeight: "infinity", alignment: "topLeading"}}
 frame={{width: 10, height: 20}}
 frame={{width: 10, height: 20, alignment: "topLeading"}}
 
 frame={{maxWidth: "infinity", height: 20}}
 frame={{width: 10, maxHeight: "infinity"}}
 frame={{maxWidth: "infinity", height: 20, alignment: "topLeading"}}
 frame={{width: 10, maxHeight: "infinity", alignment: "topLeading"}}


 the "topLeading" represent alignment, could be one of the values below:
    "center"
    "leading"
    "trailing"
    "top"
    "bottom"
    "topLeading"
    "topTrailing"
    "bottomLeading"
    "bottomTrailing"
*/
$render(
  <vstack frame="max">
    <rect frame={{width: 50, height: 30}} color="green"></rect>
    <rect frame={{width: 50, height: 30}} color="blue" corner="5"></rect>
  </vstack>
);
