import React, { FunctionComponent, useEffect, useState } from 'react';
import { useDispatch, useSelector, connect } from 'react-redux';
import {
    getMenu,
    loadBillingTotalForToday,
    loadBillingTotalForYesterday,
    loadBillingTotalForMonth,
    loadBillingTotalForYear,
    loadPerfomanceSummary
} from './../../store/actions/dashboardAction';
// INSIDE COMPONENTS
import ValuesCard from '../../components/valuesCard/valuesCard'

//OUTSIDE COMPONENTS
import Paper from '@material-ui/core/Paper';
import { makeStyles } from '@material-ui/core/styles';
import Chart from '../../components/charts/chart'
import FilterDashboard from './filterDashboard';
import { Typography } from '@material-ui/core';
import TrendingUpIcon from '@material-ui/icons/TrendingUp';
import AssessmentIcon from '@material-ui/icons/Assessment';
import ShoppingCartIcon from '@material-ui/icons/ShoppingCart';
import clsx from 'clsx';
import Divider from '@material-ui/core/Divider';
import InputLabel from '@material-ui/core/InputLabel';
import MenuItem from '@material-ui/core/MenuItem';
import FormControl from '@material-ui/core/FormControl';
import Select from '@material-ui/core/Select';
import bar from '../../assets/images/bar.jpg';
import SubHeaderDashboard from './subHeaderDashboard';
import Breadcrumbs from '../../components/breadcrumbs/breadcrumbs';
import NumberFormat from 'react-number-format';
import Loader from "react-loader-spinner";
interface DashboardPageProps {
    getMenuFunc: Function,
    menu: any,
}

const useStyles = makeStyles((theme: any) => ({
    root: {
        display: "flex",
        width: "auto",
        border: "1px solid #d2f3ff",
        margin: 13,
        borderRadius: 10,
        
        // minHeight: "calc(100vh - 176px)",
        // maxHeight: "calc(100vh - 176px)",
        position: "relative"
    },
    loaderContainer: {
        textAlign: 'center',
        marginTop: '10px'
    },
    cardloader: {
        position: 'absolute',
        left: '38%',
        top: '38%',
        'z-index': '999',
    },
    lightopicity: {
        opacity: '0.5'
    },
    inputRoot: {
        '&.MuiAutocomplete-inputRoot': {
            paddingBottom: 3
        }
    },
    card: {
        height: "calc(100% - 30px)",
        borderColor: "#dadada",
        boxShadow: "0px 3px 8px rgba(0,0,0,0.08)",
        color: "#444444",
        borderRadius: 6,
        display: "flex",
        flexDirection: "column",
        marginBottom: 30,
        minHeight: 300,
        '&.blue': {
            borderColor: "#73ccf0",
            '& .card-body': {
                color: "#007eb0"
            }
        },
        '&.pink': {
            backgroundColor: "#fff0f5",
            borderColor: "#fcc7d9",
            '& .card-body': {
                color: "#ec407a"
            }
        },
        '&.purple': {
            backgroundColor: "#edf0ff",
            borderColor: "#c0c9fc",
            '& .card-body': {
                color: "#5c6bc0"
            }
        },
        '&.aqua': {
            backgroundColor: "#f0fdff",
            borderColor: "#c7f6fc",
            '& .card-body': {
                color: "#26c6da"
            }
        },
        '&.green': {
            backgroundColor: "#f0fff0",
            borderColor: "#c5fac8",
            '& .card-body': {
                color: "#66bb6a"
            }
        },
        '&.orange': {
            backgroundColor: "#fff8ed",
            borderColor: "#fae4c3",
            '& .card-body': {
                color: "#ffa726"
            }
        },
    },

    title: {
        fontWeight: "bold",
        fontFamily: "Open Sans",
        marginBottom: 20
    },
    subtitle: {
        fontWeight: "bold",
        fontFamily: "Open Sans",
        textTransform: "uppercase"
    },
    pageContent: {
        display: "flex",
        flexDirection: "column",
        padding: 20,
        width: '100%',
        height: "calc(100vh - 50px)",
        marginBottom:20,
        overflowY: "auto"
    },
    chartIcon: {
        textAlign: "center"
    },
    chartValue: {
        fontSize: 30,
        textAlign: "center"
    },
    leagend: {
        color: "#666666"
    },
    leagendValue: {
        fontWeight: 500
    },
    chartCountWrapper: {
        position: "relative",
        zIndex: 1
    },
    chartCount: {
        fontWeight: 'bold',
        position: "absolute",
        top: "50%",
        left: 0,
        right: 0,
        textAlign: "center",
        transform: "translateY(-50%)",
        zIndex: -1,
        color: "#444444"
    },
    formControl: {
        minWidth: 165,
        '& label.Mui-focused': {
            color: "#0098d2"
        },
        '& .MuiOutlinedInput-root': {
            backgroundColor: "#FFF",
            '&.Mui-focused .MuiOutlinedInput-notchedOutline': {
                borderColor: "#0098d2"
            }
        }
    }
}));

