import React, { Component, useEffect, useState } from "react";
import { InputAdornment, Typography } from "@material-ui/core";
import { makeStyles, useTheme, Theme } from '@material-ui/core/styles';
import Input from '@material-ui/core/Input';
import InputLabel from '@material-ui/core/InputLabel';
import MenuItem from '@material-ui/core/MenuItem';
import FormControl from '@material-ui/core/FormControl';
import Select from '@material-ui/core/Select';
import Chip from '@material-ui/core/Chip';
import TextField from '@material-ui/core/TextField';
import GroupIcon from '@material-ui/icons/Group';
import StoreIcon from '@material-ui/icons/Store';
import ChevronLeftIcon from '@material-ui/icons/ChevronLeft';
import ChevronRightIcon from '@material-ui/icons/ChevronRight';
import DateRangeIcon from '@material-ui/icons/DateRange';
import IconButton from '@material-ui/core/IconButton';
import CloseIcon from '@material-ui/icons/Close';
import Badge from '@material-ui/core/Badge';
import { useDispatch, useSelector } from 'react-redux';
import { loadShops, loadUsers, saveFilter } from './../../store/actions/dashboardAction';
import NumberFormat from 'react-number-format';
import Loader from "react-loader-spinner";
import clsx from 'clsx';

interface dashboardProps {
  filterChanged: (event: any) => any
}

const useStyles = makeStyles((theme) => ({
  root: {
    '&.miniFilter': {
      '& .filter': {
        width: 50,
        [theme.breakpoints.down('sm')]: {
          position: "relative"
        }
      },
      '& .filterIcon': {
        display: "none"
      },
      '& .miniFilterIcon': {
        display: "block"
      }
    },
    '& .miniFilterIcon': {
      display: "none",
      marginLeft: -2,
      '& .miniToggleIcon': {
        marginRight: -8
      }
    }
  },
  loaderContainer: {
    textAlign: 'center',
    marginTop: '150px'

  },
  filter: {
    width: 250,
    backgroundColor: "#d2f3ff",
    padding: 15,
    borderRadius: 10,
    height: "100%",
    overflowY: "auto",
    [theme.breakpoints.down('sm')]: {
      position: "absolute",
      zIndex: 2
    },
  },
  title: {
    textTransform: "uppercase",
    fontWeight: "bold"
  },
  formControl: {
    marginTop: theme.spacing(3),
    width: "100%",
    '& label.Mui-focused': {
      color: "#0098d2"
    },
    '& .MuiFilledInput-root': {
      backgroundColor: "#FFF"
    },
    '& .MuiFilledInput-underline:after': {
      borderColor: "#0098d2"
    }
  },
  chips: {
    display: 'flex',
    flexWrap: 'wrap',
  },
  chip: {
    margin: 2,
    backgroundColor: "#0098d2",
    color: "#FFF",
    height: 24
  },
  noLabel: {
    marginTop: theme.spacing(3),
  },
  formControlInput: {
    backgroundColor: "#FFF"
  },
  toggleIcon: {
    color: "#0098d2",
    textAlign: "right",
    marginBottom: 20,
    cursor: "pointer",
    whiteSpace: "nowrap",
    '& .MuiSvgIcon-root': {
      marginLeft: "-12px"
    }
  },
  closeButton: {
    padding: 0
  },
  badgePrimary: {
    '& .MuiBadge-colorPrimary': {
      backgroundColor: "#0098d2"
    }
  },
  dateMini: {
    color: "#0098d2",
    fontWeight: "bold",
    fontSize: 10,
    marginLeft: -2
  }
}));

const ITEM_HEIGHT = 48;
const ITEM_PADDING_TOP = 8;

const names = [
  {
    id: 1,
    text: 'Loja 1'
  },
  {
    id: 2,
    text: 'Loja 2'
  },
  {
    id: 3,
    text: 'Loja 3'
  },
  {
    id: 4,
    text: 'Loja 4'
  },
  {
    id: 5,
    text: 'Loja 5'
  },
  {
    id: 6,
    text: 'Loja 6'
  }
];

function getStyles(name: string, theme: Theme) {
  return {
    fontWeight: theme.typography.fontWeightMedium
  };
}

