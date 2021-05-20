import React from 'react';
import { makeStyles, withStyles, Theme } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Tabs from '@material-ui/core/Tabs';
import Tab from '@material-ui/core/Tab';
import Typography from '@material-ui/core/Typography';
import Box from '@material-ui/core/Box';
import MenuIcon from '@material-ui/icons/Menu';
import StarIcon from '@material-ui/icons/Star';
import MuiAccordion from '@material-ui/core/Accordion';
import MuiAccordionSummary from '@material-ui/core/AccordionSummary';
import MuiAccordionDetails from '@material-ui/core/AccordionDetails';
import ShoppingCartIcon from '@material-ui/icons/ShoppingCart';
import TextField from '@material-ui/core/TextField';
import InputAdornment from '@material-ui/core/InputAdornment';
import SearchIcon from '@material-ui/icons/Search';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';
import ArrowRightIcon from '@material-ui/icons/ArrowRight';
import '../../assets/FontAwesome/css/FontAwesome.css';


interface IProps {
  isMenuOpen: boolean;
}

const useStyles = makeStyles((theme: Theme) => ({
  root: {
    flexGrow: 1,
    position: 'absolute',
    zIndex: 9,
    top: 44,
    bottom: 0,
    width: 300,
    padding: 13,
    backgroundColor: '#ffffff',
    borderRight: '1px solid #dddddd',
    overflowY: "auto",
    transform: "translateX(-100%)",
    transition: "all 0.3s ease-in-out",
    "&.active":{
      transform: "translateX(0%)",
    }
  },
  customMenuHeader: {
    backgroundColor: '#ffffff',
    color: '#777777',
    boxShadow: 'none',
    '& .MuiTab-labelIcon': {
      minHeight: 48,
      // minWidth: '50%',
      zIndex: 9,
    },
    '& .MuiTab-wrapper': {
      flexDirection: 'row',
      textTransform: 'capitalize',
      color: '#0098d2',
      '& svg': {
        marginBottom: 2,
        marginRight: 6,
        '&:first-child': {
          marginBottom: 2,
        }
      }
    },
    '& button': {
      minWidth: 'auto',
      '&.Mui-selected .MuiTab-wrapper': {
        color: '#777777',
      },
    },
    '& .MuiTabs-indicator': {
      backgroundColor: '#ffffff',
      border: '1px solid #ddd',
      borderRadius: '6px 6px 0px 0px',
      borderBottom: 'none',
      height: '100%',
      width: '50%',
    }
  },
  tabBorder: {
    border: '1px solid #dddddd',
    marginTop: -1
  },
  // heading: {
  //   fontSize: theme.typography.pxToRem(15),
  //   fontWeight: theme.typography.fontWeightRegular,
  // },
  searchBox: {
    marginBottom: theme.spacing(2),
    "& .MuiOutlinedInput-root.Mui-focused .MuiOutlinedInput-notchedOutline": {
      borderColor: "#0098d2"
    },
    "& .MuiInputAdornment-root": {
      color: "#777777"
    }
  },
  list: {
    flexGrow: 1,
    padding: 0
  },
  listItem: {
    padding: "4px 0",
    color: "#0098d2"
  },
  listIcon: {
    minWidth: "auto",
    color: "#0098d2",
    marginRight: theme.spacing(0.5),
    '& .MuiSvgIcon-root': {
      fontSize: "0.875rem"
    },
    '& .icon': {
      fontSize: "0.875rem"
    }
  },
  listItemText: {
    '& .MuiTypography-root': {
      fontSize: "0.875rem",
      fontFamily: "Open sans"
    }
  },
  blankExpand:{
    '& .MuiAccordionSummary-expandIcon':{
      visibility: "hidden"
    }
  },
  noTabsData:{
    textAlign: "center",
    color: "#0098d2",
    paddingTop: theme.spacing(3),
    paddingBottom: theme.spacing(3),
    '& .MuiSvgIcon-root':{
      marginBottom: theme.spacing(1),
    },
    '& .MuiTypography-root':{
      fontWeight: "normal"
    }
  }
}));

interface TabPanelProps {
  children?: React.ReactNode;
  index: any;
  value: any;
}



function TabPanel(props: TabPanelProps) {
  const { children, value, index, ...other } = props;

  const classes = useStyles();

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`simple-tabpanel-${index}`}
      aria-labelledby={`simple-tab-${index}`}
      {...other}
      className={classes.tabBorder}
    >
      {value === index && (
        <Box p="13px">
          <Typography>{children}</Typography>
        </Box>
      )}
    </div>
  );
}

function a11yProps(index: any) {
  return {
    id: `simple-tab-${index}`,
    'aria-controls': `simple-tabpanel-${index}`,
  };
}