const mapStateToProps = (state: any) => {
    const { menu } = state.dashboard;
    return { menu };
};

const mapDispatchToProps = (dispatch: any) => ({
    getMenuFunc: () => dispatch(getMenu()),
});


const DashboardPage = ({ getMenuFunc, menu }: DashboardPageProps) => {
    const classes = useStyles();
    const [age, setAge] = React.useState('');

    const monthNames = [
        'Janeiro',
        'Fevereiro',
        'Março',
        'Abril',
        'Maio',
        'Junho',
        'Julho',
        'Agosto',
        'Setembro',
        'Outubro',
        'Novembro',
        'Dezembro'
    ];

    const payload: any = {
        storesId: [],
        usersId: [],
        referenceDate: new Date(),
        isSale: true
    }

    let month = monthNames[payload.referenceDate.getMonth()];
    let year = payload.referenceDate.getFullYear();

    const [currentMonth, setCurrentMonth] = React.useState(month);
    const [currentYear, setCurrentYear] = React.useState(year);

    const dispatch = useDispatch();

    const dashboardData: any =
    {
        billing:
        {
            billingTotalToday: useSelector((state: any) => state.dashboard.billing.billingTotalToday),
            billingTotalYesterday: useSelector((state: any) => state.dashboard.billing.billingTotalYesterday),
            billingTotalCurrentMonth: useSelector((state: any) => state.dashboard.billing.billingTotalCurrentMonth),
            billingTotalCurrentYear: useSelector((state: any) => state.dashboard.billing.billingTotalCurrentYear)
        },
        performance: {
            total: useSelector((state: any) => state.dashboard.performance.total),
            aros: useSelector((state: any) => state.dashboard.performance.aros),
            opthalmicLenses: useSelector((state: any) => state.dashboard.performance.opthalmicLenses),
            contactLenses: useSelector((state: any) => state.dashboard.performance.contactLenses),
            sunGlasses: useSelector((state: any) => state.dashboard.performance.sunGlasses),
            several: useSelector((state: any) => state.dashboard.performance.several)
        },
        chart: useSelector((state: any) => state.dashboard.chart),
        dashboarddata: {
            userdata: useSelector((state: any) => state.dashboard.dashboarddata.userdata),
            shopdata: useSelector((state: any) => state.dashboard.dashboarddata.shopdata)
        },
        loadapi: useSelector((state: any) => state.dashboard.loadapi)
    }

    const changePerfomace = (event: React.ChangeEvent<{ value: unknown }>) => {
        //perfomance
        dispatch(loadPerfomanceSummary(payload));
    };

    const BindDashboard = ((payload: any) => {
        // billing 
        dispatch(loadBillingTotalForToday(payload));
        dispatch(loadBillingTotalForYesterday(payload));
        dispatch(loadBillingTotalForMonth(payload));
        dispatch(loadBillingTotalForYear(payload));
        //perfomance

        dispatch(loadPerfomanceSummary(payload));
        //menu
        // dispatch(getMenu());
    })

    const filterChanged = ((obj: any) => {

        payload.isSale = obj.isSale;
        payload.referenceDate = obj.referenceDate;
        payload.storesId = obj.storesId;
        payload.usersId = obj.usersId;

        setCurrentMonth(monthNames[obj.referenceDate.getMonth()]);
        setCurrentYear(obj.referenceDate.getFullYear());
        BindDashboard(payload);
    });

    useEffect(() => {
        BindDashboard(payload);
        // getMenuFunc().then((isValid: boolean) => {
        //     if (!isValid) return;
        //     BindDashboard(payload);
        // });
    }, []);

    const setPercentageColor = (percentage: string) => {

        if (Number(percentage) < 0) {
            return '#f44336';
        }
        else if (Number(percentage) > 0) {
            return '#4caf50';
        }
        else {
            return '#A9A9A9';
        }

    }

    return (
        <>
            {/* <Breadcrumbs /> */}

            <SubHeaderDashboard menu={menu} filterChanged={(obj: any) => { filterChanged(obj) }} />
            {
                dashboardData.billing.billingTotalToday &&
                    dashboardData.performance.total &&
                    dashboardData.chart.xAxis ?

                    <div className={clsx(classes.root, "content my-0")}>
                        <FilterDashboard filterChanged={(obj: any) => { filterChanged(obj) }} />
                        <div className={classes.pageContent}>
                            <Typography variant="h6" component="h2" className={classes.title}>
                                <TrendingUpIcon /> Faturação
                </Typography>
                            <div className="row">
                                {/* {upcoming.slice(0, 4).map((game : any, ) => */}

                                <div className={`col-xl-3 col-md-6`}>
                                    <ValuesCard
                                        colorOfValueSection="#007eb0"
                                        colorBorderOfValueSection="#007eb0"
                                        colorTextOfValueSection="#ffffff"
                                        colorTextOfBodyTitleSection="#007eb0"
                                        colorTextOfBodyTitle2Section="#007eb0"
                                        percentageColor="#ffffff"
                                        percentageTextColor={setPercentageColor(dashboardData.billing.billingTotalToday.percentage)}
                                        value={<NumberFormat value={dashboardData.billing.billingTotalToday.total ? dashboardData.billing.billingTotalToday.total.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />}
                                        percentage={dashboardData.billing.billingTotalToday.percentage}
                                        title="Total hoje"
                                        bodyTitle1="VALOR MÉDIO POR DOCUMENTO"
                                        bodyContent1={<NumberFormat value={dashboardData.billing.billingTotalToday.averageAmount ? dashboardData.billing.billingTotalToday.averageAmount.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />}
                                        bodyTitle2="Nº de Documentos emitidos"
                                        bodyContent2={<NumberFormat value={dashboardData.billing.billingTotalToday.noOfDocsIssued} displayType={'text'} thousandSeparator={true} />}
                                        isLoading={dashboardData.loadapi ? dashboardData.loadapi.isLoadingBillingtoday : false}
                                    />
                                </div>
                                <div className="col-xl-3 col-md-6">
                                    <ValuesCard
                                        colorOfValueSection="#e6eff2"
                                        colorBorderOfValueSection="#c8dfe8"
                                        colorTextOfValueSection="#444444"
                                        percentage={dashboardData.billing.billingTotalYesterday.percentage}
                                        percentageTextColor={setPercentageColor(dashboardData.billing.billingTotalYesterday.percentage)}
                                        title="Total ontem"
                                        bodyTitle1="VALOR MÉDIO POR DOCUMENTO"
                                        bodyTitle2="Nº de Documentos emitidos"
                                        value={<NumberFormat value={dashboardData.billing.billingTotalYesterday.total ? dashboardData.billing.billingTotalYesterday.total.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />}
                                        bodyContent1={<NumberFormat value={dashboardData.billing.billingTotalYesterday.averageAmount ? dashboardData.billing.billingTotalYesterday.averageAmount.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />}
                                        bodyContent2={<NumberFormat value={dashboardData.billing.billingTotalYesterday.noOfDocsIssued} displayType={'text'} thousandSeparator={true} />}
                                        isLoading={dashboardData.loadapi ? dashboardData.loadapi.isLoadingBillingyesterday : false}
                                    />
                                </div>
                                <div className="col-xl-3 col-md-6">
                                    <ValuesCard
                                        colorOfValueSection="#e6eff2"
                                        colorBorderOfValueSection="#c8dfe8"
                                        colorTextOfValueSection="#444444"
                                        percentageTextColor={setPercentageColor(dashboardData.billing.billingTotalCurrentMonth.percentage)}
                                        percentage={dashboardData.billing.billingTotalCurrentMonth.percentage}
                                        title={'Total MÊS ' + currentMonth}
                                        bodyTitle1="VALOR MÉDIO POR DOCUMENTO"
                                        bodyTitle2="Nº de Documentos emitidos"
                                        value={<NumberFormat value={dashboardData.billing.billingTotalCurrentMonth.total ? dashboardData.billing.billingTotalCurrentMonth.total.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />}
                                        bodyContent1={<NumberFormat value={dashboardData.billing.billingTotalCurrentMonth.averageAmount ? dashboardData.billing.billingTotalCurrentMonth.averageAmount.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />}
                                        bodyContent2={<NumberFormat value={dashboardData.billing.billingTotalCurrentMonth.noOfDocsIssued} displayType={'text'} thousandSeparator={true} />}
                                        isLoading={dashboardData.loadapi ? dashboardData.loadapi.isLoadingBillingmonth : false}
                                    />
                                </div>
                                <div className="col-xl-3 col-md-6">
                                    <ValuesCard
                                        colorOfValueSection="#e6eff2"
                                        colorBorderOfValueSection="#c8dfe8"
                                        colorTextOfValueSection="#444444"
                                        percentageTextColor={setPercentageColor(dashboardData.billing.billingTotalCurrentYear.percentage)}
                                        percentage={dashboardData.billing.billingTotalCurrentYear.percentage}
                                        title={"Total ANO " + currentYear}
                                        bodyTitle1="VALOR MÉDIO POR DOCUMENTO"
                                        bodyTitle2="Nº de Documentos emitidos"
                                        value={<NumberFormat value={dashboardData.billing.billingTotalCurrentYear.total ? dashboardData.billing.billingTotalCurrentYear.total.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />}
                                        bodyContent1={<NumberFormat value={dashboardData.billing.billingTotalCurrentYear.averageAmount ? dashboardData.billing.billingTotalCurrentYear.averageAmount.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />}
                                        bodyContent2={<NumberFormat value={dashboardData.billing.billingTotalCurrentYear.noOfDocsIssued} displayType={'text'} thousandSeparator={true} />}
                                        isLoading={dashboardData.loadapi ? dashboardData.loadapi.isLoadingBillingyear : false}
                                    />
                                </div>
                                {/* )} */}
                            </div>
                            <div className="mt-5">
                                <Typography variant="h6" component="h2" className={`${classes.title} d-flex align-items-center flex-wrap`}>
                                    <AssessmentIcon /> <span className="ml-1 mr-3">Performance</span>
                                    <FormControl size="small" variant="outlined" className={classes.formControl}>
                                        <InputLabel id="demo-simple-select-outlined-label">Referência</InputLabel>
                                        <Select
                                            labelId="demo-simple-select-outlined-label"
                                            id="demo-simple-select-outlined"
                                            // displayEmpty
                                            onChange={changePerfomace}
                                            label="Referência"
                                            MenuProps={{
                                                anchorOrigin: {
                                                    vertical: "bottom",
                                                    horizontal: "left"
                                                },
                                                transformOrigin: {
                                                    vertical: "top",
                                                    horizontal: "left"
                                                },
                                                getContentAnchorEl: null
                                            }}
                                        >
                                            <MenuItem value={1}>Todos</MenuItem>
                                            <MenuItem value={10}>Dia atual</MenuItem>
                                            <MenuItem value={20}>Dia anterior</MenuItem>
                                            <MenuItem value={30}>Mês</MenuItem>
                                            <MenuItem value={40}>Ano</MenuItem>
                                        </Select>
                                    </FormControl>
                                </Typography>
                                <div className="row">
                                    <div className="col-xl-3">
                                        <Paper variant="outlined" className={`${classes.card} p-4 blue`}>
                                            <Typography variant="subtitle2" component="h3" className={`${classes.subtitle} mb-3`}>
                                                TOTAL
                        </Typography>
                                            <div className={clsx(classes.loaderContainer, classes.cardloader)}>
                                                <Loader type="TailSpin" color="#5c6bc0" height={50} width={50} visible={dashboardData.loadapi ? dashboardData.loadapi.isLoadingPerfomanceSummary : false} />
                                            </div>
                                            <div className="card-body p-0 d-flex justify-content-center flex-column align-items-center">
                                                <div className={`${classes.chartIcon}`}><ShoppingCartIcon fontSize="large" /></div>
                                                <div className={`${classes.chartValue} mt-2 mb-3 font-medium`}><NumberFormat value={dashboardData.performance.total.totalCurrency ? dashboardData.performance.total.totalCurrency.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />€</div>
                                            </div>
                                            <div className={`${classes.leagend}`}>
                                                <div className="d-flex justify-content-between">
                                                    <div>
                                                        <Typography variant="caption">
                                                            MÉDIA POR DOC.
                              </Typography>
                                                    </div>
                                                    <div>
                                                        <Typography className={`${classes.leagendValue}`} variant="caption">
                                                            <NumberFormat value={dashboardData.performance.total.averageCurrency ? dashboardData.performance.total.averageCurrency.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />€
                              </Typography>
                                                    </div>
                                                </div>
                                                <Divider className="my-2" />
                                                <div className="d-flex justify-content-between">
                                                    <div>
                                                        <Typography variant="caption">
                                                            Nº DOCS.
                              </Typography>
                                                    </div>
                                                    <div>
                                                        <Typography className={`${classes.leagendValue}`} variant="caption">
                                                            <NumberFormat value={dashboardData.performance.total.numberOfDocuments} displayType={'text'} thousandSeparator={true} />
                                                        </Typography>
                                                    </div>
                                                </div>
                                            </div>
                                        </Paper>
                                    </div>
                                    <div className="col-xl-6">
                                        <Paper variant="outlined" className={`${classes.card} p-4`}>
                                            <Typography variant="subtitle2" component="h3" className={`${classes.subtitle} mb-3`}>
                                                Total por grupos de artigos
                        </Typography>
                                            <div className={clsx(classes.loaderContainer, classes.cardloader)}>
                                                <Loader type="TailSpin" color="#5c6bc0" height={50} width={50} visible={dashboardData.loadapi ? dashboardData.loadapi.isLoadingPerfomanceSummary : false} />
                                            </div>
                                            <Chart
                                                typeOfChart="bar"
                                                chartClasses="w-100"
                                                xAxisType='time'
                                                firstBorderColorData={"#ec407a"}
                                                firstBackgroundColorData={"#ec407a"}
                                                secondBorderColorData={"#5c6bc0"}
                                                secondBackgroundColorData={"#5c6bc0"}
                                                thirdBorderColorData={"#26c6da"}
                                                thirdBackgroundColorData={"#26c6da"}
                                                fourthBorderColorData={"#66bb6a"}
                                                fourthBackgroundColorData={"#66bb6a"}
                                                fifthBorderColorData={"#ffa726"}
                                                fifthBackgroundColorData={"#ffa726"}


                                                data={dashboardData.chart.yAxis}
                                                chartLabels={dashboardData.chart.xAxis}

                                                // dateFrom ={'03/01/2021'}
                                                // dateTo ={'03/05/2021'}
                                                legendDisplay={true}
                                                yAxesTicksMin={0}
                                                yAxesTicksMax={100}
                                                yAxesStepSize={20}
                                                customTooltip={function (tooltip) {
                                                    // disable displaying the color box;
                                                    tooltip.displayColors = true;
                                                }}
                                                yAxesTicksCallback={(value, position, array) => {
                                                    if (position === 0) {
                                                        return value + '%';
                                                    }
                                                    return value + '%'
                                                }}
                                            > </Chart>
                                        </Paper>
                                    </div>
                                    <div className="col-xl-3 col-md-6">
                                        <Paper variant="outlined" className={`${classes.card} p-4 pink`}>
                                            <Typography variant="subtitle2" component="h3" className={`${classes.subtitle} mb-3`}>
                                                AROS
                        </Typography>
                                            <div className={clsx(classes.loaderContainer, classes.cardloader)}>
                                                <Loader type="TailSpin" color="#5c6bc0" height={50} width={50} visible={dashboardData.loadapi ? dashboardData.loadapi.isLoadingPerfomanceSummary : false} />
                                            </div>
                                            <div className="card-body p-0 d-flex justify-content-center flex-column align-items-center">
                                                <div className={`${classes.chartCountWrapper}`}>
                                                    <Typography className={`${classes.chartCount}`} variant="caption">
                                                        {dashboardData.performance.aros.percentage}%
                            </Typography>
                                                    <Chart
                                                        typeOfChart='doughnut'
                                                        chartLabels={
                                                            ['Label1', 'Label2', 'Label3', 'Label4']
                                                        }
                                                        firstBackgroundColorData={[
                                                            '#ec407a',
                                                            '#cccccc'
                                                        ]}
                                                        firstBorderColorData={[
                                                            '#ec407a',
                                                            '#cccccc'
                                                        ]}
                                                        firstData={
                                                            [dashboardData.performance.aros.percentage, 100 - dashboardData.performance.aros.percentage]
                                                        }
                                                        tooltipCallback={{
                                                            label: function (tooltipItem: any, data: any): string | string[] {
                                                                let dataset = (data.datasets || '')[tooltipItem.datasetIndex];
                                                                let total: number = (dataset.data || '').reduce(function (previousValue: number, currentValue: number) {
                                                                    return previousValue + currentValue;
                                                                });
                                                                let currentValue = dataset.data[tooltipItem.index] as number;
                                                                let precentage = Math.floor(((currentValue / total) * 100) + 0.5);
                                                                return precentage + "%";
                                                            }
                                                        }}
                                                    >
                                                    </Chart>
                                                </div>
                                                <div className={`${classes.chartValue} mt-2 mb-3`}>
                                                    <NumberFormat value={dashboardData.performance.aros.totalCurrency ? dashboardData.performance.aros.totalCurrency.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />€</div>
                                            </div>
                                            <div className={`${classes.leagend}`}>
                                                <div className="d-flex justify-content-between">
                                                    <div>
                                                        <Typography variant="caption">
                                                            MÉDIA POR DOC.
                              </Typography>
                                                    </div>
                                                    <div>
                                                        <Typography className={`${classes.leagendValue}`} variant="caption">
                                                            <NumberFormat value={dashboardData.performance.aros.averageCurrency ? dashboardData.performance.aros.averageCurrency.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />€
                              </Typography>
                                                    </div>
                                                </div>
                                                <Divider className="my-2" />
                                                <div className="d-flex justify-content-between">
                                                    <div>
                                                        <Typography variant="caption">
                                                            Nº DOCS.
                              </Typography>
                                                    </div>
                                                    <div>
                                                        <Typography className={`${classes.leagendValue}`} variant="caption">
                                                            <NumberFormat value={dashboardData.performance.aros.numberOfDocuments} displayType={'text'} thousandSeparator={true} />
                                                        </Typography>
                                                    </div>
                                                </div>
                                            </div>

                                        </Paper>
                                    </div>
                                    <div className="col-xl-3 col-md-6">
                                        <Paper variant="outlined" className={`${classes.card} p-4 purple`}>
                                            <Typography variant="subtitle2" component="h3" className={`${classes.subtitle} mb-3`}>
                                                LENTES OFTÁLMICAS
                        </Typography>
                                            <div className={clsx(classes.loaderContainer, classes.cardloader)}>
                                                <Loader type="TailSpin" color="#5c6bc0" height={50} width={50} visible={dashboardData.loadapi ? dashboardData.loadapi.isLoadingPerfomanceSummary : false} />
                                            </div>
                                            <div className="card-body p-0 d-flex justify-content-center flex-column align-items-center">
                                                <div className={`${classes.chartCountWrapper}`}>
                                                    <Typography className={`${classes.chartCount}`} variant="caption">
                                                        {dashboardData.performance.contactLenses.percentage}%
                            </Typography>
                                                    <Chart
                                                        typeOfChart='doughnut'
                                                        chartLabels={
                                                            ['Label1', 'Label2', 'Label3', 'Label4']
                                                        }
                                                        firstBackgroundColorData={[
                                                            '#5c6bc0',
                                                            '#cccccc'
                                                        ]}
                                                        firstBorderColorData={[
                                                            '#5c6bc0',
                                                            '#cccccc'
                                                        ]}
                                                        firstData={
                                                            [dashboardData.performance.contactLenses.percentage, 100 - dashboardData.performance.contactLenses.percentage]
                                                        }
                                                        tooltipCallback={{
                                                            label: function (tooltipItem: any, data: any): string | string[] {
                                                                let dataset = (data.datasets || '')[tooltipItem.datasetIndex];
                                                                let total: number = (dataset.data || '').reduce(function (previousValue: number, currentValue: number) {
                                                                    return previousValue + currentValue;
                                                                });
                                                                let currentValue = dataset.data[tooltipItem.index] as number;
                                                                let precentage = Math.floor(((currentValue / total) * 100) + 0.5);
                                                                return precentage + "%";
                                                            }
                                                        }}
                                                    >
                                                    </Chart>
                                                </div>
                                                <div className={`${classes.chartValue} mt-2 mb-3`}>
                                                    <NumberFormat value={dashboardData.performance.contactLenses.totalCurrency ? dashboardData.performance.contactLenses.totalCurrency.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />€

                              </div>
                                            </div>
                                            <div className={`${classes.leagend}`}>
                                                <div className="d-flex justify-content-between">
                                                    <div>
                                                        <Typography variant="caption">
                                                            MÉDIA POR DOC.
                              </Typography>
                                                    </div>
                                                    <div>
                                                        <Typography className={`${classes.leagendValue}`} variant="caption">
                                                            <NumberFormat value={dashboardData.performance.contactLenses.averageCurrency ? dashboardData.performance.contactLenses.averageCurrency.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />€
                              </Typography>
                                                    </div>
                                                </div>
                                                <Divider className="my-2" />
                                                <div className="d-flex justify-content-between">
                                                    <div>
                                                        <Typography variant="caption">
                                                            Nº DOCS.
                              </Typography>
                                                    </div>
                                                    <div>
                                                        <Typography className={`${classes.leagendValue}`} variant="caption">
                                                            <NumberFormat value={dashboardData.performance.contactLenses.numberOfDocuments} displayType={'text'} thousandSeparator={true} />
                                                        </Typography>
                                                    </div>
                                                </div>
                                            </div>

                                        </Paper>
                                    </div>
                                    <div className="col-xl-3 col-md-6">
                                        <Paper variant="outlined" className={`${classes.card} p-4 aqua`}>
                                            <Typography variant="subtitle2" component="h3" className={`${classes.subtitle} mb-3`}>
                                                LENTES DE CONTACTO
                        </Typography>
                                            <div className={clsx(classes.loaderContainer, classes.cardloader)}>
                                                <Loader type="TailSpin" color="#5c6bc0" height={50} width={50} visible={dashboardData.loadapi ? dashboardData.loadapi.isLoadingPerfomanceSummary : false} />
                                            </div>
                                            <div className="card-body p-0 d-flex justify-content-center flex-column align-items-center">
                                                <div className={`${classes.chartCountWrapper}`}>
                                                    <Typography className={`${classes.chartCount}`} variant="caption">
                                                        {dashboardData.performance.opthalmicLenses.percentage}%
                            </Typography>
                                                    <Chart
                                                        typeOfChart='doughnut'
                                                        chartLabels={
                                                            ['Label1', 'Label2', 'Label3', 'Label4']
                                                        }
                                                        firstBackgroundColorData={[
                                                            '#26c6da',
                                                            '#cccccc'
                                                        ]}
                                                        firstBorderColorData={[
                                                            '#26c6da',
                                                            '#cccccc'
                                                        ]}
                                                        firstData={
                                                            [dashboardData.performance.opthalmicLenses.percentage, 100 - dashboardData.performance.opthalmicLenses.percentage]
                                                        }
                                                        tooltipCallback={{
                                                            label: function (tooltipItem: any, data: any): string | string[] {
                                                                let dataset = (data.datasets || '')[tooltipItem.datasetIndex];
                                                                let total: number = (dataset.data || '').reduce(function (previousValue: number, currentValue: number) {
                                                                    return previousValue + currentValue;
                                                                });
                                                                let currentValue = dataset.data[tooltipItem.index] as number;
                                                                let precentage = Math.floor(((currentValue / total) * 100) + 0.5);
                                                                return precentage + "%";
                                                            }
                                                        }}
                                                    >
                                                    </Chart>
                                                </div>
                                                <div className={`${classes.chartValue} mt-2 mb-3`}>
                                                    <NumberFormat value={dashboardData.performance.opthalmicLenses.totalCurrency ? dashboardData.performance.opthalmicLenses.totalCurrency.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />€
                              </div>
                                            </div>
                                            <div className={`${classes.leagend}`}>
                                                <div className="d-flex justify-content-between">
                                                    <div>
                                                        <Typography variant="caption">
                                                            MÉDIA POR DOC.
                              </Typography>
                                                    </div>
                                                    <div>
                                                        <Typography className={`${classes.leagendValue}`} variant="caption">
                                                            <NumberFormat value={dashboardData.performance.opthalmicLenses.averageCurrency ? dashboardData.performance.opthalmicLenses.averageCurrency.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />€

                              </Typography>
                                                    </div>
                                                </div>
                                                <Divider className="my-2" />
                                                <div className="d-flex justify-content-between">
                                                    <div>
                                                        <Typography variant="caption">
                                                            Nº DOCS.
                              </Typography>
                                                    </div>
                                                    <div>
                                                        <Typography className={`${classes.leagendValue}`} variant="caption">
                                                            <NumberFormat value={dashboardData.performance.opthalmicLenses.numberOfDocuments} displayType={'text'} thousandSeparator={true} />
                                                        </Typography>
                                                    </div>
                                                </div>
                                            </div>

                                        </Paper>
                                    </div>
                                    <div className="col-xl-3 col-md-6">
                                        <Paper variant="outlined" className={`${classes.card} p-4 green`}>
                                            <Typography variant="subtitle2" component="h3" className={`${classes.subtitle} mb-3`}>
                                                DIVERSOS
                        </Typography>
                                            <div className={clsx(classes.loaderContainer, classes.cardloader)}>
                                                <Loader type="TailSpin" color="#5c6bc0" height={50} width={50} visible={dashboardData.loadapi ? dashboardData.loadapi.isLoadingPerfomanceSummary : false} />
                                            </div>
                                            <div className="card-body p-0 d-flex justify-content-center flex-column align-items-center">
                                                <div className={`${classes.chartCountWrapper}`}>
                                                    <Typography className={`${classes.chartCount}`} variant="caption">
                                                        {dashboardData.performance.several.percentage}%
                            </Typography>
                                                    <Chart
                                                        typeOfChart='doughnut'
                                                        chartLabels={
                                                            ['Label1', 'Label2', 'Label3', 'Label4']
                                                        }
                                                        firstBackgroundColorData={[
                                                            '#66bb6a',
                                                            '#cccccc'
                                                        ]}
                                                        firstBorderColorData={[
                                                            '#66bb6a',
                                                            '#cccccc'
                                                        ]}
                                                        firstData={
                                                            [dashboardData.performance.several.percentage, 100 - dashboardData.performance.several.percentage]
                                                        }
                                                        tooltipCallback={{
                                                            label: function (tooltipItem: any, data: any): string | string[] {
                                                                let dataset = (data.datasets || '')[tooltipItem.datasetIndex];
                                                                let total: number = (dataset.data || '').reduce(function (previousValue: number, currentValue: number) {
                                                                    return previousValue + currentValue;
                                                                });
                                                                let currentValue = dataset.data[tooltipItem.index] as number;
                                                                let precentage = Math.floor(((currentValue / total) * 100) + 0.5);
                                                                return precentage + "%";
                                                            }
                                                        }}
                                                    >
                                                    </Chart>
                                                </div>
                                                <div className={`${classes.chartValue} mt-2 mb-3`}>
                                                    <NumberFormat value={dashboardData.performance.several.totalCurrency ? dashboardData.performance.several.totalCurrency.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />€
                              </div>
                                            </div>
                                            <div className={`${classes.leagend}`}>
                                                <div className="d-flex justify-content-between">
                                                    <div>
                                                        <Typography variant="caption">
                                                            MÉDIA POR DOC.
                              </Typography>
                                                    </div>
                                                    <div>
                                                        <Typography className={`${classes.leagendValue}`} variant="caption">
                                                            <NumberFormat value={dashboardData.performance.several.averageCurrency ? dashboardData.performance.several.averageCurrency.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />€
                              </Typography>
                                                    </div>
                                                </div>
                                                <Divider className="my-2" />
                                                <div className="d-flex justify-content-between">
                                                    <div>
                                                        <Typography variant="caption">
                                                            Nº DOCS.
                              </Typography>
                                                    </div>
                                                    <div>
                                                        <Typography className={`${classes.leagendValue}`} variant="caption">
                                                            <NumberFormat value={dashboardData.performance.several.numberOfDocuments} displayType={'text'} thousandSeparator={true} />
                                                        </Typography>
                                                    </div>
                                                </div>
                                            </div>

                                        </Paper>
                                    </div>
                                    <div className="col-xl-3 col-md-6">
                                        <Paper variant="outlined" className={`${classes.card} p-4 orange`}>
                                            <Typography variant="subtitle2" component="h3" className={`${classes.subtitle} mb-3`}>
                                                ÓCULOS DE SOL
                        </Typography>
                                            <div className={clsx(classes.loaderContainer, classes.cardloader)}>
                                                <Loader type="TailSpin" color="#5c6bc0" height={50} width={50} visible={dashboardData.loadapi ? dashboardData.loadapi.isLoadingPerfomanceSummary : false} />
                                            </div>
                                            <div className="card-body p-0 d-flex justify-content-center flex-column align-items-center">
                                                <div className={`${classes.chartCountWrapper}`}>
                                                    <Typography className={`${classes.chartCount}`} variant="caption">
                                                        {dashboardData.performance.sunGlasses.percentage}%
                            </Typography>
                                                    <Chart
                                                        typeOfChart='doughnut'
                                                        chartLabels={
                                                            ['Label1', 'Label2', 'Label3', 'Label4']
                                                        }
                                                        firstBackgroundColorData={[
                                                            '#ffa726',
                                                            '#cccccc'
                                                        ]}
                                                        firstBorderColorData={[
                                                            '#ffa726',
                                                            '#cccccc'
                                                        ]}
                                                        firstData={
                                                            [dashboardData.performance.sunGlasses.percentage, 100 - dashboardData.performance.sunGlasses.percentage]
                                                        }
                                                        tooltipCallback={{
                                                            label: function (tooltipItem: any, data: any): string | string[] {
                                                                let dataset = (data.datasets || '')[tooltipItem.datasetIndex];
                                                                let total: number = (dataset.data || '').reduce(function (previousValue: number, currentValue: number) {
                                                                    return previousValue + currentValue;
                                                                });
                                                                let currentValue = dataset.data[tooltipItem.index] as number;
                                                                let precentage = Math.floor(((currentValue / total) * 100) + 0.5);
                                                                return precentage + "%";
                                                            }
                                                        }}
                                                    >
                                                    </Chart>
                                                </div>
                                                <div className={`${classes.chartValue} mt-2 mb-3`}>
                                                    <NumberFormat value={dashboardData.performance.sunGlasses.totalCurrency ? dashboardData.performance.sunGlasses.totalCurrency.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />€</div>
                                            </div>
                                            <div className={`${classes.leagend}`}>
                                                <div className="d-flex justify-content-between">
                                                    <div>
                                                        <Typography variant="caption">
                                                            MÉDIA POR DOC.
                              </Typography>
                                                    </div>
                                                    <div>
                                                        <Typography className={`${classes.leagendValue}`} variant="caption">
                                                            <NumberFormat value={dashboardData.performance.sunGlasses.averageCurrency ? dashboardData.performance.sunGlasses.averageCurrency.toFixed(2) : '0.00'} displayType={'text'} thousandSeparator={true} />€

                              </Typography>
                                                    </div>
                                                </div>
                                                <Divider className="my-2" />
                                                <div className="d-flex justify-content-between">
                                                    <div>
                                                        <Typography variant="caption">
                                                            Nº DOCS.
                              </Typography>
                                                    </div>
                                                    <div>
                                                        <Typography className={`${classes.leagendValue}`} variant="caption">
                                                            <NumberFormat value={dashboardData.performance.sunGlasses.numberOfDocuments} displayType={'text'} thousandSeparator={true} />
                                                        </Typography>
                                                    </div>
                                                </div>
                                            </div>


                                        </Paper>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                    :
                    <div className={clsx(classes.loaderContainer)}>
                        <Loader type="TailSpin" color="#5c6bc0" height={100} width={100} visible={true ? dashboardData.billing : false} />
                    </div>


            }


        </>

    )

}

export default connect(mapStateToProps, mapDispatchToProps)(DashboardPage);