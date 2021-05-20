import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { createStyles, Theme, makeStyles, withStyles } from '@material-ui/core/styles';
import Button from '@material-ui/core/Button';
import Dialog, { DialogProps } from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogTitle from '@material-ui/core/DialogTitle';
import MenuItem from '@material-ui/core/MenuItem';
import Table from '@material-ui/core/Table';
import TableBody from '@material-ui/core/TableBody';
import TableCell from '@material-ui/core/TableCell';
import TableContainer from '@material-ui/core/TableContainer';
import TableHead from '@material-ui/core/TableHead';
import TableRow from '@material-ui/core/TableRow';
import TableFooter from '@material-ui/core/TableFooter';
import { IconButton, Menu, Typography } from '@material-ui/core';
import ExpandMoreIcon from '@material-ui/icons/ExpandMore';
import CloseIcon from '@material-ui/icons/Close';
import TextField from '@material-ui/core/TextField';
import InputAdornment from '@material-ui/core/InputAdornment';
import Select from '@material-ui/core/Select';
import { DragDropContext, Droppable, Draggable } from 'react-beautiful-dnd';
import { loadSales, saveSales, updateSalesData } from './../../store/actions/salesAction';
import Snackbar from '@material-ui/core/Snackbar';
import MuiAlert, { AlertProps } from '@material-ui/lab/Alert';
import NumberFormat from 'react-number-format';

interface IProps {
    isModalOpen: boolean;
    handleClose: any;
}

const StyledTableCell = withStyles((theme: Theme) =>
    createStyles({
        head: {
            backgroundColor: theme.palette.action.hover,
            // color: theme.palette.common.white,
            padding: "6px 6px 6px 6px",
            border: "1px solid #cccccc",
            fontWeight: 400,
            lineHeight: 1.43
        },
        body: {
            fontSize: 14,
            whiteSpace: "nowrap",
            padding: "6px 6px 6px 6px",
            border: "1px solid #cccccc"

        },
        footer: {
            fontSize: 14,
            color: "rgba(0, 0, 0, 0.87)",
            padding: "6px 6px 6px 6px",
            border: "1px solid #cccccc"
        }
    }),
)(TableCell);

const StyledTableRow = withStyles((theme: Theme) =>
    createStyles({
        root: {
            '&:nth-of-type(even)': {
                backgroundColor: theme.palette.action.hover,
            },
        }
    }),
)(TableRow);

function createData(name: string, jan: number, feb: number, march: number, april: number, may: number, june: number, july: number, aug: number, sep: number, oct: number, nov: number, dec: number) {
    return { name, jan, feb, march, april, may, june, july, aug, sep, oct, nov, dec };
}

const useStyles = makeStyles((theme: Theme) =>
    createStyles({
        table: {
            // minWidth: 700,
        },
        dialogTitle: {
            borderBottom: "1px solid #dadada",
            color: "#444",
            '& .MuiTypography-h6': {
                fontWeight: "bold"
            }
        },
        dialogContent: {
            paddingTop: theme.spacing(3),
            paddingBottom: theme.spacing(3),
        },
        dialogActions: {
            paddingTop: theme.spacing(2),
            paddingBottom: theme.spacing(2),
            paddingLeft: theme.spacing(3),
            paddingRight: theme.spacing(3),
            borderTop: "1px solid #dadada"
        },
        primaryButton: {
            backgroundColor: "rgba(0, 152, 210, 1)",
            color: "#FFF",
            minWidth: 100,
            boxShadow: "none",
            '&:hover': {
                backgroundColor: "rgba(4, 123, 169, 1)"
            },
        },
        tableInput: {
            '& .MuiInput-root': {
                fontSize: "0.875rem",
                '& .MuiInputBase-input': {
                    padding: "1px 0",
                    textAlign: "right",
                    '&:hover': {
                        backgroundColor: "rgba(0,0,0,.1)"
                    },
                    '&:active': {
                        backgroundColor: "rgba(0,0,0,.1)"
                    },
                    '&:focus': {
                        backgroundColor: "rgba(0,0,0,.1)"
                    }
                }
            },
            '& .MuiInput-underline:after': {
                display: "none"
            },
            '& .MuiInput-underline:before': {
                display: "none"
            },
            '& .MuiInputAdornment-positionEnd': {
                marginLeft: 1
            },
            '& .MuiTypography-body1': {
                fontSize: "0.875rem",
                color: "rgba(0, 0, 0, 0.87)",
            }
        },
        yearSelect: {
            color: "#444",
            marginLeft: theme.spacing(1),
            '& .MuiSelect-root': {
                fontSize: "1.25rem",
                paddingTop: 0,
                paddingBottom: 0,
                fontWeight: "bold"
            },
            '&:after': {
                display: "none"
            },
            '&:before': {
                display: "none"
            },
        }
    }),
);

