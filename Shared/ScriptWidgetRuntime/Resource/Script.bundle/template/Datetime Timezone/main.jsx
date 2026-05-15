
//
// ScriptWidget
// https://xnu.app/scriptwidget
//
//

const widget_size = $getenv("widget-size");
const widget_param = $getenv("widget-param");

const beijingDate = new Date().toLocaleString("zh-CN", { timeZone: "Asia/Shanghai" }).toLocaleString();
const sanJoseDate = new Date().toLocaleString("zh-CN", { timeZone: "America/Los_Angeles" }).toLocaleString();
const newYorkDate = new Date().toLocaleString("zh-CN", { timeZone: "America/New_York" }).toLocaleString();
const sydneyDate = new Date().toLocaleString("zh-CN", { timeZone: "Australia/Sydney" }).toLocaleString();

$render(
    <hstack frame="max">
        <vstack alignment="leading">
            <text font="title3" color="blue" font={{custom: "Unispace", size: 14}}>Beijing:</text>
            <text font="title3" color="green" font={{custom: "Unispace", size: 14}}>San Jose:</text>
            <text font="title3" color="orange" font={{custom: "Unispace", size: 14}}>New York:</text>
            <text font="title3" color="secondary" font={{custom: "Unispace", size: 14}}>Sydney:</text>
        </vstack>
        <vstack alignment="leading">
            <text font="title3" color="red" font={{custom: "Unispace", size: 14}}>{beijingDate}</text>
            <text font="title3" color="yellow" font={{custom: "Unispace", size: 14}}>{sanJoseDate}</text>
            <text font="title3" color="purple" font={{custom: "Unispace", size: 14}}>{newYorkDate}</text>
            <text font="title3" color="gray" font={{custom: "Unispace", size: 14}}>{sydneyDate}</text>
        </vstack>
    </hstack>
);