const Accordion = withStyles({
  root: {
    // border: '1px solid rgba(0, 0, 0, .125)',
    boxShadow: 'none',
    '&:not(:last-child)': {
      borderBottom: 0,
    },
    '&:before': {
      display: 'none',
    },
    '&$expanded': {
      margin: 'auto',
    },
  },
  expanded: {},
})(MuiAccordion);

const AccordionSummary = withStyles({
  root: {
    padding: 0,
    minHeight: "auto",
    '&$expanded': {
      minHeight: "auto",
    },
  },
  content: {
    margin: '0px 0',
    '&$expanded': {
      margin: '0px 0',
    },
  },
  expanded: {},
  expandIcon: {
    order: -1,
    padding: "6px 6px 6px 12px",
    color: "#0098d2",
    '&$expanded': {
      transform: "rotate(45deg)"
    }
  }
})(MuiAccordionSummary);

const AccordionDetails = withStyles((theme) => ({
  root: {
    padding: 0,
    paddingLeft: theme.spacing(5),
    paddingRight: 0
  }
}))(MuiAccordionDetails);

export default function SimpleTabs(props: IProps) {
  const classes = useStyles();
  const [value, setValue] = React.useState(0);

  const handleChange = (event: React.ChangeEvent<{}>, newValue: number) => {
    setValue(newValue);
  };

  return (
    <div className={`${classes.root} ${props.isMenuOpen ? "active" : ""}`}>
      <AppBar position="static" className={classes.customMenuHeader}>
        <Tabs variant="fullWidth" value={value} onChange={handleChange} aria-label="simple tabs example">
          <Tab label="Navegação" icon={<MenuIcon fontSize="small" />} {...a11yProps(0)} />
          <Tab label="Favoritos" icon={<StarIcon fontSize="small" />} {...a11yProps(1)} />
        </Tabs>
      </AppBar>
      <TabPanel value={value} index={0}>
        <TextField fullWidth size="small" className={classes.searchBox} id="outlined-basic" placeholder="Pesquisar item de menu" variant="outlined"
          InputProps={{
            startAdornment: (<InputAdornment position="start"><SearchIcon /></InputAdornment>)
          }}
        />
        <Accordion className={classes.blankExpand}>
          <AccordionSummary
            expandIcon={<ArrowRightIcon fontSize="small" />}
            IconButtonProps={{ edge: 'start' }}
            aria-controls="panel1a-content"
            id="panel1a-header"
          >
            <List className={classes.list} component="nav">
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fa fa-fw fa-compress-alt"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="Colapsar" />
              </ListItem>
            </List>
          </AccordionSummary>
          <AccordionDetails>
          </AccordionDetails>
        </Accordion>
        <Accordion className={classes.blankExpand}>
          <AccordionSummary
            expandIcon={<ArrowRightIcon fontSize="small" />}
            IconButtonProps={{ edge: 'start' }}
            aria-controls="panel2a-content"
            id="panel2a-header"
          >
            <List className={classes.list} component="nav">
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fa fa-fw fa-list-alt"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="Analises" />
              </ListItem>
            </List>
          </AccordionSummary>
          <AccordionDetails>
          </AccordionDetails>
        </Accordion>
        <Accordion className={classes.blankExpand}>
          <AccordionSummary
            expandIcon={<ArrowRightIcon fontSize="small" />}
            IconButtonProps={{ edge: 'start' }}
            aria-controls="panel2a-content"
            id="panel2a-header"
          >
            <List className={classes.list} component="nav">
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fa fa-fw fa-list-alt"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="Analises dinamicas" />
              </ListItem>
            </List>
          </AccordionSummary>
          <AccordionDetails>
          </AccordionDetails>
        </Accordion>
        <Accordion defaultExpanded>
          <AccordionSummary
            expandIcon={<ArrowRightIcon fontSize="small" />}
            IconButtonProps={{ edge: 'start' }}
            aria-controls="panel1a-content"
            id="panel1a-header"
          >
            <List className={classes.list} component="nav">
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fad fa-fw fa-comments"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="Comunicacao" />
              </ListItem>
            </List>
          </AccordionSummary>
          <AccordionDetails>
            <List className={classes.list} component="nav">
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fa fa-fw fa-pen-square"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="Mural" />
              </ListItem>
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fa fa-fw fa-comments"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="Chat" />
              </ListItem>
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fa fa-fw fa-comment-dots"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="SMS / Email" />
              </ListItem>
            </List>
          </AccordionDetails>
        </Accordion>
        <Accordion>
          <AccordionSummary
            expandIcon={<ArrowRightIcon fontSize="small" />}
            IconButtonProps={{ edge: 'start' }}
            aria-controls="panel1a-content"
            id="panel1a-header"
          >
            <List className={classes.list} component="nav">
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fa fa-fw fa-database"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="Stocks" />
              </ListItem>
            </List>
          </AccordionSummary>
          <AccordionDetails>
          </AccordionDetails>
        </Accordion>
        <Accordion>
          <AccordionSummary
            expandIcon={<ArrowRightIcon fontSize="small" />}
            IconButtonProps={{ edge: 'start' }}
            aria-controls="panel1a-content"
            id="panel1a-header"
          >
            <List className={classes.list} component="nav">
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fa fa-fw fa-joystick"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="Gabinete" />
              </ListItem>
            </List>
          </AccordionSummary>
          <AccordionDetails>
          </AccordionDetails>
        </Accordion>
        <Accordion>
          <AccordionSummary
            expandIcon={<ArrowRightIcon fontSize="small" />}
            IconButtonProps={{ edge: 'start' }}
            aria-controls="panel1a-content"
            id="panel1a-header"
          >
            <List className={classes.list} component="nav">
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fa fa-fw fa-shopping-cart"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="Compras" />
              </ListItem>
            </List>
          </AccordionSummary>
          <AccordionDetails>
          </AccordionDetails>
        </Accordion>
        <Accordion>
          <AccordionSummary
            expandIcon={<ArrowRightIcon fontSize="small" />}
            IconButtonProps={{ edge: 'start' }}
            aria-controls="panel1a-content"
            id="panel1a-header"
          >
            <List className={classes.list} component="nav">
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fa fa-fw fa-chart-line"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="Vendas" />
              </ListItem>
            </List>
          </AccordionSummary>
          <AccordionDetails>
          </AccordionDetails>
        </Accordion>
        <Accordion>
          <AccordionSummary
            expandIcon={<ArrowRightIcon fontSize="small" />}
            IconButtonProps={{ edge: 'start' }}
            aria-controls="panel1a-content"
            id="panel1a-header"
          >
            <List className={classes.list} component="nav">
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fa fa-fw fa-building"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="Oficina" />
              </ListItem>
            </List>
          </AccordionSummary>
          <AccordionDetails>
          </AccordionDetails>
        </Accordion>
        <Accordion>
          <AccordionSummary
            expandIcon={<ArrowRightIcon fontSize="small" />}
            IconButtonProps={{ edge: 'start' }}
            aria-controls="panel1a-content"
            id="panel1a-header"
          >
            <List className={classes.list} component="nav">
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fa fa-fw fa-euro-sign"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="Contas correntes" />
              </ListItem>
            </List>
          </AccordionSummary>
          <AccordionDetails>
          </AccordionDetails>
        </Accordion>
        <Accordion>
          <AccordionSummary
            expandIcon={<ArrowRightIcon fontSize="small" />}
            IconButtonProps={{ edge: 'start' }}
            aria-controls="panel1a-content"
            id="panel1a-header"
          >
            <List className={classes.list} component="nav">
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fa fa-fw fa-wrench"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="Caixa e Bancos" />
              </ListItem>
            </List>
          </AccordionSummary>
          <AccordionDetails>
          </AccordionDetails>
        </Accordion>
        <Accordion>
          <AccordionSummary
            expandIcon={<ArrowRightIcon fontSize="small" />}
            IconButtonProps={{ edge: 'start' }}
            aria-controls="panel1a-content"
            id="panel1a-header"
          >
            <List className={classes.list} component="nav">
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fa fa-fw fa-university"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="Utilitarios" />
              </ListItem>
            </List>
          </AccordionSummary>
          <AccordionDetails>
          </AccordionDetails>
        </Accordion>
        <Accordion>
          <AccordionSummary
            expandIcon={<ArrowRightIcon fontSize="small" />}
            IconButtonProps={{ edge: 'start' }}
            aria-controls="panel1a-content"
            id="panel1a-header"
          >
            <List className={classes.list} component="nav">
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fal fa-fw fa-table"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="Tabelas" />
              </ListItem>
            </List>
          </AccordionSummary>
          <AccordionDetails>
          </AccordionDetails>
        </Accordion>
        <Accordion>
          <AccordionSummary
            expandIcon={<ArrowRightIcon fontSize="small" />}
            IconButtonProps={{ edge: 'start' }}
            aria-controls="panel1a-content"
            id="panel1a-header"
          >
            <List className={classes.list} component="nav">
              <ListItem button className={classes.listItem}>
                <ListItemIcon className={classes.listIcon}>
                  <span className="icon fa fa-fw fa-cogs"></span>
                </ListItemIcon>
                <ListItemText className={classes.listItemText} primary="Administracao" />
              </ListItem>
            </List>
          </AccordionSummary>
          <AccordionDetails>
          </AccordionDetails>
        </Accordion>
      </TabPanel>
      <TabPanel value={value} index={1}>
        <div className={classes.noTabsData}>
          <StarIcon fontSize="large" />
          <Typography variant="h6">
            No Favoritos
          </Typography>
        </div>
      </TabPanel>
    </div>
  );
}