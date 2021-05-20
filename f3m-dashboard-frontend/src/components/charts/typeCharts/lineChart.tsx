import React, { useEffect, useRef, useState } from "react";

//OUTSIDE COMPONENTS
import moment, { Moment } from 'moment';
import 'moment/locale/pt';
import 'moment/locale/en-gb'
import Chartjs, { ChartTooltipModel } from "chart.js";
import 'hammerjs';
import { PluginServiceRegistrationOptions, ChartColor, Scriptable, ChartPoint, ChartTooltipCallback, ChartLegendLabelItem, ChartData } from "chart.js";
import zoom from 'chartjs-plugin-zoom';

export interface LineChartProps {
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

	yAxesTicksCallback?: (
		value: string | number,
		index: number,
		values: number[] | string[]
	) => string | number | null | undefined;

	yAxesStepSize?: number
	hidden?: boolean
}

const LineChart = ({
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
	dateFrom,
	dateTo,
	//customTooltip,
	tooltipCallback,
	yAxesTicksMin,
	yAxesTicksMax,
	yAxesTicksCallback,
	yAxesStepSize = 1,
	hidden = false
}: LineChartProps) => {
	// initialise with null, but tell TypeScript we are looking for an HTMLCanvasElement
	const chartContainer = useRef<HTMLCanvasElement>(null);
	const [chartInstance, setChartInstance] = useState<Chart | null>();
	const [zoomOn, setZoomOn] = useState(false);
	const chartConfig = {
		type: "line",
		labels: ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul'],
		maintainAspectRatio: false,
		data: {
			x: xAxisData as number | string | Date | Moment,
			datasets: [{
				label: firstLabelData as string,
				fill: false,
				lineTension: 0.2,
				borderColor: firstBorderColorData as ChartColor | ChartColor[] | Scriptable<ChartColor>,
				backgroundColor: firstBackgroundColorData as ChartColor | ChartColor[] | Scriptable<ChartColor>,
				borderWidth: 1,
				pointHitRadius: 10,
				data: firstData as Array<number | null | undefined> | ChartPoint[]
			},
			{
				label: secondLabelData as string,
				fill: false,
				lineTension: 0.2,
				borderColor: secondBorderColorData as ChartColor | ChartColor[] | Scriptable<ChartColor>,
				backgroundColor: secondBackgroundColorData as ChartColor | ChartColor[] | Scriptable<ChartColor>,
				borderWidth: 1,
				pointHitRadius: 10,
				data: secondData as Array<number | null | undefined> | ChartPoint[]
			},
			{
				label: thirdLabelData as string,
				fill: false,
				lineTension: 0.2,
				borderColor: thirdBorderColorData as ChartColor | ChartColor[] | Scriptable<ChartColor>,
				backgroundColor: thirdBackgroundColorData as ChartColor | ChartColor[] | Scriptable<ChartColor>,
				borderWidth: 1,
				pointHitRadius: 10,
				data: thirdData as Array<number | null | undefined> | ChartPoint[]
			},
			{
				label: fourthLabelData as string,
				fill: false,
				lineTension: 0.2,
				borderColor: fourthBorderColorData as ChartColor | ChartColor[] | Scriptable<ChartColor>,
				backgroundColor: fourthBackgroundColorData as ChartColor | ChartColor[] | Scriptable<ChartColor>,
				borderWidth: 1,
				pointHitRadius: 10,
				data: fourthData as Array<number | null | undefined> | ChartPoint[]
			},
			{
				label: fifthLabelData as string,
				fill: false,
				lineTension: 0.2,
				borderColor: fifthBorderColorData as ChartColor | ChartColor[] | Scriptable<ChartColor>,
				backgroundColor: fifthBackgroundColorData as ChartColor | ChartColor[] | Scriptable<ChartColor>,
				borderWidth: 1,
				pointHitRadius: 10,
				data: fifthData as Array<number | null | undefined> | ChartPoint[]
			},
			],
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
				//custom: customTooltip as ((tooltipModel: ChartTooltipModel) => void) | undefined,
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
			responsive: false,
          	maintainAspectRatio: true,
			events: ['click'],

			scales: {
				xAxes: [{
					type: xAxisType as string,
					borderWidth: 1,
					ticks: {
						autoSkip: true,
						maxTicksLimit: 20,
						fontSize: 10,
						callback: function(value: string) {
							if(value.length > 10){
								return value.slice(0, 10) + "..."
						 	} else {
						 		return value
							}
					 	}
					},
					gridLines: {
						lineWidth: 1,
						color: 'rgba(0, 0, 0, 0.12)',
						zeroLineWidth: 1,
						zeroLineColor: 'rgba(0, 0, 0, 0.12)'
					},
					time: {
						parse: 'DD/MM/YYYY',
						tooltipFormat: 'DD MMM',
						displayFormats: {
							'day': 'DD MMM',
							'minute': 'DD MMM',
							'hour': 'DD MMM',
						},
						unit: 'day' as "day" | "millisecond" | "second" | "minute" | "hour" | "week" | "month" | "quarter" | "year" | undefined,
						min: dateFrom as string,
						max: dateTo as string
					}
				}],

				yAxes: [{
					borderWidth: 1,
					ticks: {
						min: yAxesTicksMin as number,//-0.1,
						max: yAxesTicksMax as number,
						stepSize: yAxesStepSize,
						fontSize: 10,
						callback: yAxesTicksCallback as (
							value: string | number,
							index: number,
							values: number[] | string[]
						) => string | number | null | undefined
					},
					gridLines: {
						lineWidth: 1,
						color: 'rgba(0, 0, 0, 0.12)',
						zeroLineWidth: 1,
						zeroLineColor: 'rgba(0, 0, 0, 0.12)'
					},
					scaleLabel: {
						show: true,
						labelString: 'Value'
					}
				}],
			},
		},
		plugins: pluginOfChart as PluginServiceRegistrationOptions[],
	};

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
	}, [dateTo, dateFrom, firstData]);

	return (
		<React.Fragment>
			<canvas hidden={hidden} ref={chartContainer} height="210px" className="chart" />
		</React.Fragment>
	);
};

export default LineChart;
