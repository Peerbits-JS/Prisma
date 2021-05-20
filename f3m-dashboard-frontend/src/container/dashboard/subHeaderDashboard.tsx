import React, { useState, useEffect } from 'react';
import HeaderService from '../../services/F3M/header-service';
import { makeStyles } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import Button from '@material-ui/core/Button';
import IconButton from '@material-ui/core/IconButton';
import HomeIcon from '@material-ui/icons/Home';
import StarIcon from '@material-ui/icons/Star';
import CloseIcon from '@material-ui/icons/Close';
import ButtonGroup from '@material-ui/core/ButtonGroup';
import modalIcon from '../../assets/images/modal-icon.svg';
import CachedIcon from '@material-ui/icons/Cached';
import clsx from 'clsx';
import Divider from '@material-ui/core/Divider';
import MaxWidthDialog from '../../components/modal/modal';
import MoreVertIcon from '@material-ui/icons/MoreVert';
import { useDispatch, useSelector } from 'react-redux';
import { saveFilter } from './../../store/actions/dashboardAction';

interface dashboardProps {
  menu: any;
  filterChanged: (event: any) => any
}

const useStyles = makeStyles((theme) => ({
  root: {
    flexGrow: 1,
  },
  appBarCustom: {
    backgroundColor: "#fff",
    color: "#0098d2",
    boxShadow: "none"
  },
  menuButton: {
    marginRight: theme.spacing(1),
    '&.active': {
      backgroundColor: "#0098d2",
      color: "#fff",
      borderRadius: 3
    }
  },
  toolbarCustom: {
    minHeight: 56,
    paddingLeft: 13,
    paddingRight: 13
  },
  title: {
    fontWeight: "bold",
    color: "#212529",
    fontSize: "1.125rem"
  },
  toolbarRight: {
    flexGrow: 1,
    color: "#0098d2",
    display: 'flex',
    justifyContent: 'flex-end',
    alignItems: 'center',
    [theme.breakpoints.down('sm')]: {
      position: "absolute",
      top: 13,
      left: 0,
      right: 0,
      zIndex: -1,
      opacity: 0,
      visibility: "hidden",
      background: "#FFF",
      paddingLeft: 13,
      paddingRight: 13,
      transition: "all 0.3s ease-in-out",
      '&.active': {
        zIndex: 1,
        visibility: "visible",
        opacity: 1,
      }
    }
  },
  divider: {
    backgroundColor: "#999999"
  },
  primaryButton: {
    borderColor: "#0098d2",
    color: "#0098d2",
    minWidth: 85,
    '&:hover': {
      borderColor: "#0098d2",
      backgroundColor: "rgba(0, 152, 210, 0.04)"
    },
    '&.active': {
      backgroundColor: "rgba(0, 152, 210, 1)",
      color: "#FFF"
    }
  },
  toggleButton: {
    display: "none",
    [theme.breakpoints.down('sm')]: {
      display: "block"
    }
  }
}));

