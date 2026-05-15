
//
// ScriptWidget
// https://xnu.app/scriptwidget
//
//


$render(
    <vstack frame={{maxWidth: "infinity", maxHeight: "infinity", alignment: "center"}}>
        <zstack>
            <vstack animation="clockSecond">
                <rect frame={{width: 5, height: 50}} color="yellow"></rect>
                <rect frame={{width: 5, height: 50}} color="clear"></rect>
            </vstack>
            <vstack animation="clockMinute">
                <rect frame={{width: 5, height: 40}} color="blue"></rect>
                <rect frame={{width: 5, height: 40}} color="clear"></rect>
            </vstack>
            <vstack animation="clockHour">
                <rect frame={{width: 5, height: 30}} color="red"></rect>
                <rect frame={{width: 5, height: 30}} color="clear"></rect>
            </vstack>
        </zstack>
    </vstack>
);