export default function FilterDashboard(props: dashboardProps) {
  const dispatch = useDispatch();
  const classes = useStyles();
  const theme = useTheme();

  const [storesId, setStoresId] = React.useState<number[]>([]);
  const [usersId, setUsersId] = React.useState<number[]>([]);
  const [referenceDate, setReferenceDate] = React.useState<Date>(new Date());

  const [selectedstoreIdCount, setselectedstoreIdCount] = React.useState<number>();
  const [selecteduserIdCount, setselecteduserIdCount] = React.useState<number>();

  const payload: any = {
    storesId: [],
    usersId: [],
    referenceDate: new Date(),
    isSale: true
  }


  let year = payload.referenceDate.getFullYear();
  let month = (payload.referenceDate.getMonth() + 1) < 10 ? '0' + (payload.referenceDate.getMonth() + 1) : (payload.referenceDate.getMonth() + 1);
  let date = (payload.referenceDate.getDate()) < 10 ? '0' + payload.referenceDate.getDate() : payload.referenceDate.getDate();
  let datestr = year + '-' + month + '-' + date;

  const [filterstate, setFilterstate] = useState(payload);


  const HandleChangeStore = (event: React.ChangeEvent<{ value: any }>) => {

    let payload = savedFilter ? savedFilter : filterstate;

    setStoresId(event.target.value as number[]);
    let selecetdStoreIds: number[] = [];

    event.target.value.forEach((item: string) => {

      const id = dashboardData.shopdata.filter((x: any) => x.shopName == item)[0].id;
      selecetdStoreIds.push(id);

    });

    payload.storesId = selecetdStoreIds;
    setselectedstoreIdCount(selecetdStoreIds.length);
    dispatch(saveFilter(payload));
    setFilterstate(payload);
    props.filterChanged(payload);

  };

  const HandleChangeUser = (event: React.ChangeEvent<{ value: any }>) => {

    let payload = savedFilter ? savedFilter : filterstate;

    setUsersId(event.target.value as number[]);
    payload.usersId = [event.target.value];
    setselecteduserIdCount(payload.usersId.length);
    setFilterstate(payload);
    dispatch(saveFilter(payload));
    props.filterChanged(payload);
  };

  const HandleChangeDate = (event: React.ChangeEvent<{ value: any }>) => {

    let payload = savedFilter ? savedFilter : filterstate;

    setReferenceDate(event.target.value as Date);
    payload.referenceDate = new Date(event.target.value);
    setFilterstate(payload);
    dispatch(saveFilter(payload));
    props.filterChanged(payload);
  };

  const BindFilterDropdown = () => {

    useEffect(() => {
      //dashboard
      dispatch(loadShops(payload));
      dispatch(loadUsers(payload));
    }, [dispatch]);


  }

  const [age, setAge] = React.useState('');

  const handleChangeSingle = (event: React.ChangeEvent<{ value: unknown }>) => {
    setAge(event.target.value as string);
  };

  const [sidebar, setSidebar] = React.useState(false);

  BindFilterDropdown();

  const dashboardData: any = useSelector((state: any) => state.dashboard.dashboarddata);
  const savedFilter: any = useSelector((state: any) => state.dashboard.filterPayload);

  if (dashboardData.shopdata && dashboardData.shopdata.length > 0 && dashboardData.userdata && dashboardData.userdata.length > 0) {
    return (
      <aside className={`${classes.root} ${sidebar ? "miniFilter" : ""}`}>
        <div className={`${classes.filter} filter`}>
          <div className="miniFilterIcon">
            <div onClick={() => setSidebar(false)} className={`${classes.toggleIcon} miniToggleIcon`}>
              <ChevronRightIcon fontSize="small" />
              <ChevronRightIcon fontSize="small" />
              <ChevronRightIcon fontSize="small" />
            </div>
            <FormControl className={classes.formControl}>
              <Badge badgeContent={selectedstoreIdCount} color="primary" className={classes.badgePrimary}>
                <StoreIcon />
              </Badge>
            </FormControl>
            <FormControl className={classes.formControl}>
              <Badge badgeContent={selecteduserIdCount} color="primary" className={classes.badgePrimary}>
                <GroupIcon />
              </Badge>
            </FormControl>
            <FormControl className={classes.formControl}>
              <DateRangeIcon />
              <span className={`${classes.dateMini}`}></span>
            </FormControl>
          </div>
          <div className="filterIcon">
            <div onClick={() => setSidebar(true)} className={classes.toggleIcon}>
              <ChevronLeftIcon fontSize="small" />
              <ChevronLeftIcon fontSize="small" />
              <ChevronLeftIcon fontSize="small" />
            </div>
            <Typography variant="subtitle2" component="h6" className={classes.title}>
              Filtros:
            </Typography>
            <FormControl variant="filled" className={classes.formControl}>
              <InputLabel shrink id="demo-mutiple-chip-label">Lojas</InputLabel>
              <Select
                labelId="demo-mutiple-chip-label"
                id="demo-mutiple-chip"
                multiple
                value={storesId}
                onChange={HandleChangeStore}
                // input={<Input id="select-multiple-chip" />}
                displayEmpty
                renderValue={(selected) => (
                  <div className={classes.chips}>
                    {(selected as string[]).map((value) => (
                      <Chip key={value} label={value} className={classes.chip} />
                    ))}
                    {/* <IconButton size="small" color="inherit" edge="start" className={`${classes.closeButton} ml-1`} aria-label="menu">
                      <CloseIcon fontSize="small" />
                    </IconButton>                    */}
                  </div>
                )}
                MenuProps={{
                  anchorOrigin: {
                    vertical: "bottom",
                    horizontal: "right"
                  },
                  transformOrigin: {
                    vertical: "top",
                    horizontal: "right"
                  },
                  getContentAnchorEl: null,
                  PaperProps: {
                    style: {
                      maxHeight: ITEM_HEIGHT * 4.5 + ITEM_PADDING_TOP,
                      width: 220,
                    },
                  }
                }}
                startAdornment={
                  <InputAdornment position="start">
                    <StoreIcon />
                  </InputAdornment>
                }
              >
                {/* <MenuItem value="" disabled>Todos</MenuItem> */}
                {dashboardData.shopdata.map((name: any) => (
                  <MenuItem key={name.id} value={name.shopName}>
                    {name.shopName}
                  </MenuItem>
                ))}
              </Select>
            </FormControl>
            <FormControl variant="filled" className={classes.formControl}>
              <InputLabel shrink id="demo-simple-select-placeholder-label-label">
                Utilizadores
              </InputLabel>
              <Select
                labelId="demo-simple-select-placeholder-label-label"
                id="demo-simple-select-placeholder-label"
                value={usersId}

                onChange={HandleChangeUser}
                displayEmpty
                MenuProps={{
                  anchorOrigin: {
                    vertical: "bottom",
                    horizontal: "right"
                  },
                  transformOrigin: {
                    vertical: "top",
                    horizontal: "right"
                  },
                  getContentAnchorEl: null,
                  PaperProps: {
                    style: {
                      maxHeight: ITEM_HEIGHT * 4.5 + ITEM_PADDING_TOP,
                      width: 220,
                    },
                  }
                }}
                startAdornment={
                  <InputAdornment position="start">
                    <GroupIcon />
                  </InputAdornment>
                }
              >
                {dashboardData.userdata.map((item: any) => (
                  <MenuItem value={item.id}>{item.firstName}</MenuItem>
                ))}


              </Select>
            </FormControl>

            <FormControl className={classes.formControl}>
              <InputLabel shrink id="demo-date-label-label"></InputLabel>
              <TextField
                id="demo-date-label"
                type="date"
                onChange={HandleChangeDate}
                variant="filled"
                label="Data de Referência"
                defaultValue={datestr}
                InputLabelProps={{
                  shrink: true,
                }}
              />
            </FormControl>
          </div>
        </div>
      </aside>
    );
  }
  else {
    return (
      <div className={clsx(classes.loaderContainer)}>
        <Loader type="TailSpin" color="#5c6bc0" height={100} width={100} visible={true ? dashboardData.billing : false} />
      </div>
    )
  }





}