interface NumberFormatCustomProps {
    inputRef: (instance: NumberFormat | null) => void;
    onChange: (event: { target: { name: string; value: string } }) => void;
    name: string;
}

interface NumberFormatCustomProps {
    inputRef: (instance: NumberFormat | null) => void;
    onChange: (event: { target: { name: string; value: string } }) => void;
    name: string;
}

function NumberFormatCustom(props: NumberFormatCustomProps) {
    const { inputRef, onChange, ...other } = props;

    return (
        <NumberFormat
            {...other}
            getInputRef={inputRef}
            onValueChange={(values) => {
                onChange({
                    target: {
                        name: props.name,
                        value: values.value,
                    },
                });
            }}
            thousandSeparator
            isNumericString
        // suffix="€"
        />
    );
}

interface State {
    numberformat: string;
}

const ITEM_HEIGHT = 48;
const ITEM_PADDING_TOP = 8;

export default function MaxWidthDialog(props: IProps) {
    const classes = useStyles();
    const [year, setYear] = React.useState(new Date().getFullYear());
    const dispatch = useDispatch();
    let arraySalesData: any = {}
    const [salesData, setSalesData] = React.useState(arraySalesData);

    const handleChangeYear = (event: React.ChangeEvent<{ value: any }>) => {

        setYear(event.target.value);
        dispatch(loadSales(event.target.value));

        if (arraySalesData) {
            calculateSalesData(arraySalesData);
        }
    };

    const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null);

    const saveRecord = (event: React.MouseEvent<HTMLButtonElement>) => {

        let updatedArray: any = [];

        arraySalesData.forEach((item: any) => {

            let itemobject =
            {
                id: item.id,
                shopNo: item.shopNo,
                shopName: item.shopName,
                year: item.year,
                janSales: item.janSales,
                febSales: item.febSales,
                marSales: item.marSales,
                aprSales: item.aprSales,
                maySales: item.maySales,
                junSales: item.junSales,
                julSales: item.julSales,
                augSales: item.augSales,
                sepSales: item.sepSales,
                octSales: item.octSales,
                novSales: item.novSales,
                decSales: item.decSales

            }

            updatedArray.push(itemobject);

        });

        let payload =
        {
            shopWiseSales: updatedArray
        }

        dispatch(saveSales(payload));
    };

    const handleCloseMenu = () => {
        setAnchorEl(null);
    };

    const [values, setValues] = React.useState<State>({
        numberformat: '2000',
    });

    const handleChangeTableInput = (event: React.ChangeEvent<HTMLInputElement>, col: string, index: any) => {
        
        let changedValue = Number(event.target.value);
        const items = arraySalesData;
        items[index][col] = changedValue;
        arraySalesData = items;
        calculateSalesData(arraySalesData);

    };

    function handleOnDragEnd(result: any) {

        if (!result.destination) return;

        const items = Array.from(arraySalesData);

        const reorderedItemDestionation = items[result.destination.index];
        const reorderedItemSource = items[result.source.index];

        items[result.source.index] = reorderedItemDestionation;
        items[result.destination.index] = reorderedItemSource;

        arraySalesData = items;

    }

    const BindSalesData = ((year: number) => {

        useEffect(() => {
            dispatch(loadSales(year));
        }, [dispatch]);



    })

    useEffect(() => {
        dispatch(updateSalesData(arraySalesData));
    }, [dispatch]);


    const calculateSalesData = ((obj: any) => {
        obj.totaljan = 0;
        obj.totalfeb = 0;
        obj.totalmar = 0;
        obj.totalapr = 0;
        obj.totalmay = 0;
        obj.totaljun = 0;
        obj.totaljul = 0;
        obj.totalaug = 0;
        obj.totalsep = 0;
        obj.totaloct = 0;
        obj.totalnov = 0;
        obj.totaldec = 0;
        obj.mainTotal = 0;

        obj.map((item: any) => {

            item.total = 0;

            // shop wise total
            item.total = item.janSales + item.febSales + item.marSales + item.aprSales + item.maySales + item.junSales +
                item.julSales + item.augSales + item.sepSales + item.octSales + item.novSales + item.decSales;

            // main total

            obj.mainTotal += item.total;

            // month wise total
            obj.totaljan += item.janSales;
            obj.totalfeb += item.febSales;
            obj.totalmar += item.marSales;
            obj.totalapr += item.aprSales;
            obj.totalmay += item.maySales;
            obj.totaljun += item.junSales;
            obj.totaljul += item.julSales;
            obj.totalaug += item.augSales;
            obj.totalsep += item.sepSales;
            obj.totaloct += item.octSales;
            obj.totalnov += item.novSales;
            obj.totaldec += item.decSales;

        })

        arraySalesData = obj;

        dispatch(updateSalesData(arraySalesData));

    });


    BindSalesData(year);

    function formatNumber(parmnumber: number) {
        let x, x1, x2, number: any;

        number = parmnumber.toFixed(2) + '';
        x = number.split('.');
        x1 = x[0];
        var rgx = /(\d+)(\d{3})/;
        while (rgx.test(x1)) {
            x1 = x1.replace(rgx, '$1' + ',' + '$2');
        }
        return x1;
    }


    arraySalesData = useSelector((state: any) => state.sales.salesData.shopWiseSales);

    if (arraySalesData) {

        calculateSalesData(arraySalesData);
    }

    arraySalesData = useSelector((state: any) => state.sales.salesData.shopWiseSales);

    function Alert(props: any) {
        return <MuiAlert elevation={6} variant="filled" {...props} />;
    }



    return (
        <React.Fragment>

            <Dialog
                maxWidth="lg"
                open={props.isModalOpen}
                onClose={props.handleClose}
                aria-labelledby="max-width-dialog-title">

                {/* <Snackbar
                    anchorOrigin={{
                        vertical: 'top',
                        horizontal: 'right',
                    }}
                    open={true}
                    autoHideDuration={5}
                    action={

                        <Alert severity="success">Data saved Successfully </Alert>

                    }
                /> */}

                {arraySalesData ?

                    <div>

                        <DialogTitle id="max-width-dialog-title" className={classes.dialogTitle}>
                            <div className="d-flex align-items-center">
                                <Typography variant="h6" component="h2">
                                    Objetivos de Venda
                                <Select
                                        labelId="demo-simple-select-placeholder-label-label"
                                        id="demo-simple-select-placeholder-label"
                                        onChange={handleChangeYear}
                                        value={year}
                                        className={classes.yearSelect}
                                        displayEmpty
                                        MenuProps={{
                                            anchorOrigin: {
                                                vertical: "bottom",
                                                horizontal: "left"
                                            },
                                            transformOrigin: {
                                                vertical: "top",
                                                horizontal: "left"
                                            },
                                            getContentAnchorEl: null,
                                            PaperProps: {
                                                style: {
                                                    maxHeight: ITEM_HEIGHT * 4.5 + ITEM_PADDING_TOP
                                                }
                                            }
                                        }}
                                    >
                                        <MenuItem value={2022}>2022</MenuItem>
                                        <MenuItem value={2021}>2021</MenuItem>
                                        <MenuItem value={2020}>2020</MenuItem>
                                        <MenuItem value={2019}>2019</MenuItem>
                                        <MenuItem value={2018}>2018</MenuItem>
                                        <MenuItem value={2017}>2017</MenuItem>
                                        <MenuItem value={2016}>2016</MenuItem>
                                    </Select>
                                </Typography>
                                {/* <IconButton aria-controls="simple-menu" aria-haspopup="true" size="small"  onClick={handleClick}>
        <ExpandMoreIcon />
    </IconButton>
    <Menu
        id="simple-menu"
        anchorEl={anchorEl}
        keepMounted
        open={Boolean(anchorEl)}
        onClose={handleCloseMenu}
        >
        <MenuItem onClick={handleCloseMenu}>2022</MenuItem>
        <MenuItem onClick={handleCloseMenu}>2021</MenuItem>
        <MenuItem onClick={handleCloseMenu}>2020</MenuItem>
    </Menu> */}
                                <IconButton aria-controls="simple-menu" className="ml-auto" aria-haspopup="true" size="small" onClick={props.handleClose}>
                                    <CloseIcon />
                                </IconButton>
                            </div>
                        </DialogTitle>
                        <DragDropContext onDragEnd={handleOnDragEnd}>
                            <Droppable droppableId="salesTable">
                                {(provided) => (

                                    <DialogContent className={classes.dialogContent}>
                                        <TableContainer className="salesTable" {...provided.droppableProps} ref={provided.innerRef}>
                                            <Table className={classes.table} size="small" aria-label="customized table">
                                                <TableHead>
                                                    <TableRow>
                                                        <StyledTableCell>Loja</StyledTableCell>
                                                        <StyledTableCell align="right">Janeiro</StyledTableCell>
                                                        <StyledTableCell align="right">Fevereiro</StyledTableCell>
                                                        <StyledTableCell align="right">Março</StyledTableCell>
                                                        <StyledTableCell align="right">Abril</StyledTableCell>
                                                        <StyledTableCell align="right">Maio</StyledTableCell>
                                                        <StyledTableCell align="right">Junho</StyledTableCell>
                                                        <StyledTableCell align="right">Julho</StyledTableCell>
                                                        <StyledTableCell align="right">Agosto</StyledTableCell>
                                                        <StyledTableCell align="right">Setembro</StyledTableCell>
                                                        <StyledTableCell align="right">Outubro</StyledTableCell>
                                                        <StyledTableCell align="right">Novembro</StyledTableCell>
                                                        <StyledTableCell align="right">Dezembro</StyledTableCell>
                                                        <StyledTableCell align="right">Total</StyledTableCell>
                                                    </TableRow>
                                                </TableHead>
                                                <TableBody>
                                                    {

                                                    }
                                                    {arraySalesData.map((row: any, index: any) => (

                                                        <Draggable key={'row_' + index} draggableId={'row_' + index} index={index}>
                                                            {(provided) => (

                                                                <StyledTableRow key={row.name} {...provided.draggableProps} {...provided.dragHandleProps} ref={provided.innerRef}>


                                                                    <StyledTableCell component="th" scope="row">
                                                                        {row.shopName}
                                                                    </StyledTableCell>


                                                                    <StyledTableCell align="right">

                                                                        <TextField
                                                                            defaultValue={formatNumber(row.janSales)}
                                                                            placeholder="0"
                                                                            className={classes.tableInput}
                                                                            InputProps={{
                                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,
                                                                            }}
                                                                            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleChangeTableInput(e, 'janSales', index)}
                                                                        />
                                                                    </StyledTableCell>
                                                                    <StyledTableCell align="right">
                                                                        <TextField
                                                                            defaultValue={formatNumber(row.febSales)}
                                                                            placeholder="0"
                                                                            className={classes.tableInput}
                                                                            InputProps={{
                                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                                            }}
                                                                            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleChangeTableInput(e, 'febSales', index)}
                                                                        />
                                                                    </StyledTableCell>
                                                                    <StyledTableCell align="right">
                                                                        <TextField
                                                                            defaultValue={formatNumber(row.marSales)}
                                                                            placeholder="0"
                                                                            className={classes.tableInput}
                                                                            InputProps={{
                                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                                            }}
                                                                            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleChangeTableInput(e, 'marSales', index)}
                                                                        />
                                                                    </StyledTableCell>
                                                                    <StyledTableCell align="right">
                                                                        <TextField
                                                                            defaultValue={formatNumber(row.aprSales)}
                                                                            placeholder="0"
                                                                            className={classes.tableInput}
                                                                            InputProps={{
                                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                                            }}
                                                                            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleChangeTableInput(e, 'aprSales', index)}
                                                                        />
                                                                    </StyledTableCell>
                                                                    <StyledTableCell align="right">
                                                                        <TextField
                                                                            defaultValue={formatNumber(row.maySales)}
                                                                            placeholder="0"
                                                                            className={classes.tableInput}
                                                                            InputProps={{
                                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                                            }}
                                                                            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleChangeTableInput(e, 'maySales', index)}
                                                                        />
                                                                    </StyledTableCell>
                                                                    <StyledTableCell align="right">
                                                                        <TextField
                                                                            defaultValue={formatNumber(row.junSales)}
                                                                            placeholder="0"
                                                                            className={classes.tableInput}
                                                                            InputProps={{
                                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                                            }}
                                                                            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleChangeTableInput(e, 'junSales', index)}
                                                                        />
                                                                    </StyledTableCell>
                                                                    <StyledTableCell align="right">
                                                                        <TextField
                                                                          defaultValue={formatNumber(row.julSales)}
                                                                            placeholder="0"
                                                                            className={classes.tableInput}
                                                                            InputProps={{
                                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                                            }}
                                                                            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleChangeTableInput(e, 'julSales', index)}
                                                                        />
                                                                    </StyledTableCell>
                                                                    <StyledTableCell align="right">
                                                                        <TextField
                                                                            defaultValue={formatNumber(row.augSales)}
                                                                            placeholder="0"
                                                                            className={classes.tableInput}
                                                                            InputProps={{
                                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                                            }}
                                                                            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleChangeTableInput(e, 'augSales', index)}
                                                                        />
                                                                    </StyledTableCell>
                                                                    <StyledTableCell align="right">
                                                                        <TextField
                                                                            defaultValue={formatNumber(row.sepSales)}
                                                                            placeholder="0"
                                                                            className={classes.tableInput}
                                                                            InputProps={{
                                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                                            }}
                                                                            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleChangeTableInput(e, 'sepSales', index)}
                                                                        />
                                                                    </StyledTableCell>
                                                                    <StyledTableCell align="right">
                                                                        <TextField
                                                                            defaultValue={formatNumber(row.octSales)}
                                                                            placeholder="0"
                                                                            className={classes.tableInput}
                                                                            InputProps={{
                                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                                            }}
                                                                            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleChangeTableInput(e, 'octSales', index)}
                                                                        />
                                                                    </StyledTableCell>
                                                                    <StyledTableCell align="right">
                                                                        <TextField
                                                                            defaultValue={formatNumber(row.novSales)}
                                                                            placeholder="0"
                                                                            className={classes.tableInput}
                                                                            InputProps={{
                                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                                            }}
                                                                            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleChangeTableInput(e, 'novSales', index)}
                                                                        />
                                                                    </StyledTableCell>
                                                                    <StyledTableCell align="right">
                                                                        <TextField
                                                                            defaultValue={formatNumber(row.decSales)}
                                                                            placeholder="0"
                                                                            className={classes.tableInput}
                                                                            InputProps={{
                                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                                            }}
                                                                            onChange={(e: React.ChangeEvent<HTMLInputElement>) => handleChangeTableInput(e, 'decSales', index)}
                                                                        />
                                                                    </StyledTableCell>
                                                                    <StyledTableCell align="right">


                                                                        <TextField disabled
                                                                            defaultValue={formatNumber(row.total)}
                                                                            placeholder="0"
                                                                            className={classes.tableInput}
                                                                            InputProps={{
                                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                                            }}
                                                                        />

                                                                    </StyledTableCell>

                                                                </StyledTableRow>


                                                            )}


                                                        </Draggable>
                                                    ))}
                                                    {provided.placeholder}
                                                </TableBody>
                                                <TableFooter>
                                                    <StyledTableRow>
                                                        <StyledTableCell component="th" scope="row">Total</StyledTableCell>
                                                        <StyledTableCell align="right">
                                                            <TextField

                                                                disabled
                                                                // defaultValue={row.dec}
                                                                defaultValue={formatNumber(arraySalesData.totaljan)}
                                                                placeholder="0"
                                                                className={classes.tableInput}
                                                                InputProps={{
                                                                    endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                                }}
                                                            />
                                                        </StyledTableCell>
                                                        <StyledTableCell align="right"><TextField
                                                            disabled
                                                            
                                                            defaultValue={formatNumber(arraySalesData.totalfeb)}
                                                            
                                                            placeholder="0"
                                                            className={classes.tableInput}
                                                            InputProps={{
                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                            }}

                                                        /></StyledTableCell>
                                                        <StyledTableCell align="right"> <TextField
                                                            disabled
                                                            defaultValue={formatNumber(arraySalesData.totalmar)}
                                                            placeholder="0"
                                                            className={classes.tableInput}
                                                            InputProps={{
                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                            }}

                                                        /></StyledTableCell>
                                                        <StyledTableCell align="right"><TextField
                                                            disabled
                                                            defaultValue={formatNumber(arraySalesData.totalapr)}
                                                            placeholder="0"
                                                            className={classes.tableInput}
                                                            InputProps={{
                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                            }}
                                                        /></StyledTableCell>
                                                        <StyledTableCell align="right"><TextField
                                                            disabled
                                                            defaultValue={formatNumber(arraySalesData.totalmay)}
                                                            placeholder="0"
                                                            className={classes.tableInput}
                                                            InputProps={{
                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                            }}
                                                        /></StyledTableCell>
                                                        <StyledTableCell align="right"><TextField
                                                            disabled
                                                            defaultValue={formatNumber(arraySalesData.totaljun)}
                                                            placeholder="0"
                                                            className={classes.tableInput}
                                                            InputProps={{
                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                            }}
                                                        /></StyledTableCell>
                                                        <StyledTableCell align="right"><TextField
                                                            disabled
                                                            defaultValue={formatNumber(arraySalesData.totaljul)}
                                                            placeholder="0"
                                                            className={classes.tableInput}
                                                            InputProps={{
                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                            }}

                                                        /></StyledTableCell>
                                                        <StyledTableCell align="right"><TextField
                                                            disabled
                                                            defaultValue={formatNumber(arraySalesData.totalaug)}
                                                            placeholder="0"
                                                            className={classes.tableInput}
                                                            InputProps={{
                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                            }}
                                                        /></StyledTableCell>
                                                        <StyledTableCell align="right"><TextField
                                                            disabled
                                                            defaultValue={formatNumber(arraySalesData.totalsep)}
                                                            placeholder="0"
                                                            className={classes.tableInput}
                                                            InputProps={{
                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                            }}

                                                        /></StyledTableCell>
                                                        <StyledTableCell align="right"><TextField
                                                            disabled
                                                            defaultValue={formatNumber(arraySalesData.totaloct)}
                                                            placeholder="0"
                                                            className={classes.tableInput}
                                                            InputProps={{
                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                            }}

                                                        /></StyledTableCell>
                                                        <StyledTableCell align="right"><TextField
                                                            disabled
                                                            defaultValue={formatNumber(arraySalesData.totalnov)}
                                                            placeholder="0"
                                                            className={classes.tableInput}
                                                            InputProps={{
                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                            }}

                                                        /></StyledTableCell>
                                                        <StyledTableCell align="right"><TextField
                                                            disabled
                                                            defaultValue={formatNumber(arraySalesData.totaldec)}
                                                            placeholder="0"
                                                            className={classes.tableInput}
                                                            InputProps={{
                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                            }}

                                                        /></StyledTableCell>
                                                        <StyledTableCell align="right"><TextField
                                                            disabled
                                                            // defaultValue={row.dec}
                                                            defaultValue={arraySalesData.mainTotal}
                                                            placeholder="0"
                                                            className={classes.tableInput}
                                                            InputProps={{
                                                                endAdornment: <InputAdornment position="end">€</InputAdornment>,

                                                            }}
                                                        /></StyledTableCell>
                                                    </StyledTableRow>
                                                </TableFooter>
                                            </Table>
                                        </TableContainer>
                                    </DialogContent>

                                )}



                            </Droppable>
                        </DragDropContext>

                        <DialogActions className={classes.dialogActions}>
                            <Button onClick={saveRecord} className={`${classes.primaryButton}`} color="primary" variant="contained" size="small">Gravar</Button>
                        </DialogActions>
                    </div>


                    :
                    <label>Loading</label>

                }



            </Dialog>
        </React.Fragment>
    );
}
