// 
// ScriptWidget 
// https://xnu.app/scriptwidget
// 
// Usage for component image
// 

/*

    <image />
    <image systemName="mosaic.fill" />
    <image id="image0" />
    
    <image id="image" mode="fit" ratio="0.6" />
    <image id="image" mode="fill" frame={{width: 260, height: 60}} />

    <image id="image" mode="fill" clip="rect" frame={{width: 200, height: 100}}/>
    
    <image id="image" mode="fill" clip="rect" frame={{width: 200, height: 100}}/>
    <image id="image" mode="fill" clip="ellipse" frame={{width: 200, height: 100}}/>
    <image id="image" mode="fill" clip="circle" frame={{width: 200, height: 100}}/>
    <image id="image" mode="fill" clip="capsule" frame={{width: 200, height: 100}}/>

    <image id="image" mode="fill" corner="30" frame={{width: 200, height: 100}}/>
*/

$render(
  <vstack>
    <image url="https://zos.alipayobjects.com/rmsportal/ODTLcjxAfvqbxHnVXCYX.png" frame={{width: 20, height: 20}}/>
    <image id="image" frame={{width: 260, height: 60}}/>
  </vstack>
);
