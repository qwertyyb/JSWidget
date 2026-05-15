// 
// ScriptWidget 
// https://xnu.app/scriptwidget
// 
// Usage for component link
// 

$render(
  <vstack frame="max" linkurl="https://xnu.app/scriptwidget">
    <link url="https://www.baidu.com" backgroundColor="blue">
      <text font="title">Hello Baidu</text>
    </link>
    <link url="https://www.google.com" backgroundColor="green">
      <hstack>
        <text>Hello</text>
        <text>Google</text>
      </hstack>
    </link>
    <link url="https://www.bing.com" backgroundColor="yellow">
      <vstack>
        <text>Hello</text>
        <text>Bing</text>
      </vstack>
    </link>
  </vstack>
);

