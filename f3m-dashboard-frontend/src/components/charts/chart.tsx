import React, { useEffect, useRef, useState } from "react";

//OUTSIDE COMPONENTS
import { ChartType } from "chart.js";

//INSIDE COMPONENTS´
import LineChart from "./typeCharts/lineChart";
import DoughnutChart from "./typeCharts/doughnutChart"
import BarChart, { BarChartProps } from "./typeCharts/barChart";

//CSS

//TYPES IMPORTS
import { LineChartProps as LineProps } from "./typeCharts/lineChart";
import { DoughnutChartProps as DoughnutProps } from "./typeCharts/doughnutChart"

export interface MainChartProps extends LineProps, DoughnutProps,BarChartProps {
    typeOfChart?: ChartType | string;
    children?: any;
    chartClasses?: string;
}

const MainChart = ({ typeOfChart,
    xAxisData,
    //labelsXAxis,
    data,
    chartLabels,
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
    tooltipCallback,
    yAxesTicksMin,
    yAxesTicksMax,
    customTooltip,
    yAxesTicksCallback,
    yAxesStepSize,
    hidden = false,
    chartClasses,
}: MainChartProps) => {

    return (
        <div className={`chart-container ${chartClasses} `}>
            {(() => {
                switch (typeOfChart) {
                    case undefined:
                        return <p>UNDEFINED !!! (WAITING FOR A EMPTY STATE)</p>
                        case "bar":
                            return <BarChart
                                xAxisData={xAxisData}
                                //labelsXAxis={labelsXAxis}
                                firstLabelData={firstLabelData}
                                firstBorderColorData={firstBorderColorData}
                                firstBackgroundColorData={firstBackgroundColorData}
                                firstData={firstData}
                                secondLabelData={secondLabelData}
                                secondBorderColorData={secondBorderColorData}
                                secondBackgroundColorData={secondBackgroundColorData}
                                secondData={secondData}
                                thirdLabelData={thirdLabelData}
                                thirdBorderColorData={thirdBorderColorData}
                                thirdBackgroundColorData={thirdBackgroundColorData}
                                thirdData={thirdData}
                                fourthLabelData={fourthLabelData}
                                fourthBorderColorData={fourthBorderColorData}
                                fourthBackgroundColorData={fourthBackgroundColorData}
                                fourthData={fourthData}
                                fifthLabelData={fifthLabelData}
                                fifthBorderColorData={fifthBorderColorData}
                                fifthBackgroundColorData={fifthBackgroundColorData}
                                fifthData={fifthData}
                                xAxisType={xAxisType}
                                legendDisplay={legendDisplay}
                                dateFrom={dateFrom}
                                dateTo={dateTo}
                                data={data}
                                chartLabels={chartLabels}
                                //customTooltip={customTooltip}
                                tooltipCallback={tooltipCallback}
                                yAxesTicksMin={yAxesTicksMin}
                                yAxesTicksMax={yAxesTicksMax}
                                yAxesTicksCallback={yAxesTicksCallback}
                                yAxesStepSize={yAxesStepSize}
                                hidden={hidden}
                            ></BarChart>
                    case "line":
                        return <LineChart
                            xAxisData={xAxisData}
                            //labelsXAxis={labelsXAxis}
                            firstLabelData={firstLabelData}
                            firstBorderColorData={firstBorderColorData}
                            firstBackgroundColorData={firstBackgroundColorData}
                            firstData={firstData}
                            secondLabelData={secondLabelData}
                            secondBorderColorData={secondBorderColorData}
                            secondBackgroundColorData={secondBackgroundColorData}
                            secondData={secondData}
                            thirdLabelData={thirdLabelData}
                            thirdBorderColorData={thirdBorderColorData}
                            thirdBackgroundColorData={thirdBackgroundColorData}
                            thirdData={thirdData}
                            fourthLabelData={fourthLabelData}
                            fourthBorderColorData={fourthBorderColorData}
                            fourthBackgroundColorData={fourthBackgroundColorData}
                            fourthData={fourthData}
                            fifthLabelData={fifthLabelData}
                            fifthBorderColorData={fifthBorderColorData}
                            fifthBackgroundColorData={fifthBackgroundColorData}
                            fifthData={fifthData}
                            xAxisType={xAxisType}
                            legendDisplay={legendDisplay}
                            dateFrom={dateFrom}
                            dateTo={dateTo}
                            //customTooltip={customTooltip}
                            tooltipCallback={tooltipCallback}
                            yAxesTicksMin={yAxesTicksMin}
                            yAxesTicksMax={yAxesTicksMax}
                            yAxesTicksCallback={yAxesTicksCallback}
                            yAxesStepSize={yAxesStepSize}
                            hidden={hidden}
                        ></LineChart>
                    case "doughnut":
                        return <DoughnutChart
                            chartLabels={chartLabels}
                            firstLabelData={firstLabelData}
                            firstBorderColorData={firstBorderColorData}
                            firstBackgroundColorData={firstBackgroundColorData}
                            firstData={firstData}
                            customTooltip={customTooltip}
                            tooltipCallback={tooltipCallback}
                        ></DoughnutChart>
                    default:
                        return <p>No Chart</p>
                }
            })()}
        </div>
    );
};

export default MainChart;
