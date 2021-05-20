import React from 'react';
import { makeStyles, withStyles } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Button from '@material-ui/core/Button';
import IconButton from '@material-ui/core/IconButton';
import MenuIcon from '@material-ui/icons/Menu';
import FullscreenIcon from '@material-ui/icons/Fullscreen';
import NotificationsIcon from '@material-ui/icons/Notifications';
import ExpandMoreIcon from '@material-ui/icons/ExpandMore';
import MoreVertIcon from '@material-ui/icons/MoreVert';
import logo from '../../assets/images/logo.png';
import Menu, { MenuProps } from '@material-ui/core/Menu';
import MenuItem from '@material-ui/core/MenuItem';
import MenuHeader from '../menu/menu';

const useStyles = makeStyles((theme) => ({
  root: {
    flexGrow: 1,
  },
  appBarCustom: {
    backgroundColor: "#fff",
    color: "#777777",
    boxShadow: "none",
    borderBottom: "1px solid #dddddd"
  },
  menuButton: {
  },
  toolbarCustom: {
    minHeight: 43,
    paddingLeft: 13,
    paddingRight: 13,
    flexWrap: "wrap",
    [theme.breakpoints.down('sm')]: {
    }
  },
  logo: {
    '& img':{
      height: 26,
    }
  },
  toolbarRight: {
    flexGrow: 1,
    display: 'flex',
    justifyContent: 'flex-end',
    alignItems: 'center',
    [theme.breakpoints.down('sm')]: {
      position: "absolute",
      top: 43,
      left: 0,
      right: 0,
      zIndex: -1,
      opacity: 0,
      visibility: "hidden",
      background: "#FFF",
      transform: "translateY(-100%)",
      paddingLeft: 13,
      paddingRight: 13,
      transition: "all 0.3s ease-in-out",
      borderBottom: "1px solid #dddddd",
      '&.active':{
        zIndex: 1,
        transform: "translateY(0%)",
        visibility: "visible",
        opacity: 1,
      }
    }
  },
  colorBoxMenu: {
    width: 22,
    height: 22,
    borderRadius: 4,
    backgroundColor: "#4caf50",
    marginRight: theme.spacing(1),
  },
  buttonHeader:{
    fontFamily: "Open Sans"
  },
  toggleButton:{
    display: "none",
    [theme.breakpoints.down('sm')]: {
      display: "block"
    }
  }
}));

const StyledMenu = withStyles({
  paper: {
    border: '1px solid #dadada',
    boxShadow: "0px 3px 8px rgb(0 0 0 / 8%)"
  },
})((props: MenuProps) => (
  <Menu
    elevation={0}
    getContentAnchorEl={null}
    anchorOrigin={{
      vertical: 'bottom',
      horizontal: 'right',
    }}
    transformOrigin={{
      vertical: 'top',
      horizontal: 'right',
    }}
    {...props}
  />
));

export default function Header() {
  const classes = useStyles();

  const [anchorEl, setAnchorEl] = React.useState<null | HTMLElement>(null);

  const handleClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    setAnchorEl(event.currentTarget);
  };

  const handleClose = () => {
    setAnchorEl(null);
  };

  const [toolbarRightResponive, setToolbarRight] = React.useState(false);
  const [toogleMenu, setMenu] = React.useState(false);

  return (
    <div className={classes.root}>
      <AppBar position="static" className={classes.appBarCustom}>
        <Toolbar className={classes.toolbarCustom}>
          <div className={`${classes.logo} mr-4`}>
            <img src={logo} />
          </div>
          <Button size="small" className={classes.buttonHeader} onClick={() => setMenu(!toogleMenu)} color="inherit" aria-label="menu">
            <MenuIcon fontSize="small" className="mr-2" /> Menu
          </Button>
          <IconButton onClick={() => setToolbarRight(!toolbarRightResponive)} size="small" edge="start" className={`${classes.toggleButton} ml-auto`} aria-label="menu">
            <MoreVertIcon />
          </IconButton>
          <div className={`${classes.toolbarRight} ${toolbarRightResponive ? "active" : ""}`}>
            <div className="mr-2 mr-sm-4">
              <Button size="small" className={classes.buttonHeader} color="inherit" aria-controls="empresa-menu" aria-haspopup="true" onClick={handleClick}>
                EMPRESA <ExpandMoreIcon />
              </Button>
              <StyledMenu
                id="empresa-menu"
                anchorEl={anchorEl}
                keepMounted
                open={Boolean(anchorEl)}
                onClose={handleClose}
              >
                <MenuItem onClick={handleClose}>Option 1</MenuItem>
                <MenuItem onClick={handleClose}>Option 2</MenuItem>
                <MenuItem onClick={handleClose}>Option 3</MenuItem>
              </StyledMenu>
            </div>
            <div className="mr-2 mr-sm-4">
              <Button size="small"  className={classes.buttonHeader} color="inherit" aria-controls="sede-menu" aria-haspopup="true" onClick={handleClick}>
                <span className={classes.colorBoxMenu}></span> SEDE <ExpandMoreIcon />
              </Button>
              <StyledMenu
                id="sede-menu"
                anchorEl={anchorEl}
                keepMounted
                open={Boolean(anchorEl)}
                onClose={handleClose}
              >
                <MenuItem onClick={handleClose}>Option 1</MenuItem>
                <MenuItem onClick={handleClose}>Option 2</MenuItem>
                <MenuItem onClick={handleClose}>Option 3</MenuItem>
              </StyledMenu>
            </div>
            <div className="mr-2 mr-sm-4">
              <Button size="small" className={classes.buttonHeader} color="inherit" aria-controls="marta-menu" aria-haspopup="true" onClick={handleClick}>
                Marta <ExpandMoreIcon />
              </Button>
              <StyledMenu
                id="marta-menu"
                anchorEl={anchorEl}
                keepMounted
                open={Boolean(anchorEl)}
                onClose={handleClose}
              >
                <MenuItem onClick={handleClose}>Option 1</MenuItem>
                <MenuItem onClick={handleClose}>Option 2</MenuItem>
                <MenuItem onClick={handleClose}>Option 3</MenuItem>
              </StyledMenu>
            </div>
            <IconButton size="small" edge="start" className="mr-2 mr-sm-4" aria-label="menu">
              <NotificationsIcon />
            </IconButton>
            <IconButton size="small" edge="start" className={classes.menuButton} aria-label="menu">
              <FullscreenIcon />
            </IconButton>
          </div>
        </Toolbar>
      </AppBar>
      <MenuHeader isMenuOpen={toogleMenu}/>
    </div>
  );
}
