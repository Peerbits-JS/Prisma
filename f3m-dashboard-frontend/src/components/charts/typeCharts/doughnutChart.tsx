import React, { useEffect, useRef, useState } from "react";

//OUTSIDE COMPONENTS
import moment from 'moment';
import 'moment/locale/pt';
import 'moment/locale/en-gb'
import Chartjs, { ChartTooltipModel } from "chart.js";
import 'hammerjs';
import { PluginServiceRegistrationOptions, ChartColor, Scriptable, ChartPoint, ChartTooltipCallback, ChartLegendLabelItem, ChartData } from "chart.js";
import zoom from 'chartjs-plugin-zoom';

export interface DoughnutChartProps {
	pluginOfChart?: PluginServiceRegistrationOptions[],

	chartLabels?: any,

	xStacked?: boolean,
	yStacked?: boolean,

	firstLabelData?: string,
	firstBorderColorData?: ChartColor | ChartColor[] | Scriptable<ChartColor>,
	firstBackgroundColorData?: ChartColor | ChartColor[] | Scriptable<ChartColor>,
	firstData?: Array<number | null | undefined> | ChartPoint[];

	legendDisplay?: boolean,

	dateFrom?: string,
	dateTo?: string,

	tooltipCallback?: ChartTooltipCallback,
	customTooltip?: ((tooltipModel: ChartTooltipModel) => void) | undefined,

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

const DoughnutChart = ({
	chartLabels,
	firstBorderColorData,
	firstBackgroundColorData,
	firstData,
	tooltipCallback,
	legendDisplay,
	customTooltip,
}: DoughnutChartProps) => {
	// initialise with null, but tell TypeScript we are looking for an HTMLCanvasElement
	const chartContainer = useRef<HTMLCanvasElement>(null);
	const [width, setWidth] = useState(window.innerWidth);
	const [chartInstance, setChartInstance] = useState<Chart | null>();

	const updateWindowDimensions = () => {
		setWidth(window.innerWidth)
	}

	useEffect(() => {
		let language: string;
		language = localStorage.getItem("i18nextLng") || "pt";
		if (language.length > 2) {
			language = language.substr(0, 2).toUpperCase();
		}
		moment.locale(language)

		Chartjs.plugins.register(zoom);

		updateWindowDimensions();

		const chartConfig = {
			type: "doughnut",
			data: {
				labels: chartLabels as any,
				datasets: [{
					label: '# of Tomatoes',
					data: firstData as Array<number | null | undefined> | ChartPoint[],
					backgroundColor: firstBackgroundColorData as ChartColor | ChartColor[] | Scriptable<ChartColor>,
					borderColor: firstBorderColorData as ChartColor | ChartColor[] | Scriptable<ChartColor>,
					borderWidth: 1
				}],
			},
			options: {
				responsive: true,
          		maintainAspectRatio: false,
				cutoutPercentage: 60,
				tooltips: {
					enabled: true,
					custom: customTooltip as ((tooltipModel: ChartTooltipModel) => void) | undefined,
					mode: 'index' as "label" | "index" | "x" | "point" | "nearest" | "single" | "x-axis" | "dataset" | "y" | undefined,
					callbacks: tooltipCallback as ChartTooltipCallback,
					footerFontStyle: 'normal'
				},
				legend: {
					display: legendDisplay as boolean,
					position: "bottom" as "bottom" | "left" | "right" | "top" | "chartArea" | undefined,
					labels: {
						fontColor: "#494949",
						fontSize: 13,
						padding: 15,
						boxWidth: 12.5,
						filter: function (item: ChartLegendLabelItem, chart: ChartData) {
							if (item.text != undefined) {
								return !item.text.includes('null');
							}
						}
					}
				},
			},
		};
		// strict null checks need us to check if chartContainer and current exist.
		// but once current exists, it is of type HTMLCanvasElement
		if (chartContainer && chartContainer.current) {
			const newChartInstance = new Chartjs(chartContainer.current, chartConfig);
			setChartInstance(newChartInstance);
		}
	}, [firstData, chartLabels, window.innerWidth]);

	return (
		<React.Fragment>
			<canvas ref={chartContainer} height="75px" width="100%" className="chart" />
		</React.Fragment>
	);
};

export default DoughnutChart;