export default function SubHeaderDashboard(props: dashboardProps) {
  const classes = useStyles();
  const [open, setOpen] = React.useState(false);
  const [filterType, setFilterType] = React.useState('Venda');
  const [toolbarRightResponive, setToolbarRight] = React.useState(false);
  const [activeToggleButtonStar, setToggleButtonStar] = React.useState(false);
  const [activeToggleButtonHome, setToggleButtonHome] = React.useState(false);

  const payload = {
    storesId: [],
    usersId: [],
    referenceDate: new Date(),
    isSale: true
  }

  const dispatch = useDispatch();
  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const handleOnFilterChange = (type: string) => {

    let payload = savedFilter ? savedFilter : statepayload;

    if (type == 'Venda') {
      payload.isSale = true;
    }
    else {
      payload.isSale = false;
    }
    setStatepayload(payload);
    setFilterType(type);
    props.filterChanged(payload);
    dispatch(saveFilter(payload));
  }

  const [statepayload, setStatepayload] = useState(payload);

  const onClickReferesh = () => {
    
    props.filterChanged(savedFilter ? savedFilter : statepayload);

  }

  const onClickButtonStar = async () => {
    const response = activeToggleButtonStar
      ? await HeaderService.removeFavouriteMenu(props.menu.id)
      : await HeaderService.addFavouriteMenu({
        IDOpcao: props.menu.id,
        IDOpcaoAnterior: 0,
        CaminhoIcon: props.menu.icon,
        Descricao: props.menu.description,
        Acao: props.menu.action,
      });

    setToggleButtonStar(!activeToggleButtonStar);
  };

  const onClickButtonHome = async () => {

    const response = activeToggleButtonHome
      ? await HeaderService.removeHomePageMenu(props.menu.id)
      : await HeaderService.addHomePageMenu(props.menu.id);

    setToggleButtonHome(!activeToggleButtonHome)
  };

  const getFavouriteMenuAsync = async () => {

    const response = await HeaderService.getFavouriteMenu(props.menu.id);

    if (response) {
      setToggleButtonStar(Boolean(response));
    }
  }

  const getHomePageMenuAsync = async () => {

    const response = await HeaderService.getHomePageMenu(props.menu.id);

    if (response) {
      setToggleButtonHome(Boolean(response));
    }
  }

  useEffect(() => {

    if (props.menu) {
      getFavouriteMenuAsync();
      getHomePageMenuAsync();
    }
  }, [props.menu]);

  const savedFilter: any = useSelector((state: any) => state.dashboard.filterPayload);

  return (
    <div className={classes.root}>
      <AppBar position="static" className={classes.appBarCustom}>
        <Toolbar className={classes.toolbarCustom}>
          {/* <img src={logo} /> */}
          <IconButton size="small" edge="start" onClick={onClickButtonStar} className={`${classes.menuButton} ${activeToggleButtonStar ? "active" : ""}`} color="inherit" aria-label="menu">
            <StarIcon fontSize="small" />
          </IconButton>
          <IconButton size="small" edge="start" onClick={onClickButtonHome} className={`${classes.menuButton} ${activeToggleButtonHome ? "active" : ""}`} color="inherit" aria-label="menu">
            <HomeIcon fontSize="small" />
          </IconButton>
          <Typography variant="h6" component="h1" className={classes.title}>
            Dashboard Óticas Empresa
          </Typography>
          <IconButton onClick={() => setToolbarRight(true)} size="small" edge="start" className={`${classes.toggleButton} ml-auto`} aria-label="menu">
            <MoreVertIcon />
          </IconButton>
          <div className={`${classes.toolbarRight} ${toolbarRightResponive ? "active" : ""}`}>
            <Typography className="text-right lh-normal mr-3" variant="caption" display="block" >
              <small> Ver<br />Como </small>
            </Typography>
            <ButtonGroup className="btn-group" color="primary">
              <Button onClick={() => handleOnFilterChange('Venda')} size="small" className={clsx(classes.primaryButton, filterType === 'Venda' ? "active" : "")}>Venda</Button>
              <Button onClick={() => handleOnFilterChange('Margem')} size="small" className={clsx(classes.primaryButton, filterType === 'Margem' ? "active" : "")} >Margem</Button>
            </ButtonGroup>
            <div className="d-flex align-items-center ml-3">
              <Button onClick={handleClickOpen} size="small" color="inherit">
                <Typography className="text-right lh-normal mr-2 d-flex align-items-center text-capitalize" variant="caption">
                  <small> Definir<br />Objetivos </small>
                  <img className="ml-2" src={modalIcon} />
                </Typography>
              </Button>
              <Divider orientation="vertical" className={clsx(classes.divider, 'ml-2 mr-3')} flexItem />
              <IconButton size="small" edge="start" color="inherit" aria-label="menu" onClick={() => onClickReferesh()}>
                <CachedIcon />
              </IconButton>
            </div>
            <IconButton onClick={() => setToolbarRight(false)} size="small" edge="start" className={`${classes.toggleButton} ml-1`} aria-label="menu">
              <CloseIcon />
            </IconButton>
          </div>
        </Toolbar>
      </AppBar>
      <MaxWidthDialog isModalOpen={open} handleClose={handleClose} />
    </div>
  );
}
