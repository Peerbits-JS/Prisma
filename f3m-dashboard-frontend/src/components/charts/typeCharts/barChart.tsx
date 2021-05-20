import React, { useEffect, useRef, useState } from "react";

//OUTSIDE COMPONENTS
import moment, { Moment } from 'moment';
import 'moment/locale/pt';
import 'moment/locale/en-gb'
import Chartjs, { ChartTooltipModel } from "chart.js";
import 'hammerjs';
import { PluginServiceRegistrationOptions, ChartColor, Scriptable, ChartPoint, ChartTooltipCallback, ChartLegendLabelItem, ChartData } from "chart.js";
import zoom from 'chartjs-plugin-zoom';

export interface BarChartProps {
	pluginOfChart?: PluginServiceRegistrationOptions[],
	xAxisData?: number | string | Date | Moment,

	//labelsXAxis?: (string | TFunctionResult | undefined | number | Date | Moment | number[] | string[] | Date[] | Moment[])[] | undefined,

	firstLabelData?: string,
	firstBorderColorData?: ChartColor | ChartColor[] | Scriptable<ChartColor>,
	firstBackgroundColorData?: ChartColor | ChartColor[] | Scriptable<ChartColor>,
	firstData?: Array<number | null | undefined> | ChartPoint[];

	secondLabelData?: string,
	secondBorderColorData?: ChartColor | ChartColor[] | Scriptable<ChartColor>,
	secondBackgroundColorData?: ChartColor | ChartColor[] | Scriptable<ChartColor>,
	secondData?: Array<number | null | undefined> | ChartPoint[];

	thirdLabelData?: string,
	thirdBorderColorData?: ChartColor | ChartColor[] | Scriptable<ChartColor>,
	thirdBackgroundColorData?: ChartColor | ChartColor[] | Scriptable<ChartColor>,
	thirdData?: Array<number | null | undefined> | ChartPoint[];

	fourthLabelData?: string,
	fourthBorderColorData?: ChartColor | ChartColor[] | Scriptable<ChartColor>,
	fourthBackgroundColorData?: ChartColor | ChartColor[] | Scriptable<ChartColor>,
	fourthData?: Array<number | null | undefined> | ChartPoint[];

	fifthLabelData?: string,
	fifthBorderColorData?: ChartColor | ChartColor[] | Scriptable<ChartColor>,
	fifthBackgroundColorData?: ChartColor | ChartColor[] | Scriptable<ChartColor>,
	fifthData?: Array<number | null | undefined> | ChartPoint[];

	xAxisType?: string,

	legendDisplay?: boolean

	dateFrom?: string,
	dateTo?: string,

	tooltipCallback?: ChartTooltipCallback,
	//customTooltip?: ((tooltipModel: ChartTooltipModel) => void) | undefined,

	yAxesTicksMin?: number,
	yAxesTicksMax?: number,

	data?: any
	chartLabels?: any;

	yAxesTicksCallback?: (
		value: string | number,
		index: number,
		values: number[] | string[]
	) => string | number | null | undefined;

	yAxesStepSize?: number
	hidden?: boolean
}

