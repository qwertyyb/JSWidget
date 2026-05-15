// 
// ScriptWidget 
// https://xnu.app/scriptwidget
// 
// 

var d = new Date();

const weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
let day = weekday[d.getDay()];


$render(
    <vstack
        backgroundColor="red"
        frame={{maxWidth: "infinity", maxHeight: "infinity", alignment: "center"}}
    >
        <text font="largeTitle" color="black" padding={10}>
            {day}
        </text>
    </vstack>
);