const BarChart = ({
	pluginOfChart,
	xAxisData,
	//labelsXAxis,
	firstLabelData,
	firstBorderColorData,
	firstBackgroundColorData,
	firstData,
	secondLabelData,
	secondBorderColorData,
	secondBackgroundColorData,
	secondData,
	thirdLabelData,
	thirdBorderColorData,
	thirdBackgroundColorData,
	thirdData,
	fourthLabelData,
	fourthBorderColorData,
	fourthBackgroundColorData,
	fourthData,
	fifthLabelData,
	fifthBorderColorData,
	fifthBackgroundColorData,
	fifthData,
	xAxisType,
	legendDisplay,
	data,
	chartLabels,
	dateFrom,
	dateTo,
	//customTooltip,
	tooltipCallback,
	yAxesTicksMin,
	yAxesTicksMax,
	yAxesTicksCallback,
	yAxesStepSize = 1,
	hidden = false
}: BarChartProps) => {

	// initialise with null, but tell TypeScript we are looking for an HTMLCanvasElement
	const chartContainer = useRef<HTMLCanvasElement>(null);
	const [chartInstance, setChartInstance] = useState<Chart | null>();
	const [zoomOn, setZoomOn] = useState(false);

	const chartConfig = {
		type: "bar",
		maintainAspectRatio: true,
		data: {
			labels: [],
			datasets: [
				{
					label: firstLabelData,
					backgroundColor: '#ec407a',
					borderWidth: 2,
					data: firstData
				},
				{
					label: secondLabelData,
					backgroundColor: 'rgb(92, 107, 192)',
					borderWidth: 2,
					data: secondData
				},
				{
					label: thirdLabelData,
					backgroundColor: 'rgb(38, 198, 218)',
					borderWidth: 2,
					data: thirdData
				},
				{
					label: fourthLabelData,
					backgroundColor: 'rgb(102, 187, 106)',
					borderWidth: 2,
					data: fourthData
				},
				{
					label: fifthLabelData,
					backgroundColor: 'rgb(255, 167, 38)',
					borderWidth: 2,
					data: fifthData
				}
			]
		},
		options: {
			legend: {
				display: legendDisplay as boolean,
				position: 'bottom' as "bottom" | "left" | "right" | "top" | "chartArea" | undefined,
				labels: {
					fontSize: 10,
					boxWidth: 20,
					filter: function (item: ChartLegendLabelItem, chart: ChartData) {
						if (item.text != undefined) {
							return !item.text.includes('null');
						}
					}
				}
			},

			tooltips: {
				enabled: true,
				// custom: customTooltip as ((tooltipModel: ChartTooltipModel) => void) | undefined,
				mode: 'index' as "label" | "index" | "x" | "point" | "nearest" | "single" | "x-axis" | "dataset" | "y" | undefined,
				callbacks: tooltipCallback as ChartTooltipCallback,
				footerFontStyle: 'normal'
			},
			pan: {
				enabled: true,
				mode: 'x'
			},
			zoom: {
				enabled: zoomOn,
				mode: 'x'
			},
			responsive: true,
			maintainAspectRatio: true,
			events: ['click'],

			scales: {
				xAxes: [{
					gridLines: {
						offsetGridLines: true
					}
				}],
				yAxes: [{
					ticks: {  
						beginAtZero:true,
						maxTicksLimit: 0,
						max:100
					  }
				  }] 
			}
		},
		plugins: pluginOfChart as PluginServiceRegistrationOptions[],
	};

	fillChartData();

	function fillChartData() {

		chartConfig.data.datasets = [];

		const dataArray = data.split(',');
		const labelArray = chartLabels.split(',');

		const background = [
			'#ec407a',
			'#5c6bc0',
			'#26c6da',
			'#66bb6a',
			'#ffa726'
		]

		dataArray.forEach((item: any, index: number) => {

			let label: string = labelArray[index];
			label = label.replace('[', '');
			label = label.replace(']', '');
			label = label.replace(/"/g, "");
			let dataNumber = item.replace(/[^0-9]/, "")

			let updatedObject =
			{
				label: label,
				backgroundColor: background[index],
				borderWidth: 3,
				data: [dataNumber]
			}

			chartConfig.data.datasets.push(updatedObject);

		});
	}

	useEffect(() => {
		let language: string;
		language = localStorage.getItem("i18nextLng") || "pt";
		if (language.length > 2) {
			language = language.substr(0, 2).toUpperCase();
		}
		moment.locale(language)

		Chartjs.plugins.register(zoom);

		// strict null checks need us to check if chartContainer and current exist.
		// but once current exists, it is of type HTMLCanvasElement
		if (chartContainer && chartContainer.current) {
			const newChartInstance = new Chartjs(chartContainer.current, chartConfig);
			setChartInstance(newChartInstance);
		}
	}, []);

	return (
		<React.Fragment>
			<canvas hidden={hidden} ref={chartContainer} height="210px" className="chart" />
		</React.Fragment>
	);
};

export default BarChart;
